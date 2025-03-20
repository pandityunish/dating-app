// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ristey/models/new_user_modal.dart';

class Filterusermodel {
  final NewUserModel newUserModel;
  final int matchvalue;
  Filterusermodel({
    required this.newUserModel,
    required this.matchvalue,
  });
}

class Matchusermodel {
  final NewUserModel newUserModel;
  final int kundalimatch;
  Matchusermodel({
    required this.newUserModel,
    required this.kundalimatch,
  });
}
