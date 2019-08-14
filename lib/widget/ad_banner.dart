import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:liriku/injector_widget.dart';

class AdBanner extends StatelessWidget {
  final bool isPadding;
  final AdmobBannerSize size;

  const AdBanner({Key key, this.isPadding = true, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ad = AdmobBanner(
      adUnitId: InjectorWidget.of(context).getConfig().adUnitId().itemList,
      adSize: this.size != null ? this.size : AdmobBannerSize.BANNER,
    );

    if (!isPadding) {
      return ad;
    }

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: ad,
      ),
    );
  }
}
