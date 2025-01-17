import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resume_web/data/portfolio_data.dart';
import 'package:resume_web/models/portfolio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/utils.dart';
import '../../../widgets/portfolio/dialog_animations.dart';
import '../../../widgets/portfolio/porfolio_item.dart';
import '../../../widgets/portfolio/portfolio_images_dialog.dart';

class PortfolioTab extends StatefulWidget {
  static bool isFirstRun = true;

  const PortfolioTab({Key? key}) : super(key: key);

  @override
  _PortfolioTabState createState() => _PortfolioTabState();
}

class _PortfolioTabState extends State<PortfolioTab> {
  _firstRun() {
    PortfolioTab.isFirstRun = false;
  }

  _onViewPicsTap(Portfolio portfolio) {
    showScaleTranslateAnimatedDialog(
      context: context,
      child: PortfolioImagesDialog(
        photos: portfolio.photos,
        index: 0,
      ),
    );
  }

  _onDownloadLinkTap(Portfolio portfolio) {
    launchUrl(Uri.parse(((kIsWeb && kReleaseMode) ? 'assets/' : '') +
        portfolio.downloadLink.toString()));
  }

  @override
  Widget build(BuildContext context) {
    var isDesktop = Utils.isDesktop(context);
    EasyLocalization.of(context)?.locale;

    return Animate(
      effects: PortfolioTab.isFirstRun
          ? [
              FadeEffect(
                duration: 1500.ms,
              ),
            ]
          : [],
      onComplete: (c) {
        _firstRun();
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          children: [
            Center(
              child: Text(
                'portfolio'.tr(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isDesktop ? 35 : 30,
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              runSpacing: 50,
              spacing: 50,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                for (var portfolio in PortfolioData.getPortfolio())
                  PortfolioItem(
                    haveDownloadLink: portfolio.haveDownloadLink,
                    onViewPicsTap: () {
                      _onViewPicsTap(portfolio);
                    },
                    onDownloadLinkTap: () {
                      _onDownloadLinkTap(portfolio);
                    },
                    portfolio: portfolio,
                    showPicsButton: portfolio.showPicsButton,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
