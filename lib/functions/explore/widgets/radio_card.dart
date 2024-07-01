import 'package:flutter/material.dart';
import 'package:sangeet/core/utils.dart';
import 'package:sangeet_api/models.dart';

class RadioCard extends StatelessWidget {
  final BrowseRadioModel radio;
  final VoidCallback onTap;
  const RadioCard({super.key, required this.radio, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 0,
      surfaceTintColor: hexToColor(radio.accentColor),
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
                foregroundImage: NetworkImage(radio.image),
              ),
              const SizedBox(height: 10),
              Text(
                radio.title,
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
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        radio.description ?? radio.language,
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: radio.explicitContent,
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
