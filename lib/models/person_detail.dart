class PersonDetail {
  String imageUrl;
  String name;
  bool isSelected;

  PersonDetail({this.imageUrl, this.name,this.isSelected});

  PersonDetail.fromJson(Map<dynamic, dynamic> json) {
    imageUrl = json['image_url'];
    name = json['name'];
    isSelected=json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['name'] = this.name;
    data['is_selected']=this.isSelected;
    return data;
  }
}