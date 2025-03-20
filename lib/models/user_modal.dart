import 'package:equatable/equatable.dart';
import 'package:ristey/global_vars.dart';

class User extends Equatable {
  late String? About_Me = "";
  late String? Diet = "";
  late String? Disability = "";
  late String? Drink = "";
  late String? Education = "";
  late String? Height = "";
  late String? Income = "";
  late String? Partner_Prefs = "";
  late String? Smoke = "";
  late String? displayName = "";
  late String? email = "";
  late String? religion = "";
  late String? name = "";
  late String? surname = "";
  late String? phone = "";
  late String? gender = "";
  late String? KundaliDosh = "";
  late String? MartialStatus = "";
  late String? Profession = "";
  late String? Location = "";
  late String? city = "";
  late String? state = "";
  late String? country = "";
  late String? uid = "";
  late String? puid = "";
  late String? token = "";
  late int? dob = 0;
  late String? status = "";
  late String? verifiedStatus = "";
  late String? videoLink = "";
  late String? videoName = "";
  late String? connectivity = "";
  late String? timeofbirth = "";
  late String? placeofbirth = "";
  late String? isLogOut = "";
  late double? longitude = 76.8173;
  late double? latitude = 29.9451;
  late bool? isBlur;
  late List<dynamic>? imageUrls = [];
  // user();

  User({
    this.About_Me = "",
    this.uid = "",
    this.puid = "",
    this.Diet = "",
    this.Disability = "",
    this.isBlur,
    this.Drink = "",
    this.Education = "",
    this.Height = "",
    this.Income = "",
    this.Partner_Prefs = "",
    this.Smoke = "",
    this.displayName = "",
    this.email = "",
    this.religion = "",
    this.imageUrls,
    this.isLogOut,
    this.name = "",
    this.surname = "",
    this.gender = "",
    this.phone = "",
    this.placeofbirth = "",
    this.timeofbirth = "",
    this.KundaliDosh = "",
    this.MartialStatus = "",
    this.Profession = "",
    this.Location = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.token = "",
    this.dob = 0,
    this.status = "",
    this.videoLink = "",
    this.videoName = "",
    this.verifiedStatus = "",
    this.latitude = 29.9451,
    this.longitude = 76.8173,
  });

  @override
  List<Object?> get props => [
        About_Me,
        uid,
        puid,
        isLogOut,
        Diet,
        timeofbirth,
        placeofbirth,
        Disability,
        Drink,
        Education,
        Height,
        Income,
        Partner_Prefs,
        Smoke,
        displayName,
        email,
        religion,
        name,
        surname,
        phone,
        gender,
        KundaliDosh,
        MartialStatus,
        Profession,
        Location,
        city,
        state,
        country,
        imageUrls,
        dob,
        status,
        verifiedStatus,
        videoLink,
        videoName,
        token,
        longitude,
        latitude
      ];

  static User fromdoc(var doc) {
    User user = User(
        About_Me: doc.data().toString().contains('About_Me')
            ? doc.get('About_Me')
            : '',
        uid: doc.data().toString().contains('uid') ? doc.get('uid') : '',
        puid: doc.data().toString().contains('puid') ? doc.get('puid') : '',
        Diet: doc.data().toString().contains('Diet') ? doc.get('Diet') : '',
        Disability: doc.data().toString().contains('Disability')
            ? doc.get('Disability')
            : '',
        Drink: doc.data().toString().contains('Drink') ? doc.get('Drink') : '',
        Education: doc.data().toString().contains('Education')
            ? doc.get('Education')
            : '',
        Height:
            doc.data().toString().contains('Height') ? doc.get('Height') : '',
        Income:
            doc.data().toString().contains('Income') ? doc.get('Income') : '',
        Partner_Prefs: doc.data().toString().contains('Partner_Prefs')
            ? doc.get('Partner_Prefs')
            : '',
        Smoke: doc.data().toString().contains('Smoke') ? doc.get('Smoke') : '',
        displayName: doc.data().toString().contains('displayName')
            ? doc.get('displayName')
            : '',
        email: doc.data().toString().contains('email') ? doc.get('email') : '',
        religion: doc.data().toString().contains('religion')
            ? doc.get('religion')
            : '',
        imageUrls: doc.data().toString().contains('imageUrls')
            ? doc.get('imageUrls')
            : [],
        name: doc.data().toString().contains('name') ? doc.get('name') : '',
        surname:
            doc.data().toString().contains('surname') ? doc.get('surname') : '',
        gender:
            doc.data().toString().contains('gender') ? doc.get('gender') : '',
        KundaliDosh: doc.data().toString().contains('KundaliDosh')
            ? doc.get('KundaliDosh')
            : '',
        MartialStatus: doc.data().toString().contains('MartialStatus')
            ? doc.get('MartialStatus')
            : '',
        Profession: doc.data().toString().contains('Profession')
            ? doc.get('Profession')
            : '',
        Location: doc.data().toString().contains('Location')
            ? doc.get('Location')
            : '',
        city: doc.data().toString().contains('city') ? doc.get('city') : '',
        state: doc.data().toString().contains('state') ? doc.get('state') : '',
        country: doc.data().toString().contains('ccountry')
            ? doc.get('country')
            : '',
        phone: doc.data().toString().contains('phone') ? doc.get('phone') : '',
        dob: doc.data().toString().contains('dob') ? doc.get('dob') : 0,
        status:
            doc.data().toString().contains('status') ? doc.get('status') : '',
        verifiedStatus: doc.data().toString().contains('verifiedStatus')
            ? doc.get('verifiedStatus')
            : '',
        token: doc.data().toString().contains('token') ? doc.get('token') : '',
        videoLink: doc.data().toString().contains('videoLink')
            ? doc.get('videoLink')
            : '',
        videoName: doc.data().toString().contains('videoName')
            ? doc.get('videoName')
            : '',
        longitude: doc.data().toString().contains('longitude')
            ? doc.get('longitude')
            : 76.8173,
        latitude: doc.data().toString().contains('latitude')
            ? doc.get('latitude')
            : 29.9451);

    // print(user);
    return user;
  }

  User.fromJson(Map<String, dynamic> json)
      : About_Me = json['About_Me'],
        uid = json['uid'],
        puid = json['puid'],
        placeofbirth = json["placeofbirth"],
        timeofbirth = json['timeofbirth'],
        Diet = json['Diet'],
        Disability = json['Disability'],
        Drink = json['Drink'],
        Education = json['Education'],
        Height = json['Height'],
        Income = json['Income'],
        isLogOut = json['isLogOut'],
        Partner_Prefs = json['Partner_Prefs'],
        Smoke = json['Smoke'],
        displayName = json['displayName'],
        email = json['email'],
        religion = json['religion'],
        imageUrls = json['imageUrls'],
        name = json['name'],
        surname = json['surname'],
        gender = json['gender'],
        KundaliDosh = json['KundaliDosh'],
        MartialStatus = json['MartialStatus'],
        Profession = json['Profession'],
        Location = json['Location'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        token = json['token'],
        dob = json['dob'],
        status = json['status'],
        verifiedStatus = json['verifiedStatus'],
        videoLink = json['videoLink'],
        videoName = json['videoName'],
        phone = json['phone'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'About_Me': About_Me,
        'uid': uid,
        'puid': puid,
        'placeofbirth': placeofbirth,
        'timeofbirth': timeofbirth,
        'isLogOut': isLogOut,
        'Diet': Diet,
        'Disability': Disability,
        'Drink': Drink,
        'Education': Education,
        'Height': Height,
        'Income': Income,
        'Partner_Prefs': Partner_Prefs,
        'Smoke': Smoke,
        'displayName': displayName,
        'email': email,
        'religion': religion,
        'imageUrls': imageUrls,
        'name': name,
        'surname': surname,
        'gender': gender,
        'KundaliDosh': KundaliDosh,
        'MartialStatus': MartialStatus,
        'Profession': Profession,
        'Location': Location,
        'city': city,
        'state': state,
        'country': country,
        'phone': phone,
        'token': token,
        'dob': dob,
        'status': status,
        'videoLink': videoLink,
        'videoName': videoName,
        'verifiedStatus': verifiedStatus,
        'longitude': longitude,
        'latitude': latitude,
      };
}

class SearchDataList {
  List<String> Religion = [
    "Any",
    "Hindu",
    "Muslim",
    "Sikh",
    "Christian",
    "Buddhist",
    "Jewish",
    "Parsi",
    "Atheist",
    "Non Religious",
    "Other",
  ];
  List<String> KundaliDosh = [
    "Any",
    "Manglik",
    "Non-Manglik",
    "Anshik Manglik",
    "Do Not Know",
    "Do Not Believe",
  ];
  List<String> MaritalStatus = [
    "Any",
    "Unmarried",
    "Divorced",
    "Divorced With Children",
    "Widowed",
    "Widowed With Children",
    "Separated",
    "Annulled",
    if (userSave.religion == "Muslim") "Married",
    "Awaiting Divorce",
  ];
  List<String> Diet = [
    "Any",
    "Vegetarian",
    "Non-Vegetarian",
    "Occasionally Non-Veg",
    "Eggetarian",
    "Never Use Onion",
  ];
  List<String> Drink = [
    "Any",
    "Yes",
    "No",
    "Occasionally",
  ];
  List<String> Smoke = [
    "Any",
    "Yes",
    "No",
    "Occasionally",
  ];
  List<String> Disability = [
    "Any",
    "No Disability",
    "Physically Challenged",
    "Mentally Challenged",
    "Other",
  ];
  List<String> Height = [
    "3.0 Feet",
    "3.1 Feet",
    "3.2 Feet",
    "3.3 Feet",
    "3.4 Feet",
    "3.5 Feet",
    "3.6 Feet",
    "3.7 Feet",
    "3.8 Feet",
    "3.9 Feet",
    "3.10 Feet",
    "3.11 Feet",
    "4.0 Feet",
    "4.1 Feet",
    "4.2 Feet",
    "4.3 Feet",
    "4.4 Feet",
    "4.5 Feet",
    "4.6 Feet",
    "4.7 Feet",
    "4.8 Feet",
    "4.9 Feet",
    "4.10 Feet",
    "4.11 Feet",
    "5.0 Feet",
    "5.1 Feet",
    "5.2 Feet",
    "5.3 Feet",
    "5.4 Feet",
    "5.5 Feet",
    "5.6 Feet",
    "5.7 Feet",
    "5.8 Feet",
    "5.9 Feet",
    "5.10 Feet",
    "5.11 Feet",
    "6.0 Feet",
    "6.1 Feet",
    "6.2 Feet",
    "6.3 Feet",
    "6.4 Feet",
    "6.5 Feet",
    "6.6 Feet",
    "6.7 Feet",
    "6.8 Feet",
    "6.9 Feet",
    "6.10 Feet",
    "6.11 Feet",
    "7.0 Feet",
    "7.1 Feet",
    "7.2 Feet",
    "7.3 Feet",
    "7.4 Feet",
    "7.5 Feet",
    "7.6 Feet",
    "7.7 Feet",
    "7.8 Feet",
    "7.9 Feet",
    "7.10 Feet",
    "7.11 Feet",
    "8.0 Feet",
  ];

  List<String> Education = [
    "Any",
    "No Education",
    "Secondary",
    "Senior Secondary",
    "Graduation",
    "Diploma",
    "Post Graduation",
    "B.Ed",
    "M.Phil",
    "Ph.D",
    "MBBS",
    "Other",
  ];
  List<String> Profession = [
    "Any",
    "Business",
    "IAS",
    "IPS",
    "Govt. Job",
    "Private Job",
    "Public Sector Job",
    "Advocate",
    "Doctor",
    "CA",
    "Not Working",
    "Other",
  ];
  List<String> Income = [
    "Any",
    "No Income",
    "0-1 Lakh",
    "1-3 Lakh",
    "3-6 Lakh",
    "6-9 Lakh",
    "9-12 Lakh",
    "12-15 Lakh",
    "15-20 Lakh",
    "20-25 Lakh",
    "25-30 Lakh",
    "30-35 Lakh",
    "35-40 Lakh",
    "40-45 Lakh",
    "45-50 Lakh",
    "50-60 Lakh",
    "60-70 Lakh",
    "70-80 Lakh",
    "80-90 Lakh",
    "Above 90 Lakh",
    "Ask Directly",
  ];
}

class Friend {
  late String? fromUid = "";
  late String? toUid = "";
  late String? status = "";
  late String? date;

  Friend(
      {required this.date,
      required this.fromUid,
      required this.toUid,
      this.status = ""});

  static Friend fromdoc(var doc) {
    Friend friend = Friend(
      date: doc.get('date'),
      fromUid: doc.get('fromUid'),
      toUid: doc.get('toUid'),
      status: doc.data().toString().contains('status') ? doc.get('status') : '',
    );
    return friend;
  }

  Friend.fromJson(Map<String, dynamic> json)
      : fromUid = json['fromUid'],
        toUid = json['toUid'],
        status = json['status'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'fromUid': fromUid,
        'toUid': toUid,
        'status': status,
        'date': date,
      };
}

class ShortL {
  late String? fromUid = "";
  late String? toUid = "";
  // late String? status = "";
  late String? date;

  ShortL({
    required this.date,
    required this.fromUid,
    required this.toUid,
    // this.status = ""
  });

  static ShortL fromdoc(var doc) {
    ShortL friend = ShortL(
      date: doc.get('date'),
      fromUid: doc.get('fromUid'),
      toUid: doc.get('toUid'),
      // status: doc.data().toString().contains('status') ? doc.get('status') : '',
    );
    return friend;
  }

  ShortL.fromJson(Map<String, dynamic> json)
      : fromUid = json['formUid'],
        toUid = json['toUid'],
        // status = json['status'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'fromUid': fromUid,
        'toUid': toUid,
        // 'status': status,
        'date': date,
      };
}

class Report {
  late String? fromUid = "";
  late String? toUid = "";
  late String? status = "";
  late String? date;

  Report(
      {this.date,
      required this.fromUid,
      required this.toUid,
      this.status = ""});

  static Report fromdoc(var doc) {
    Report friend = Report(
      // date: doc.get('date'),
      fromUid: doc.get('fromUid'),
      toUid: doc.get('toUid'),
      status: doc.data().toString().contains('status') ? doc.get('status') : '',
    );
    return friend;
  }

  Report.fromJson(Map<String, dynamic> json)
      : fromUid = json['formUid'],
        toUid = json['toUid'],
        status = json['status'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'fromUid': fromUid,
        'toUid': toUid,
        'status': status,
        'date': date,
      };
}

class Block {
  late String? fromUid = "";
  late String? toUid = "";
  // late String? status = "";
  late String? date;

  Block({
    required this.date,
    required this.fromUid,
    required this.toUid,
    // this.status = ""
  });

  static Block fromdoc(var doc) {
    Block friend = Block(
      date: doc.get('date'),
      fromUid: doc.get('fromUid'),
      toUid: doc.get('toUid'),
      // status: doc.data().toString().contains('status') ? doc.get('status') : '',
    );
    return friend;
  }

  Block.fromJson(Map<String, dynamic> json)
      : fromUid = json['formUid'],
        toUid = json['toUid'],
        // status = json['status'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'fromUid': fromUid,
        'toUid': toUid,
        // 'status': status,
        'date': date,
      };
}

class FriendList {
  late List<dynamic>? sent = [];
  late List<dynamic>? received = [];

  FriendList({this.received, this.sent});

  static FriendList fromdoc(var doc) {
    FriendList fl = FriendList(
      // sent: doc.get("sent"),
      // received: doc.get("received"),
      sent: doc.data().toString().contains('sent') ? doc.get('sent') : [],
      received:
          doc.data().toString().contains('received') ? doc.get('received') : [],
    );
    return fl;
  }

  FriendList.fromJson(Map<String, dynamic> json)
      : sent = json['sent'],
        received = json['received'];
  Map<String, dynamic> toJson() => {
        'sent': sent,
        'received': received,
      };
}

class Blocklist {
  late List<dynamic>? users = [];
  // late List<dynamic>? received = [];

  Blocklist({this.users});

  static Blocklist fromdoc(var doc) {
    Blocklist fl = Blocklist(
      // sent: doc.get("sent"),
      // received: doc.get("received"),
      users: doc.data().toString().contains('users') ? doc.get('users') : [],
      // received:
      //     doc.data().toString().contains('received') ? doc.get('received') : [],
    );
    return fl;
  }

  Blocklist.fromJson(Map<String, dynamic> json) : users = json['users'];
  // received = json['received'];
  Map<String, dynamic> toJson() => {
        'users': users,
        // 'received': received,
      };
}

class ReportList {
  late List<dynamic>? users = [];
  // late List<dynamic>? received = [];

  ReportList({this.users});

  static ReportList fromdoc(var doc) {
    ReportList fl = ReportList(
      // sent: doc.get("sent"),
      // received: doc.get("received"),
      users: doc.data().toString().contains('users') ? doc.get('users') : [],
      // received:
      //     doc.data().toString().contains('received') ? doc.get('received') : [],
    );
    return fl;
  }

  ReportList.fromJson(Map<String, dynamic> json) : users = json['users'];
  // received = json['received'];
  Map<String, dynamic> toJson() => {
        'users': users,
        // 'received': received,
      };
}

class ShortList {
  late List<dynamic>? users = [];
  // late List<dynamic>? received = [];

  ShortList({this.users});

  static ShortList fromdoc(var doc) {
    ShortList fl = ShortList(
      // sent: doc.get("sent"),
      // received: doc.get("received"),
      users: doc.data().toString().contains('users') ? doc.get('users') : [],
      // received:
      //     doc.data().toString().contains('received') ? doc.get('received') : [],
    );
    return fl;
  }

  ShortList.fromJson(Map<String, dynamic> json) : users = json['users'];
  // received = json['received'];
  Map<String, dynamic> toJson() => {
        'users': users,
        // 'received': received,
      };
}

class SavedPref {
  List<String> AgeList = [];
  List<String> ReligionList = [];
  List<String> KundaliDoshList = [];
  List<String> MaritalStatusList = [];
  List<String> dietList = [];
  List<String> DrinkList = [];
  List<String> SmokeList = [];
  List<String> DisabilityList = [];
  List<String> HeightList = [];
  List<String> EducationList = [];
  List<String> ProfessionList = [];
  List<String> IncomeList = [];
  List<List<String>> LocatioList = [[], [], []];

  SavedPref({
    // this.AgeList,
    // this.ReligionLis,
    // this.KundaliDoshLis,
    // this.MaritalStatusLis,
    // this.dietLis,
    // this.DrinkLis,
    // this.SmokeLis,
    // this.DisabilityLis,
    // this.HeightLis,
    // this.EducationLis,
    // this.ProfessionLis,
    // this.IncomeLis,
    // this.LocatioLis,
    List<String>? AgeList,
    List<String>? ReligionList,
    List<String>? KundaliDoshList,
    List<String>? MaritalStatusList,
    List<String>? dietList,
    List<String>? DrinkList,
    List<String>? SmokeList,
    List<String>? DisabilityList,
    List<String>? HeightList,
    List<String>? EducationList,
    List<String>? ProfessionList,
    List<String>? IncomeList,
    List<List<String>>? LocatioList,
  })  : AgeList = AgeList ?? [],
        ReligionList = ReligionList ?? [],
        KundaliDoshList = KundaliDoshList ?? [],
        MaritalStatusList = MaritalStatusList ?? [],
        dietList = dietList ?? [],
        DrinkList = DrinkList ?? [],
        SmokeList = SmokeList ?? [],
        DisabilityList = DisabilityList ?? [],
        HeightList = HeightList ?? [],
        EducationList = EducationList ?? [],
        ProfessionList = ProfessionList ?? [],
        IncomeList = IncomeList ?? [],
        LocatioList = LocatioList ?? [[], [], []];

  static SavedPref fromdoc(var doc) {
    SavedPref fl = SavedPref(
      AgeList: doc.data().toString().contains('AgeList')
          ? doc.get('AgeList').cast<String>()
          : [],
      ReligionList: doc.data().toString().contains('ReligionList')
          ? doc.get('ReligionList').cast<String>()
          : [],
      KundaliDoshList: doc.data().toString().contains('KundaliDoshList')
          ? doc.get('KundaliDoshList').cast<String>()
          : [],
      MaritalStatusList: doc.data().toString().contains('MaritalStatusList')
          ? doc.get('MaritalStatusList').cast<String>()
          : [],
      dietList: doc.data().toString().contains('dietList')
          ? doc.get('dietList').cast<String>()
          : [],
      DrinkList: doc.data().toString().contains('DrinkList')
          ? doc.get('DrinkList').cast<String>()
          : [],
      SmokeList: doc.data().toString().contains('SmokeList')
          ? doc.get('SmokeList').cast<String>()
          : [],
      DisabilityList: doc.data().toString().contains('DisabilityList')
          ? doc.get('DisabilityList').cast<String>()
          : [],
      HeightList: doc.data().toString().contains('HeightList')
          ? doc.get('HeightList').cast<String>()
          : [],
      EducationList: doc.data().toString().contains('EducationList')
          ? doc.get('EducationList').cast<String>()
          : [],
      ProfessionList: doc.data().toString().contains('ProfessionList')
          ? doc.get('ProfessionList').cast<String>()
          : [],
      IncomeList: doc.data().toString().contains('IncomeList')
          ? doc.get('IncomeList').cast<String>()
          : [],
      LocatioList: doc.data().toString().contains('LocatioList')
          ? [
              doc.get('LocatioList0').cast<String>(),
              doc.get('LocatioList1').cast<String>(),
              doc.get('LocatioList2').cast<String>()
            ]
          : [[], [], []],
    );
    return fl;
  }

  SavedPref.fromJson(Map<String, dynamic> json)
      : AgeList = json['AgeList'].cast<String>(),
        ReligionList = json['ReligionList'].cast<String>(),
        KundaliDoshList = json['KundaliDoshList'].cast<String>(),
        MaritalStatusList = json['MaritalStatusList'].cast<String>(),
        dietList = json['dietList'].cast<String>(),
        DrinkList = json['DrinkList'].cast<String>(),
        SmokeList = json['SmokeList'].cast<String>(),
        DisabilityList = json['DisabilityList'].cast<String>(),
        HeightList = json['HeightList'].cast<String>(),
        EducationList = json['EducationList'].cast<String>(),
        ProfessionList = json['ProfessionList'].cast<String>(),
        IncomeList = json['IncomeList'].cast<String>(),
        LocatioList = [
          json['LocatioList0'].cast<String>(),
          json['LocatioList1'].cast<String>(),
          json['LocatioList2'].cast<String>()
        ];
  Map<String, dynamic> toJson() => {
        'AgeList': AgeList,
        'ReligionList': ReligionList,
        'KundaliDoshList': KundaliDoshList,
        'MaritalStatusList': MaritalStatusList,
        'dietList': dietList,
        'DrinkList': DrinkList,
        'SmokeList': SmokeList,
        'DisabilityList': DisabilityList,
        'HeightList': HeightList,
        'EducationList': EducationList,
        'ProfessionList': ProfessionList,
        'IncomeList': IncomeList,
        'LocatioList0': LocatioList[0],
        'LocatioList1': LocatioList[1],
        'LocatioList2': LocatioList[2],
      };
  isEmpty() {
    if (AgeList.isEmpty &&
        ReligionList.isEmpty &&
        KundaliDoshList.isEmpty &&
        MaritalStatusList.isEmpty &&
        dietList.isEmpty &&
        DrinkList.isEmpty &&
        SmokeList.isEmpty &&
        DisabilityList.isEmpty &&
        HeightList.isEmpty &&
        EducationList.isEmpty &&
        ProfessionList.isEmpty &&
        IncomeList.isEmpty &&
        LocatioList[0].isEmpty &&
        LocatioList[1].isEmpty &&
        LocatioList[2].isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

class QueryData {
  late String? email = "";
  late String? text = "";
  late String? status = "";
  // late String? date;

  QueryData(
      {this.email,
      this.text,
      // required this.status,
      this.status = ""});

  static QueryData fromdoc(var doc) {
    QueryData friend = QueryData(
      email: doc.get('email'),
      text: doc.get('text'),
      // status: doc.get('status'),
      status: doc.data().toString().contains('status') ? doc.get('status') : '',
    );
    return friend;
  }

  QueryData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        text = json['text'],
        status = json['status'];
  // date = json['date'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'text': text,
        'status': status,
        // 'date': date,
      };
}

class ImagePathInfo {
  String imageUrl;
  String imgpath = '';
  String imgname = '';
  int timestamp = 0;

  ImagePathInfo({
    required this.imageUrl,
    this.imgpath = '',
    this.imgname = '',
    this.timestamp = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'imgpath': imgpath,
      'imgname': imgname,
      'timestamp': timestamp,
    };
  }

  ImagePathInfo.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'],
        imgpath = json['imgpath'],
        imgname = json['imgname'],
        timestamp = json['timestamp'];
}

class ImageList {
  Set<ImagePathInfo>? imageDictionary = {};
  // late List<dynamic>? received = [];

  ImageList({this.imageDictionary});

  static ImageList fromdoc(var doc) {
    ImageList fl = ImageList(
      // sent: doc.get("sent"),
      // received: doc.get("received"),
      imageDictionary: doc.data().toString().contains('imageDictionary')
          ? doc.get('imageDictionary')
          : {},
      // received:
      //     doc.data().toString().contains('received') ? doc.get('received') : [],
    );
    return fl;
  }

  ImageList.fromJson(Map<String, dynamic> json)
      : imageDictionary = json['imageDictionary'];
  // received = json['received'];
  Map<String, dynamic> toJson() => {
        'imageDictionary': imageDictionary,
        // 'received': received,
      };

  bool doesUrlExistInSet(String url) {
    if (imageDictionary != null) {
      for (var imageInfo in imageDictionary!) {
        if (imageInfo.imageUrl == url) {
          return true;
        }
      }
    }

    return false;
  }

  String path(String url) {
    for (var imageInfo in imageDictionary!) {
      if (imageInfo.imageUrl == url) {
        return imageInfo.imgpath;
      }
    }
    return '';
  }
}
