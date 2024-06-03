class UserModel {
  String? email;
  String? name;
  String? phonenumber;
  String? ProfilePicture;
  String? UserId;
  String? Username;
Map<String , dynamic>?  ComAdmin;
  

  UserModel(
      { this.UserId,
       this.email,
       this.name,
       this.phonenumber, 
       this.ProfilePicture , 
       this.Username , 
       this.ComAdmin});

  UserModel.fromMap(Map<String, dynamic> map) {
    Username = map["Username"];
    UserId = map["UserId"];
    name = map["name"];
    ProfilePicture = map["ProfilePicture"];
    email = map["email"];
    phonenumber = map["phonenumber"];
    ComAdmin = map["ComAdmin"];
  }

  Map<String, dynamic> toMap() {
    return {
      "Username" : this.Username , 
      "UserId": this.UserId,
      "name": this.name,
      "ProfilePicture": this.ProfilePicture,
      "email":this.email , 
      "phonenumber" : this.phonenumber , 
      "ComAdmin" : this.ComAdmin 
    };
  }
}