import 'package:flutter/material.dart';
import 'package:sangeet_api/models.dart';

class ChartCard extends StatelessWidget {
  final BrowseChartModel chart;
  final VoidCallback onTap;
  const ChartCard({super.key, required this.chart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.black,
                foregroundImage: NetworkImage(chart.image),
              ),
              const SizedBox(height: 10),
              Text(
                chart.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      chart.language,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: chart.explicitContent,
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
