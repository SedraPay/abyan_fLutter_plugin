#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint abyan_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'abyan_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
Abyan is an onboarding and KYC solution that helps businesses to verify their customers' identities and documents. This plugin allows you to integrate Abyan SDKs into your Flutter app.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'

  s.dependency 'Abyan', '~> 0.1.3'
  s.dependency 'Protobuf'
  s.dependency 'GoogleDataTransport'
  s.dependency 'GoogleMLKit/FaceDetection'
  s.dependency 'lottie-ios'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'abyan_plugin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
