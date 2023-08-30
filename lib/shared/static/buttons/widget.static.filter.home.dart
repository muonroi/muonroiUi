import 'package:flutter/material.dart';

import '../../settings/settings.colors.dart';
import '../../settings/settings.fonts.dart';
import '../../settings/settings.language_code.vi..dart';
import '../../settings/settings.main.dart';

class FilterByDateButton extends StatelessWidget {
  const FilterByDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height:
            MainSetting.getPercentageOfDevice(context, expectHeight: 40).height,
        child: PageView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorDefaults.mainColor,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        L(ViCode.allCommonStoriesTextInfo.toString()),
                        style: FontsDefault.h5.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: FontsDefault.inter),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorDefaults.secondMainColor,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        L(ViCode.commonStoriesOfDayTextInfo.toString()),
                        style: FontsDefault.h5.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: FontsDefault.inter),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorDefaults.secondMainColor,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        L(ViCode.commonStoriesOfWeekTextInfo.toString()),
                        style: FontsDefault.h5.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: FontsDefault.inter),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorDefaults.secondMainColor,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        L(ViCode.commonStoriesOfMonthTextInfo.toString()),
                        style: FontsDefault.h5.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: FontsDefault.inter),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}