import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';

class MyLocalController extends GetxController {
  Locale initialLang = sharepref!.getString("lang") == "ar" 
    ? const Locale("ar", "SA") 
    : sharepref!.getString("lang") == "fr" 
      ? const Locale("fr", "FR") 
      : const Locale("en", "US");

  var currentLang = (sharepref?.getString("lang") ?? "en").obs;

  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    sharepref!.setString("lang", codeLang);
    currentLang.value = codeLang;
    Get.updateLocale(locale);
  }
}
