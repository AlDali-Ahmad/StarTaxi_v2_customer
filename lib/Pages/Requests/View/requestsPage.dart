// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tawsella_final/Pages/orderCarPage.dart';
// import 'package:tawsella_final/Pages/pricesPage.dart';
// import 'package:tawsella_final/Pages/timerorderCar.dart';
// import 'package:tawsella_final/components/custom_botton.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/components/custom_text.dart';
// import 'package:tawsella_final/utils/app_colors.dart';

// class Requests extends StatefulWidget {
//   const Requests({Key? key}) : super(key: key);

//   @override
//   _RequestsState createState() => _RequestsState();
// }

// class _RequestsState extends State<Requests> {
//   bool _agreeToTerms = false;

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.blue[100],
//         title: const Text(
//           'قم بطلب سيارتك',
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: size.height / 9,
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.to(() => MovementTypesPage());
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: const CustomText(
//                     text: 'معلومات اكثر عن طلبات النقل في الشركة',
//                     alignment: Alignment.center,
//                   ),
//                 ),
//               ),
//               SizedBox(width: size.width / 1.1, child: const Divider()),
//               SizedBox(height: size.height / 15),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: const Text(
//                   //color: Colors.white,
//                   style: TextStyle(fontSize: 17),
//                   'بإمكانك طلب سيارة للنقل الداخلي داخل مناظق اعزاز او النقل الخارجي لجميع المناطق المحررة ',
//                   //alignment: Alignment.center,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: (size.height / 15) / 4),
//               CustomButton(
//                 onPressed: () {
//                   Get.to(() => const OrderCarPage());
//                 },
//                 text: 'طلب سيارة نقل داخلي / خارجي',
//               ),
//               SizedBox(height: (size.height / 7)),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: const Text(
//                   'بإمكانك طلب سيارة لمدة زمنية محددة',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: (size.height / 15) / 4),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: _agreeToTerms,
//                     onChanged: (value) {
//                       setState(() {
//                         _agreeToTerms = value ?? false;
//                       });
//                     },
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     checkColor: Colors.white,
//                     fillColor: MaterialStateProperty.resolveWith<Color>(
//                       (Set<MaterialState> states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return Colors.blue.shade200;
//                         }
//                         return Colors.white;
//                       },
//                     ),
//                   ),
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _agreeToTerms = !_agreeToTerms;
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           CustomText(
//                             text: 'قم باموافقة على ',
//                             color: Colors.black,
//                             fontSize: 14.0,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     contentPadding: EdgeInsets.all(0),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16.0),
//                                     ),
//                                     content: Container(
//                                       height: size.height / 3.5,
//                                       width: MediaQuery.of(context).size.width,
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(16.0),
//                                         color: Colors.white70,
//                                       ),
//                                       child: const Padding(
//                                         padding: EdgeInsets.only(
//                                             right: 20.0, top: 20),
//                                         child: Column(
//                                           children: [
//                                             CustomText(
//                                               text:
//                                                   'وجود شهادة سواقة لدى السائق',
//                                               alignment: Alignment.bottomRight,
//                                             ),
//                                             SizedBox(
//                                               height: 25,
//                                             ),
//                                             CustomText(
//                                               text: 'الضمانات : ',
//                                               alignment: Alignment.bottomRight,
//                                               color: Colors.red,
//                                             ),
//                                             SizedBox(
//                                               height: 15,
//                                             ),
//                                             CustomText(
//                                               text: 'كفيل معروف لدى الطرفين',
//                                               alignment: Alignment.bottomRight,
//                                             ),
//                                             CustomText(
//                                               text: 'او',
//                                               color: Colors.red,
//                                               alignment: Alignment.bottomRight,
//                                             ),
//                                             CustomText(
//                                               text:
//                                                   'إيداع مبلغ مادي بالدولار في المكتب',
//                                               alignment: Alignment.bottomRight,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 CustomText(
//                                   text: 'الاحكام المطلوبة لطلب سيارة',
//                                   color: Colors.blue.shade500,
//                                   fontSize: 14.0,
//                                 ),
//                                 // Container(
//                                 //     height: 1,
//                                 //     color: Colors.blue.shade300, // لون الخط
//                                 //     width:  // يمتد الخط على عرض النص
//                                 //     ),
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                 ],
//               ),
//               CustomButton(
//                 onPressed: () {
//                   _agreeToTerms != false
//                       ? Get.to(() => TimerPage())
//                       : CustomSnackbar.show(
//                           context,
//                           'الرجاء الموافقة على الاحكام اولا',
//                         );
//                 },
//                 text: 'طلب سيارة لمدة زمنية محددة',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'package:tawsella_final/Pages/Requests/View/orderCarPage.dart';
import 'package:tawsella_final/Pages/Requests/View/timerorderCar.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';

import 'package:tawsella_final/utils/app_colors.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bactawsilla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250.h,
              decoration: const BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                       'Select the type of service you want :'.tr,
                       style: TextStyle(fontSize: 16.sp,
                      color: Colors.yellow,),
                      
                    ),
                    SizedBox(height: 40.h),
                    LoadingButtonWidget(
                        text: 'Request a taxi'.tr,
                        onPressed: () {
                          Get.to(() => const OrderCarPage());
                        }),
                    SizedBox(height: 30.h),
                    LoadingButtonWidget(
                      text: 'Rent a car'.tr,
                      onPressed: () {
                        Get.to(TimerPage());
                      },
                      lodingColor: AppColors.textColor,
                      backgroundColor1: AppColors.white,
                      backgroundColor2: AppColors.white,
                      textColor: AppColors.orange2,
                      borderColor: AppColors.orange2,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
