import 'package:flutter/material.dart';
import 'package:my_trips/widgets/CustomText.dart';

class buildPrivacyOption extends StatelessWidget {
  String title;
  String subTitle;
  IconData icon;
  bool isPublic;
  void Function()? onTap;

  buildPrivacyOption({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.isPublic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPublic ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPublic
                ? (title == 'Public' ? Colors.blue : Colors.amber)
                : Colors.grey.shade300,
            width: isPublic ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isPublic
                  ? (title == 'Public' ? Colors.blue : Colors.amber)
                  : Colors.grey,
            ),
            SizedBox(height: 8),
            Txt(
              txt: title,
              fntSize: 14,
              fontWeight: isPublic ? FontWeight.bold : FontWeight.normal,
              color: isPublic ? Colors.blue : Colors.grey,

            ),
            SizedBox(height: 4),
            Txt(
              txt: subTitle,
              fntSize: 10,
              color:Colors.grey,
              textAlign: TextAlign.center,

            ),




          ],
        ),
      ),
    );
  }
}
