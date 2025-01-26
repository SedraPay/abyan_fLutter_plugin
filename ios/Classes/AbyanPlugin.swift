import Flutter
import UIKit
import Abyan
import AVFoundation

public class AbyanPlugin: NSObject, FlutterPlugin, AbyanJourneyDelegate, AbyanDocumentsDelegate, AbyanLivenessCheckDelegate, AbyanCloseJourneyDelegate, AbyanKYCDelegate, AbyanProductsDelegate {

    private var channel: FlutterMethodChannel?
    private var methodChannel: FlutterMethodChannel?
    private var journeyIDChannel: FlutterMethodChannel?
    private var productChannel: FlutterMethodChannel?
    private var formDataChannel: FlutterMethodChannel?
    private var scanCardIDChannel: FlutterMethodChannel?
    private var updateKYCChannel: FlutterMethodChannel?
    private var livenessCheckChannel: FlutterMethodChannel?
    private var closeJourneyChannel: FlutterMethodChannel?

    private var selectedProduct: Int?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AbyanPlugin()
        let messenger = registrar.messenger()

        instance.channel = FlutterMethodChannel(name: "createJourney", binaryMessenger: messenger)
        instance.methodChannel = FlutterMethodChannel(name: "didFinishCreatingJourneyWithError", binaryMessenger: messenger)
        instance.journeyIDChannel = FlutterMethodChannel(name: "journeyIdChannel", binaryMessenger: messenger)
        instance.productChannel = FlutterMethodChannel(name: "getProduct", binaryMessenger: messenger)
        instance.formDataChannel = FlutterMethodChannel(name: "getFormData", binaryMessenger: messenger)
        instance.scanCardIDChannel = FlutterMethodChannel(name: "scanCardIDChannel", binaryMessenger: messenger)
        instance.updateKYCChannel = FlutterMethodChannel(name: "updateKYCChannel", binaryMessenger: messenger)
        instance.livenessCheckChannel = FlutterMethodChannel(name: "livenessCheckChannel", binaryMessenger: messenger)
        instance.closeJourneyChannel = FlutterMethodChannel(name: "closeJourneyChannel", binaryMessenger: messenger)

        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createJourneyinAbyan":
            if let serverKey = call.arguments as? String {
                createJourneyinAbyan(serverKey: serverKey)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a string", details: nil))
            }
        case "fetchProduct":
            getProductData()
            result(nil)
        case "fetchFormData":
            if let id = call.arguments as? Int {
                getFormDataRequest(selectedProduct: id)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected an integer", details: nil))
            }
        case "scanCard":
            if let id = call.arguments as? Int {
                openCameraToScantheCard(documentType: id)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected an integer", details: nil))
            }
        case "scanfaceID":
            scanYourFace()
            result(nil)
        case "closeJourney":
            if let customerId = call.arguments as? String {
                closeJourneyRequest(customerID: customerId)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a string", details: nil))
            }
        case "updateKYC":
            updateKYCMethod(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Abyan SDK Methods

    private func createJourneyinAbyan(serverKey: String) {
        Abyan.shared.scannedDocuments = nil
        Abyan.shared.livenessImage = nil
        Abyan.shared.livenessImageId = nil
        Abyan.shared.imagesIds = nil
        Abyan.shared.delegate = self
        try? Abyan.shared.setSettings(serverKey: serverKey, serverURLString: "https://azmgateway.sedrapay.com/")
    }

    public func didGetNationalitiesWithSuccess(response: GetNationalities) {
        // Handle success
    }

    public func didGetNationalitiesWithError(error: AbyanError) {
        // Handle error
    }

    public func didGetCSPDInfoWithSuccess(response: GetCSPDInfoResponse) {
        // Handle success
    }

    public func didGetCSPDInfoWithError(error: AbyanError) {
        // Handle error
    }

    private func getProductData() {
        Abyan.product.delegate = self
        Abyan.product.getProducts()
    }

    private func getFormDataRequest(selectedProduct: Int) {
        self.selectedProduct = selectedProduct
        Abyan.product.getFormInfo(productID: selectedProduct)
    }

    private func openCameraToScantheCard(documentType: Int) {
        let configureCameraPage = ConfigureDocumentsCameraPage(
            cameraViewBackgroundColor: UIColor.black,
            topHintCameraLabelColor: UIColor.white,
            topHintCameraLabelTitle: "Camera",
            topHintCameraIsHidden: false,
            topHintCameraLabelNumberOfLines: 1,
            captureButtonImage: UIImage(named: "cameraIcons")
        )
        let configuration = ConfigureScanDocumentsViews(ConfigureDocumentsCameraPage: configureCameraPage)
        Abyan.documentsCheck.captureDocuments(
            nationality: Nationality(nationalityID: 0, isoCode: "0", name: "", nationalityIDTypes: []),
            documentType: NationalityIDType(typeID: documentType, name: .idCard, numberOfImages: 2),
            configuration: configuration
        )
        Abyan.documentsCheck.delegate = self
    }

    private func scanYourFace() {
        Abyan.livenessCheck.checkLiveness(viewController: self,detectOptions: [.blink, .lookRight, .lookLeft],isDetectionOptionsSorted: true) //Type of expression is ambiguous without a type annotation
        Abyan.livenessCheck.delegate = self
    }

    private func closeJourneyRequest(customerID: String) {
        Abyan.closeJourney.delegate = self
        Abyan.closeJourney.closeJourneyAPI(customerId: customerID)
    }

    private func updateKYCMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }
        do {
            let jsonData: Data = Data(arguments.utf8)
            let kycField: AbyanKYCDynamicField = try JSONDecoder().decode(AbyanKYCDynamicField.self, from: jsonData)
            Abyan.kyc.delegate = self
            Abyan.kyc.updateKYC(kycFields: [kycField])
            result(nil)
        } catch {
            result(FlutterError(code: "JSON_ERROR", message: "Error parsing JSON", details: nil))
        }
    }

    // MARK: - AbyanJourneyDelegate Methods

    public func didFinishCreatingJourneyWithError(error: AbyanError) {
        methodChannel?.invokeMethod("didFinishCreatingJourneyWithError", arguments: error.localizedDescription)
    }

    public func didFinishCreatingJourneyWithSuccess(journeyId: String) {
        journeyIDChannel?.invokeMethod("onJourneyIdReceived", arguments: journeyId)
    }

    // MARK: - AbyanDocumentsDelegate Methods

    public func didFinishWithError(error: AbyanError) {
        // Handle error
    }

    public func userFinishCapturingDocumentsWithError(documents: [AbyanDocument], error: AbyanError) {
        // Handle error
    }

    public func userFinishCapturingDocument(documents: [AbyanDocument]) {
        scanCardIDChannel?.invokeMethod("onDocumentsCaptured", arguments: [])
        Abyan.documentsCheck.extractData()
    }

    public func userFinishCapturingDocumentsWithResponse(documents: [AbyanDocument], response: AbyanDocumentVerificationResponse) {
        do {
            let jsonData: Data = try JSONEncoder().encode(response)
            let jsonString: String? = String(data: jsonData, encoding: .utf8)
            scanCardIDChannel?.invokeMethod("documentResponseData", arguments: jsonString)
            Abyan.kyc.delegate = self
            Abyan.kyc.getOCRKYCFields(fieldValues: [], productId: self.selectedProduct ?? 0)
        } catch {
            print("Failed to encode response to JSON: \(error.localizedDescription)")
        }
    }

    public func userFinishCapturingDocumentsWithError(documents: [AbyanDocument]) {
        // Handle error
    }

    public func userDidCloseCamera() {
        // Handle camera close
    }

    // MARK: - AbyanLivenessCheckDelegate Methods

    public func LivenessCheckPageError(error: AbyanError) {
        print(error)
    }

    public func cameraAccessDeniedError(error: AbyanError) {
        let alert = UIAlertController(
               title: "Camera Access Needed",
               message: "To use this feature, please allow camera access in Settings.",
               preferredStyle: .alert
           )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_) in
                Abyan.livenessCheck.checkLiveness(viewController: self, detectOptions: [.blink, .lookRight, .lookLeft], isDetectionOptionsSorted: true)
                Abyan.livenessCheck.delegate = self
            })
        })

        if let topController: UIViewController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }

    public func didPressCancel() {
        // Handle cancel
    }

    public func LivenessCheckDone() {
        // Handle liveness check done
    }

    public func didGetImageSuccessfully(data: UIImage) {
        Abyan.livenessCheck.uploadLivenessCheckImage()
    }

    public func didGetImageMatchingResponseSuccessfully(response: ImageMatchingResponse) {
        do {
            let jsonData: Data = try JSONEncoder().encode(response)
            let jsonString: String? = String(data: jsonData, encoding: .utf8)
            livenessCheckChannel?.invokeMethod("ImageMatchingResponseData", arguments: jsonString)
        } catch {
            print("Failed to encode response to JSON: \(error.localizedDescription)")
        }
    }

    public func didGetError(errorMessage: String) {
        // Handle error
    }

    // MARK: - AbyanCloseJourneyDelegate Methods

    public func didFinishCloseJourneyWithSuccess() {
        closeJourneyChannel?.invokeMethod("didFinishCloseJourneyWithSuccess", arguments: [])
    }

    public func didFinishCloseJourneyWithError(error: AbyanError) {
        // Handle error
    }

    // MARK: - AbyanKYCDelegate Methods

    public func didUpdateKYCSuccessfully() {
        // Handle KYC update success
    }

    public func kycFinishedWithError(error: AbyanError) {
        // Handle KYC error
    }

    public func kycFields(fields: [AbyanKYCFieldItem]) {
        do {
            let jsonData: Data = try JSONEncoder().encode(fields)
            let jsonString: String? = String(data: jsonData, encoding: .utf8)
            scanCardIDChannel?.invokeMethod("kycResponseData", arguments: jsonString)
        } catch {
            print("Failed to encode fields to JSON: \(error.localizedDescription)")
        }
    }

    // MARK: - AbyanProductsDelegate Methods

    public func productsFinishedWithError(error: AbyanError) {
        // Handle product error
    }

    public func products(products: ProductsResponse) {
        do {
            let jsonData: Data = try JSONEncoder().encode(products)
            let jsonString: String? = String(data: jsonData, encoding: .utf8)
            productChannel?.invokeMethod("onProductsReceived", arguments: jsonString)
        } catch {
            print("Failed to encode products to JSON: \(error.localizedDescription)")
        }
    }

    public func FormInfofields(fields: [IntegrationInfo]) {
        do {
            let jsonData: Data = try JSONEncoder().encode(fields)
            let jsonString: String? = String(data: jsonData, encoding: .utf8)
            formDataChannel?.invokeMethod("onFormDataReceived", arguments: jsonString)
        } catch {
            print("Failed to encode fields to JSON: \(error.localizedDescription)")
        }
    }

    public func EmptyFormInfofields() {
        formDataChannel?.invokeMethod("emptyFormInfofields", arguments: [])
    }
}
