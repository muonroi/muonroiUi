import 'package:flutter/material.dart';
import 'package:muonroi/features/chapters/provider/models.chapter.template.settings.dart';
import 'package:muonroi/features/chapters/settings/settings.dart';
import 'package:muonroi/shared/settings/enums/emum.key.local.storage.dart';
import 'package:muonroi/shared/static/buttons/widget.static.button.dart';
import 'package:muonroi/shared/settings/settings.colors.dart';
import 'package:muonroi/shared/settings/settings.dashboard.available.dart';
import 'package:muonroi/shared/settings/settings.fonts.dart';
import 'package:muonroi/shared/settings/settings.language_code.vi..dart';
import 'package:muonroi/shared/settings/settings.main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget.static.choose.font.color.chapter.bottom.dart';
import 'widget.static.chosse.font.family.chapter.bottom.dart';

class CustomDashboard extends StatefulWidget {
  const CustomDashboard({super.key});
  @override
  State<CustomDashboard> createState() => _CustomDashboardState();
}

class _CustomDashboardState extends State<CustomDashboard> {
  @override
  void initState() {
    _selectedRadio = KeyChapterButtonScroll.none;
    _fontSetting = FontsDefault.inter;
    _isSelected = [false, false];
    _templateAvailable = DashboardSettings.getDashboardAvailableSettings();
    _templateSettingData = TemplateSetting();
    _fontColor = ColorDefaults.thirdMainColor;
    _backgroundColor = ColorDefaults.lightAppColor;

    _initSharedPreferences();
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _templateSettingData = getCurrentTemplate(_sharedPreferences);
      _selectedRadio =
          _templateSettingData.locationButton ?? KeyChapterButtonScroll.none;
      _fontSetting = _templateSettingData.fontFamily ?? FontsDefault.inter;
      _isSelected[_sharedPreferences.getInt('align_index') ?? 0] = true;
      _fontColor =
          _templateSettingData.fontColor ?? ColorDefaults.thirdMainColor;
      _backgroundColor =
          _templateSettingData.backgroundColor ?? ColorDefaults.lightAppColor;
    });
  }

  late TemplateSetting _templateSettingData;
  late SharedPreferences _sharedPreferences;
  late String _fontSetting;
  late List<bool> _isSelected;
  late List<TemplateSetting> _templateAvailable;
  late KeyChapterButtonScroll _selectedRadio;
  late Color? _fontColor;
  late Color? _backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDefaults.secondMainColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorDefaults.secondMainColor,
        title: Title(
          color: ColorDefaults.thirdMainColor,
          child: Text(
            L(ViCode.customDashboardReadingTextInfo.toString()),
            style: FontsDefault.h5,
          ),
        ),
        leading: IconButton(
            splashRadius: 25,
            color: ColorDefaults.thirdMainColor,
            onPressed: () {
              Navigator.maybePop(context, true);
            },
            icon: backButtonCommon()),
        elevation: 0,
      ),
      body: Consumer<TemplateSetting>(
        builder: (context, templateValue, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Text(
                    L(ViCode.defaultDashboardTextInfo.toString()),
                    style:
                        FontsDefault.h5.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: MainSetting.getPercentageOfDevice(context,
                          expectHeight: 50)
                      .height,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _templateAvailable.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            templateValue.valueSetting =
                                _templateAvailable[index];
                            setCurrentTemplate(
                                _sharedPreferences, _templateAvailable[index]);
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  _templateAvailable[index].backgroundColor,
                              child: Text(
                                'AB',
                                style: TextStyle(
                                    color: _templateAvailable[index].fontColor),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
                Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Text(
                    L(ViCode.customAnotherDashboardTextInfo.toString()),
                    style:
                        FontsDefault.h5.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: const Icon(Icons.swipe_outlined)),
                                Text(
                                  L(ViCode.scrollConfigDashboardTextInfo
                                      .toString()),
                                  style: FontsDefault.h5,
                                )
                              ],
                            ),
                          ),
                          ToggleButton(
                            width: MainSetting.getPercentageOfDevice(context,
                                    expectWidth: 280)
                                .width,
                            height: MainSetting.getPercentageOfDevice(context,
                                    expectHeight: 40)
                                .height,
                            selectedColor: ColorDefaults.lightAppColor,
                            normalColor: ColorDefaults.thirdMainColor,
                            textLeft: L(ViCode
                                .scrollConfigVerticalDashboardTextInfo
                                .toString()),
                            textRight: L(ViCode
                                .scrollConfigHorizontalDashboardTextInfo
                                .toString()),
                            selectedBackgroundColor: ColorDefaults.mainColor,
                            noneSelectedBackgroundColor:
                                ColorDefaults.secondMainColor,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: const Icon(Icons
                                        .keyboard_double_arrow_down_outlined),
                                  ),
                                  Text(
                                    L(ViCode.buttonScrollConfigDashboardTextInfo
                                        .toString()),
                                    style: FontsDefault.h5,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: MainSetting.getPercentageOfDevice(
                                        context,
                                        expectWidth: 280)
                                    .width,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: KeyChapterButtonScroll.none,
                                            groupValue: _selectedRadio,
                                            onChanged: (value) {
                                              setState(() {
                                                var currentTemplate =
                                                    getCurrentTemplate(
                                                        _sharedPreferences);

                                                currentTemplate.locationButton =
                                                    value;

                                                templateValue.valueSetting =
                                                    currentTemplate;

                                                _selectedRadio = value ??
                                                    KeyChapterButtonScroll.none;
                                                setCurrentTemplate(
                                                    _sharedPreferences,
                                                    currentTemplate);
                                                templateValue.valueSetting =
                                                    currentTemplate;
                                              });
                                            },
                                          ),
                                          Text(
                                              L(ViCode
                                                  .buttonScrollConfigNoneDashboardTextInfo
                                                  .toString()),
                                              style: FontsDefault.h5),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: KeyChapterButtonScroll.show,
                                            groupValue: _selectedRadio,
                                            onChanged: (value) {
                                              setState(() {
                                                var currentTempLate =
                                                    getCurrentTemplate(
                                                        _sharedPreferences);

                                                currentTempLate.locationButton =
                                                    value ??
                                                        KeyChapterButtonScroll
                                                            .none;

                                                _selectedRadio = value ??
                                                    KeyChapterButtonScroll.none;
                                                setCurrentTemplate(
                                                    _sharedPreferences,
                                                    currentTempLate);

                                                templateValue.valueSetting =
                                                    currentTempLate;
                                              });
                                            },
                                          ),
                                          Text(
                                              L(ViCode
                                                  .buttonScrollConfigDisplayDashboardTextInfo
                                                  .toString()),
                                              style: FontsDefault.h5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child:
                                        const Icon(Icons.format_align_justify)),
                                Text(
                                  L(ViCode.alignConfigDashboardTextInfo
                                      .toString()),
                                  style: FontsDefault.h5,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MainSetting.getPercentageOfDevice(context,
                                    expectWidth: 280)
                                .width,
                            height: MainSetting.getPercentageOfDevice(context,
                                    expectHeight: 40)
                                .height,
                            child: ToggleButtons(
                              isSelected: _isSelected,
                              selectedColor: Colors.white,
                              color: ColorDefaults.thirdMainColor,
                              fillColor: ColorDefaults.mainColor,
                              splashColor: ColorDefaults.mainColor,
                              highlightColor: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                              children: [
                                SizedBox(
                                  width: MainSetting.getPercentageOfDevice(
                                          context,
                                          expectWidth: 135)
                                      .width,
                                  height: MainSetting.getPercentageOfDevice(
                                          context,
                                          expectHeight: 20)
                                      .height,
                                  child: Text(
                                    L(ViCode.alignConfigLeftDashboardTextInfo
                                        .toString()),
                                    style: const TextStyle(
                                        fontFamily: FontsDefault.inter,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: MainSetting.getPercentageOfDevice(
                                          context,
                                          expectWidth: 135)
                                      .width,
                                  height: MainSetting.getPercentageOfDevice(
                                          context,
                                          expectHeight: 20)
                                      .height,
                                  child: Text(
                                      L(ViCode
                                          .alignConfigRegularDashboardTextInfo
                                          .toString()),
                                      style: const TextStyle(
                                          fontFamily: FontsDefault.inter,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                              onPressed: (int newIndex) {
                                setState(() {
                                  for (int index = 0;
                                      index < _isSelected.length;
                                      index++) {
                                    if (index == newIndex) {
                                      var currentTempLate = getCurrentTemplate(
                                          _sharedPreferences);
                                      currentTempLate.isLeftAlign = true;
                                      _isSelected[index] = true;
                                      setCurrentTemplate(
                                          _sharedPreferences, currentTempLate);
                                      templateValue.valueSetting =
                                          currentTempLate;
                                      _sharedPreferences.setInt(
                                          'align_index', newIndex);
                                    } else {
                                      var currentTempLate = getCurrentTemplate(
                                          _sharedPreferences);
                                      currentTempLate.isLeftAlign = false;
                                      _isSelected[index] = false;
                                      setCurrentTemplate(
                                          _sharedPreferences, currentTempLate);
                                      templateValue.valueSetting =
                                          currentTempLate;
                                      _sharedPreferences.setInt(
                                          'align_index', newIndex);
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: const Icon(Icons.text_format)),
                                  Text(
                                    L(ViCode.fontConfigDashboardTextInfo
                                        .toString()),
                                    style: FontsDefault.h5,
                                  )
                                ],
                              ),
                            ),
                            Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: ColorDefaults.colorGrey200),
                                width: MainSetting.getPercentageOfDevice(
                                        context,
                                        expectWidth: 280)
                                    .width,
                                height: MainSetting.getPercentageOfDevice(
                                        context,
                                        expectHeight: 40)
                                    .height,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    templateValue.fontFamily ?? _fontSetting,
                                    style: FontsDefault.h5,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () => showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
                                      builder: (context) {
                                        return const ChooseFontPage();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: const Icon(
                                        Icons.color_lens_outlined,
                                      ),
                                    ),
                                    Text(
                                      L(ViCode.fontColorConfigDashboardTextInfo
                                          .toString()),
                                      style: FontsDefault.h5,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    builder: (context) {
                                      return ChooseFontColor(
                                        colorType: KeyChapterColor.font,
                                      );
                                    },
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          templateValue.fontColor ?? _fontColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: const Icon(
                                        Icons.colorize,
                                      ),
                                    ),
                                    Text(
                                      L(ViCode.backgroundConfigDashboardTextInfo
                                          .toString()),
                                      style: FontsDefault.h5,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    builder: (context) {
                                      return ChooseFontColor(
                                        colorType: KeyChapterColor.background,
                                      );
                                    },
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          templateValue.backgroundColor ??
                                              _backgroundColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}