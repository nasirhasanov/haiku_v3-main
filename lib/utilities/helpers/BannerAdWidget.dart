import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    // Create and load the BannerAd
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7464434031700151/5741038573',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide a fixed height to avoid layout issues even if the ad isn't loaded yet.
    return SizedBox(
      height: AdSize.banner.height.toDouble(),
      child: _isAdLoaded
          ? Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd),
      )
          : Container(
        color: Colors.transparent,
      ),
    );
  }
}