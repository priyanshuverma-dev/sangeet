import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaan/core/core.dart';
import 'package:savaan/functions/explore/controllers/explore_controller.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Savaan - Explore"),
        elevation: 5,
      ),
      body: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ExploreList(),
          ],
        ),
      ),
    );
  }
}

class ExploreList extends ConsumerWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getExploreDataProvider).when(
          data: (songs) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Text(songs[index].name);
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
