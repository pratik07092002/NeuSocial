class RequestModel {
  String? SenderUserid;
  String? AdminUserid;
  bool? isAccepted; 
  String? SenderUsername;
  String? Communityname;
  String? Communityid;

  RequestModel({this.AdminUserid ,this.SenderUserid, this.isAccepted , this.SenderUsername , this.Communityname , this.Communityid});

  RequestModel.fromMap(Map<String, dynamic> map) {
    AdminUserid = map["AdminUserid"];
    SenderUserid = map["SenderUserid"];
    isAccepted = map["isAccepted"];
    Communityname = map["Communityname"];
    SenderUsername = map["SenderUsername"];
    Communityid = map["Communityid"];

   
    }
     Map<String, dynamic> tomap() {
      return {"AdminUserid": this.AdminUserid ,"SenderUserid": this.SenderUserid, "isAccepted": this.isAccepted , "SenderUsername" : this.SenderUsername , "Communityname" : this.Communityname , "Communityid" : this.Communityid };
  }
}