import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/ads_service.dart';

class AdsServices extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Call your function here
    getallads();
  }

  void getallads() async {
    usersentreqads = adsuser.where((element) => element.adsid == "14").toList();
    userblockads = adsuser.where((element) => element.adsid == "16").toList();
    userunblockads = adsuser.where((element) => element.adsid == "17").toList();
    userreportads = adsuser.where((element) => element.adsid == "18").toList();
    userunreportads =
        adsuser.where((element) => element.adsid == "19").toList();
    usersortlistads =
        adsuser.where((element) => element.adsid == "20").toList();
    userunsortlistads =
        adsuser.where((element) => element.adsid == "21").toList();
    sentreqads = await AdsService().getallusers(adsid: "14");
    blockads = await AdsService().getallusers(adsid: "16");
    reportads = await AdsService().getallusers(adsid: "18");
    sortlistads = await AdsService().getallusers(adsid: "20");
    acceptads = await AdsService().getallusers(adsid: "22");
    rejectads = await AdsService().getallusers(adsid: "23");
    unblockads = await AdsService().getallusers(adsid: "17");
    unreportads = await AdsService().getallusers(adsid: "19");
    unsortlistads = await AdsService().getallusers(adsid: "21");
    navunblockads = await AdsService().getallusers(adsid: "97");
    interestads = await AdsService().getallusers(adsid: "91");
    cancelinterestads = await AdsService().getallusers(adsid: "92");
    receiveinterestads = await AdsService().getallusers(adsid: "93");
    acceptinterestads = await AdsService().getallusers(adsid: "94");
    declineads = await AdsService().getallusers(adsid: "95");
    navblockads = await AdsService().getallusers(adsid: "96");
    navreportads = await AdsService().getallusers(adsid: "98");
    navunreportads = await AdsService().getallusers(adsid: "99");
    navsortlistads = await AdsService().getallusers(adsid: "100");
    navunsortlistads = await AdsService().getallusers(adsid: "101");
  }
}
