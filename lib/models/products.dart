class Products {
  String? code;
  String? name;
  int? qty;
  String? productid;

  Products({
    this.code,
    this.name,
    this.qty,
    this.productid,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        code: json["code"],
        name: json["name"],
        qty: json["qty"],
        productid: json["productid"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "qty": qty,
        "productid": productid,
      };
}
