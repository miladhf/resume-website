import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resume_web/data/skills_data.dart';
import 'package:resume_web/models/skill.dart';
import 'package:resume_web/utils/utils.dart';
import 'package:resume_web/widgets/skills/skill_item.dart';

import '../../../widgets/assets/image_asset.dart';

class SkillsTab extends StatefulWidget {
  static bool isFirstRun = true;

  const SkillsTab({Key? key}) : super(key: key);

  @override
  _SkillsTabState createState() => _SkillsTabState();
}

class _SkillsTabState extends State<SkillsTab> {
  int skillsPerRow = 5;

  _firstRun() {
    SkillsTab.isFirstRun = false;
  }



  @override
  Widget build(BuildContext context) {
    easy.EasyLocalization.of(context)?.locale;
    var isDesktop = Utils.isDesktop(context);

    var skills = SkillsData.getSkills();
    List<List<Skill>> skillsList = [];
    List<Skill> temp = [];

    for (int i = 0; i < skills.length; i++) {
      temp.add(skills[i]);
      if (temp.length == skillsPerRow || i == skills.length - 1) {
        skillsList.add(temp.toList());
        temp.clear();
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ImageAsset(
          asset: 'assets/images/moon_background2.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: isDesktop ? -120 : -120,
          child: Opacity(
            opacity: 0.8,
            child: Animate(
              effects: SkillsTab.isFirstRun
                  ? [
                      MoveEffect(
                          begin: MoveEffect.neutralValue.copyWith(
                              dy: MediaQuery.of(context).size.height + 300),
                          duration: 4000.milliseconds,
                          curve: Curves.fastEaseInToSlowEaseOut),
                    ]
                  : [],
              onComplete: (c) {
                _firstRun();
              },
              child: ImageAsset(
                asset: 'assets/images/moon_background.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Animate(
          effects: SkillsTab.isFirstRun
              ? [
                  MoveEffect(
                      begin: MoveEffect.neutralValue.copyWith(dy: -500),
                      duration: 1200.milliseconds,
                      curve: Curves.fastOutSlowIn),
                ]
              : [],
          onComplete: (c) {
            _firstRun();
          },
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'skills'.tr(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 25,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      for (int i = 0; i < skillsList.length; i++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int j = 0; j < skillsList[i].length; j++)
                                  SkillItem(
                                    skill: skillsList[i][j],
                                    isEndOfList: j != skillsList[i].length - 1,
                                  )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}
