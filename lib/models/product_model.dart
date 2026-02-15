class ProductsModel {
  String? status;
  Meta? meta;
  List<Data>? data;

  ProductsModel({this.status, this.meta, this.data});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  String? title;
  String? description;
  String? copyright;
  String? generated;
  int? count;

  Meta({
    this.title,
    this.description,
    this.copyright,
    this.generated,
    this.count,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    copyright = json['copyright'];
    generated = json['generated'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['copyright'] = copyright;
    data['generated'] = generated;
    data['count'] = count;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? tagline;
  String? description;
  String? price;
  String? currency;
  String? image;
  Map<String, String>? specs;

  Data({
    this.id,
    this.name,
    this.tagline,
    this.description,
    this.price,
    this.currency,
    this.image,
    this.specs,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tagline = json['tagline'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    image = json['image'];
    specs = json['specs'] != null
        ? Map<String, String>.from(json['specs'])
        : {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tagline'] = tagline;
    data['description'] = description;
    data['price'] = price;
    data['currency'] = currency;
    data['image'] = image;
    return data;
  }

  double get priceValue {
    if (price == null) return 0;
    final cleaned = price!.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}
