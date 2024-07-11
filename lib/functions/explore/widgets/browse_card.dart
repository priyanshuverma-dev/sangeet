import 'package:flutter/material.dart';
import 'package:sangeet/core/widgets/cache_image.dart';

class BrowseCard extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String title;
  final String subtitle;
  final bool explicitContent;
  final Color? accentColor;
  const BrowseCard({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.explicitContent,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: accentColor,
      margin: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 150,
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CacheImage(
                  url: image,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: explicitContent,
                    child: const Icon(
                      Icons.explicit,
                      size: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
