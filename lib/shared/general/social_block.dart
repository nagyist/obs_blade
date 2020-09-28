import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialEntry {
  final String svgPath;
  final IconData icon;
  final String link;
  final String linkText;
  final double iconSize;

  SocialEntry(
      {@required this.link,
      this.svgPath,
      this.icon,
      this.linkText,
      this.iconSize = 28.0})
      : assert(
            svgPath != null && icon == null || svgPath == null && icon != null);
}

class SocialBlock extends StatelessWidget {
  final List<SocialEntry> socialInfos;

  SocialBlock({@required this.socialInfos})
      : assert(socialInfos != null && socialInfos.length > 0);

  Future<void> _handleSocialTap(SocialEntry social) async {
    if (await canLaunch(social.link)) {
      await launch(social.link);
    } else {
      throw 'Could not launch ${social.link}';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> socialEntries = [];

    this.socialInfos.forEach((social) {
      socialEntries.add(
        GestureDetector(
          onTap: () => _handleSocialTap(social),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: social.iconSize,
                  child: social.icon != null
                      ? Icon(
                          social.icon,
                          size: social.iconSize,
                          color: Theme.of(context).iconTheme.color,
                        )
                      : SvgPicture.asset(
                          social.svgPath,
                          height: social.iconSize,
                          color: Theme.of(context).iconTheme.color,
                        ),
                ),
              ),
              Text(
                social.linkText ?? social.link,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: socialEntries,
    );
  }
}