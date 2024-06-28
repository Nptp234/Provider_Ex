class Product{
  int? id, price, catId;
  String? name, desc, img, catName;
  int quantity=0;

  Product({this.id, this.name, this.price, this.img, this.desc, this.catId, this.catName});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img': img,
      'des': desc,
      'catId': catId,
      'catName': catName,
    };
  }

  factory Product.fromJson(Map<String, dynamic> data) => Product(
    id: data['id'],
    name: data['name'],
    price: data['price'],
    img: data['img'],
    desc: data['des'],
    catId: data['catId'],
    catName: data['catName'],
  );
}