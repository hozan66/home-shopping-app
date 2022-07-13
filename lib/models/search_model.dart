class SearchModel {
  late bool status;
  dynamic message;
  late SearchData data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = SearchData.fromJson(json['data']);
  }
}

class SearchData {
  late int currentPage;
  List<SearchProduct> data = [];
  late String firstPageUrl;
  late int lastPage;
  late String lastPageUrl;
  late String path;
  late int perPage;
  late int total;

  SearchData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(SearchProduct.fromJson(element));
    });
    firstPageUrl = json['first_page_url'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    total = json['total'];
  }
}

class SearchProduct {
  late int id;
  late dynamic price;
  late String image;
  late String name;
  late String description;

  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
