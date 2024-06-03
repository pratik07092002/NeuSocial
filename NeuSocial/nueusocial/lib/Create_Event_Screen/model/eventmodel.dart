class EventModel{
  String? EventId;

  DateTime? CreatedOn;
  DateTime? StartDate;
  DateTime? EndDate;
  String? name;
  String? desc;

  EventModel({this.CreatedOn , this.StartDate , this.EndDate , this.desc , this.name , this.EventId});

  EventModel.fromMap(Map<String , dynamic> map){
    EventId = map["EventId"];
    CreatedOn = map["CreatedOn"].toDate();
    StartDate = map["StartDate"].toDate();
    EndDate = map["EndDate"].toDate();
    name = map["name"];
    desc = map["desc"];

  }

  Map<String,dynamic> toMap(){
    return {
      "EventId" : this.EventId , 
      "CreatedOn" : this.CreatedOn , 
      "StartDate" : this.StartDate , 
      "EndDate" : this.EndDate , 
      "name" : this.name , 
      "desc" : this.desc 
    };
  }
}