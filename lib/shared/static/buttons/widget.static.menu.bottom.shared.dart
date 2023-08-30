import 'package:flutter/material.dart';

import '../../settings/settings.colors.dart';
import '../../settings/settings.images.dart';
import '../../settings/settings.main.dart';

class TabBarCustom extends StatefulWidget {
  final BuildContext context;
  const TabBarCustom({super.key, required this.context});

  @override
  State<TabBarCustom> createState() => _TabBarCustomState();
}

class _TabBarCustomState extends State<TabBarCustom> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: TabBar(
        isScrollable: false,
        unselectedLabelColor: ColorDefaults.colorGrey200,
        indicatorColor: ColorDefaults.mainColor,
        labelColor: ColorDefaults.mainColor,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0
                  ? ColorDefaults.mainColor
                  : ColorDefaults.colorGrey200,
              size: MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                  .width,
            ),
          ),
          Tab(
            icon: SizedBox(
              width: MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                  .width,
              height:
                  MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                      .width,
              child: Image.asset(ImageDefault.bookBookmark2x,
                  color: _currentIndex == 1
                      ? ColorDefaults.mainColor
                      : ColorDefaults.colorGrey200,
                  fit: BoxFit.cover),
            ),
          ),
          const Row(
            children: [
              Spacer(),
            ],
          ),
          Tab(
            icon: SizedBox(
              width: MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                  .width,
              height:
                  MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                      .width,
              child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      _currentIndex == 3
                          ? ColorDefaults.mainColor
                          : ColorDefaults.colorGrey200,
                      BlendMode.srcIn),
                  child: Image.asset(
                    ImageDefault.freeBook2x,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Tab(
              icon: SizedBox(
            width: MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                .width,
            height: MainSetting.getPercentageOfDevice(context, expectWidth: 26)
                .width,
            child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    _currentIndex == 4
                        ? ColorDefaults.mainColor
                        : ColorDefaults.colorGrey200,
                    BlendMode.srcIn),
                child: Image.asset(
                  ImageDefault.userInfo2x,
                  fit: BoxFit.cover,
                )),
          )),
        ],
      ),
    );
  }
}