class Product{
  String? name;
  int? id;

  Product({this.name, this.id});

  Product.fromJson(Map<String, dynamic> json){
    name = json['name'];
    id = json['id'];
  }

  static List<Product> fromJsonList(List<dynamic> jsonList){
    List<Product> products = [];
    for(var json in jsonList){
      products.add(Product.fromJson(json));
    }
    return products;
  }
}