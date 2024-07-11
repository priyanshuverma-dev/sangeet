import 'package:flutter/material.dart';
import 'package:sangeet/core/widgets/cache_image.dart';

class TrendCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData badgeIcon;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onPlay;
  final bool explicitContent;
  final Color? accentColor;
  const TrendCard({
    super.key,
    required this.onTap,
    required this.image,
    this.accentColor,
    required this.title,
    required this.subtitle,
    required this.badgeIcon,
    required this.explicitContent,
    required this.onLike,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Card(
        surfaceTintColor: accentColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Badge(
                  backgroundColor:
                      explicitContent ? Colors.redAccent : Colors.teal,
                  label: Icon(
                    badgeIcon,
                    size: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CacheImage(
                      url: image,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            overflow: TextOverflow.fade,
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
