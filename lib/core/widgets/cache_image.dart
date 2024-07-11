import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  const CacheImage({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      url: url,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width ?? 60,
          height: height ?? 60,
          child: const Icon(Icons.error_outline_rounded),
        );
      },
      loadingBuilder: (context, progress) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (progress.isDownloading && progress.totalBytes != null)
              Text(
                  '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                  style: const TextStyle(color: Colors.teal)),
            SizedBox(
              width: width,
              height: height,
              child: CircularProgressIndicator(
                  color: Colors.teal, value: progress.progressPercentage.value),
            ),
          ],
        );
      },
    );
  }
}
