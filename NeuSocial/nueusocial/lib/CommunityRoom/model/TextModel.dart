class messageMod {
  String? msgid;
  String? Sender;
  String? msg;
  DateTime? time;
  String? Senderid;

  messageMod({this.msgid,this.Sender, this.msg, this.time , this.Senderid});

  messageMod.fromMap(Map<String, dynamic> map) {
    msgid = map["msgid"];
    Sender = map["Sender"];
    msg = map["msg"];
    time = map["time"].toDate();
    Senderid = map["Senderid"];

   
    }
     Map<String, dynamic> tomap() {
      return {"msgid":msgid ,"Sender": Sender, "msg": msg, "time": time , "Senderid" : this.Senderid};
  }
}