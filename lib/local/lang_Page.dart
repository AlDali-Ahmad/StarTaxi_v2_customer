import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import '../components/Custom_text.dart';
import 'local_Controller.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final languageController = Get.put(MyLocalController());

    return Scaffold(
            appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title:Text(
          'Languages'.tr,
          style: TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height / 9,
              ),
              InkWell(
                onTap: () {
                  languageController.changeLang("ar");
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8, left: 18),
                  child: const CustomText(
                    text: 'العربية',
                    alignment: Alignment.topLeft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: size.width / 1.1, child: const Divider()),
              InkWell(
                onTap: () {
                  languageController.changeLang("en");
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8, left: 18),
                  child: const CustomText(
                    text: 'English',
                    alignment: Alignment.topLeft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(width: size.width / 1.1, child: const Divider()),

            ],
          ),
        ),
      ),
    );
  }
}
