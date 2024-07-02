import 'package:flutter/material.dart';

class TopDetailsContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color? badgeBackgroundColor;
  final Widget? badge;
  final AlignmentGeometry? badgeAlign;
  const TopDetailsContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.badgeBackgroundColor,
    this.badge,
    this.badgeAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badge(
          backgroundColor: badgeBackgroundColor,
          label: badge,
          alignment: badgeAlign,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 200,
              height: 200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
