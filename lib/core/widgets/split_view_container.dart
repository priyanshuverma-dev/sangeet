import 'package:flutter/material.dart';

class SplitViewContainer extends StatelessWidget {
  final Widget rightChild;
  final Widget leftChild;
  const SplitViewContainer({
    super.key,
    required this.rightChild,
    required this.leftChild,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      primary: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: leftChild,
              ),
              Visibility(
                visible: MediaQuery.of(context).size.width > 750,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: rightChild,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
