class CommunityModel{
String? name;
Map<String , dynamic>?  Members;
String? Profilepic;
String? Type;
String? Admin;
String? ComStatus; 
String? desc;
String? ComId;
String? Adminname;

CommunityModel({
   this.name , 
   this.Profilepic , 
   this.Admin , 
   this.Type , 
   this.Members , 
   this.ComStatus , 
   this.desc
  , 
  this.ComId , 
  this.Adminname
  });

  CommunityModel.fromMap(Map<String , dynamic> map){
    name = map["name"];
    Profilepic = map["profilepic"];
    Type = map["Type"];
    Admin = map["Admin"];
    Members = map["Members"];
    ComStatus = map["ComStatus"];
    desc = map["desc"];
    ComId = map["ComId"];
    Adminname = map["Adminname"];
  }

  Map<String , dynamic> tomap() {
    return {
      "name" : this.name , 
      "profilepic" : this.Profilepic , 
      "Type" : this.Type , 
      "Admin" : this.Admin ,
      "Members" : this.Members , 
      "ComStatus" : this.ComStatus , 
      "desc" : this.desc , 
      "ComId" : this.ComId , 
      "Adminname" : this.Adminname
     };
  }

}