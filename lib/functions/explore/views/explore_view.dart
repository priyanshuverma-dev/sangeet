import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/widgets/blur_image_container.dart';
import 'package:sangeet/functions/explore/widgets/explore_list.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return const BlurImageContainer(
      image: 'assets/background.jpg',
      isAsset: true,
      child: ExploreList(),
    );
  }
}
