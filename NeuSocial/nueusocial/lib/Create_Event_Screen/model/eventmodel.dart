class EventModel{
  String? EventId;

  DateTime? CreatedOn;
  DateTime? StartDate;
  DateTime? EndDate;
  String? name;
  String? desc;
  String? Senderid;

  EventModel({this.CreatedOn , this.StartDate , this.EndDate , this.desc , this.name , this.EventId , this.Senderid});

  EventModel.fromMap(Map<String , dynamic> map){
    EventId = map["EventId"];
    CreatedOn = map["CreatedOn"].toDate();
    StartDate = map["StartDate"].toDate();
    EndDate = map["EndDate"].toDate();
    name = map["name"];
    desc = map["desc"];
    Senderid = map["Senderid"];

  }

  Map<String,dynamic> toMap(){
    return {
      "EventId" : this.EventId , 
      "CreatedOn" : this.CreatedOn , 
      "StartDate" : this.StartDate , 
      "EndDate" : this.EndDate , 
      "name" : this.name , 
      "desc" : this.desc  , 
      "Senderid" : this.Senderid
    };
  }
}