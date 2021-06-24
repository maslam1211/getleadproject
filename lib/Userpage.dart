import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ListExample extends StatefulWidget {
  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  Future<Userdata> getUserdatalist() async {
    var responce = await http.post(
      Uri.parse("https://demo1.getlead.co.uk/api/agent-app/dashboard-tasks"),
      headers: {
        "Authorization":
            "bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXBwLmdldGxlYWQuY28udWtcL2FwaVwvYWdlbnQtYXBwXC9sb2dpbiIsImlhdCI6MTYyMTA3MjE4NSwibmJmIjoxNjIxMDcyMTg1LCJqdGkiOiJtR2ZmTzB4YVJZbzJKaFpaIiwic3ViIjo1NjYsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.GezFkm4kHE2nsNnXx22EQcQmvhVQGzVjcu1Bv1bINCQ",
      },
    );

    if (responce.statusCode == 200) {
      print("status ok");
      return Userdata.fromJson(jsonDecode(responce.body));
    } else {
      return null;
    }
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          centerTitle: true,
          title: Text("ui"),
        ),
        drawer: Drawer(
        ),
        body: FutureBuilder(
          future: getUserdatalist(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Datum> list = snapshot.data.data.data;
              return ListView.builder(

                  itemCount:list.length,itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                    ),
                    title: Text(list[index].vchrCustomerName),
                    subtitle: Text(list[index].pkIntEnquiryId.toString(),style: TextStyle(color: Colors.blue),),
                        trailing: Text(list[index].createdDate,style: TextStyle(color: Colors.red),),

                  )),
                  
                );
              });
              //

            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

// To parse this JSON data, do
//
//     final userdata = userdataFromJson(jsonString);

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));

String userdataToJson(Userdata data) => json.encode(data.toJson());

class Userdata {
  Userdata({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  Data data;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.vchrCustomerMobile,
    this.pkIntEnquiryId,
    this.vchrCustomerName,
    this.vchrPurpose,
    this.vchrStatus,
    this.createdAt,
    this.createdDate,
  });

  String vchrCustomerMobile;
  int pkIntEnquiryId;
  String vchrCustomerName;
  VchrPurpose vchrPurpose;
  VchrStatus vchrStatus;
  DateTime createdAt;
  String createdDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vchrCustomerMobile: json["vchr_customer_mobile"],
        pkIntEnquiryId: json["pk_int_enquiry_id"],
        vchrCustomerName: json["vchr_customer_name"],
        vchrPurpose: vchrPurposeValues.map[json["vchr_purpose"]],
        vchrStatus: vchrStatusValues.map[json["vchr_status"]],

        createdAt: DateTime.parse(json["created_at"]),
        createdDate: json["created_date"],
      );

  Map<String, dynamic> toJson() => {
        "vchr_customer_mobile": vchrCustomerMobile,
        "pk_int_enquiry_id": pkIntEnquiryId,
        "vchr_customer_name": vchrCustomerName,
        "vchr_purpose": vchrPurposeValues.reverse[vchrPurpose],
        "vchr_status": vchrStatusValues.reverse[vchrStatus],
        "created_at": createdAt.toIso8601String(),
        "created_date": createdDate,
      };
}

enum VchrPurpose { TRAINING, WEBSITE_DESIGNING, NO_PURPOSE_MENTIONED }

final vchrPurposeValues = EnumValues({
  "No Purpose Mentioned": VchrPurpose.NO_PURPOSE_MENTIONED,
  "Training": VchrPurpose.TRAINING,
  "Website Designing": VchrPurpose.WEBSITE_DESIGNING
});

enum VchrStatus { CONTACTED, NONE }

final vchrStatusValues =
    EnumValues({"Contacted": VchrStatus.CONTACTED, "None": VchrStatus.NONE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
