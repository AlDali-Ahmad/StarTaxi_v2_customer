import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawsella_final/Pages/advertisements/data/advertisements_data.dart';
import 'package:tawsella_final/Pages/advertisements/model/advertisements.dart';
import 'package:tawsella_final/Pages/advertisements/model/advertisements_model.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

class AdvertisementsPage extends StatefulWidget {
  const AdvertisementsPage({super.key});

  @override
  State<AdvertisementsPage> createState() => _AdvertisementsPageState();
}

class _AdvertisementsPageState extends State<AdvertisementsPage> {
  Map<String, dynamic> responseData = {};
  List<Advertisements> advertisements = [];
  inject() async {
    responseData = await getadvertisements();
    advertisements = List<AdvertisementsModel>.from(
      (responseData['data'] as List).map(
        (e) => AdvertisementsModel.fromJson(e),
      ),
    );
    log(advertisements.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inject();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (advertisements.isEmpty)
          ? Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 4,
                  )),
            )
          : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: advertisements.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: FlipCard(
                      controller: FlipCardController(),
                      onTapFlipping: true,
                      rotateSide: RotateSide.right,
                      axis: FlipAxis.vertical,
                      frontWidget: Container(
                        height: 150.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                '${Url.url}${advertisements[index].image}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Image.network(
                            height: 40.h,
                            width: 40.w,
                            '${Url.urlImage}${advertisements[index].logo}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      backWidget: Container(
                        height: 150.h,
                        width: 200.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                            color: AppColors.iconColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              advertisements[index].title,
                              style: TextStyle(
                                color: AppColors.orange1,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Expanded(
                              child: Text(
                                advertisements[index].description,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
