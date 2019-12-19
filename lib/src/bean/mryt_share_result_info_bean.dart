class MrytShareResultInfoBean {
  String msg;
  bool success;
  String method;
  String operational;

  MrytShareResultInfoBean(
      {this.msg, this.success, this.method, this.operational});

  MrytShareResultInfoBean.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    success = json['success'];
    operational = json['operational'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['success'] = this.success;
    data['operational'] = this.operational;
    data['method'] = this.method;
    return data;
  }
}
