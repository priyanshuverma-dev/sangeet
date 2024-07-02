import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class ChartTopDetails extends StatelessWidget {
  final PlaylistModel chart;
  const ChartTopDetails({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Badge(
          backgroundColor:
              chart.explicitContent ? Colors.teal : Colors.transparent,
          label: Visibility(
            visible: chart.explicitContent,
            child: const Icon(
              Icons.explicit_rounded,
              size: 12,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              chart.images[1].url,
              width: 200,
              height: 200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chart.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  maxLines: 2,
                ),
                Text(
                  chart.subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "${chart.language}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .color!
                        .withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
