import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Skeletonizer(
        ignoreContainers: true,
        enabled: true,
        child: ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                    'Item number $index And The Song Name is This loading indicator'),
                subtitle: const Text('Subtitle here'),
                trailing: const Icon(
                  Icons.ac_unit,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loader(),
    );
  }
}
