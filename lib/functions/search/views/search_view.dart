import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/functions/search/widgets/searchbar.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseSearchBar(
          controller: _searchController,
          onChanged: (value) {},
          onSubmit: (value) {},
        ),
        const Expanded(
          child: Center(
            child: Text('Search results will be displayed here!'),
          ),
        ),
      ],
    );
  }
}
