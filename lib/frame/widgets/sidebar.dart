import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saavn/frame/commons.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends ConsumerWidget {
  final SidebarXController controller;
  const SideBar({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SidebarX(
      controller: controller,
      animationDuration: const Duration(milliseconds: 100),
      theme: sideBarTheme,
      extendedTheme: sidebarExtendedTheme,
      items: [
        SidebarXItem(
          label: 'Home',
          onTap: () => ref
              .watch(appScreenConfigProvider.notifier)
              .goto(screen: Screens.explore),
          iconBuilder: (selected, hovered) => iconBuilder(
            selected,
            hovered,
            Icons.home,
          ),
        ),
        SidebarXItem(
          label: 'Search',
          onTap: () => ref
              .watch(appScreenConfigProvider.notifier)
              .goto(screen: Screens.search),
          iconBuilder: (selected, hovered) => iconBuilder(
            selected,
            hovered,
            Icons.search,
          ),
        ),
      ],
      footerItems: [
        SidebarXItem(
          label: "Settings",
          onTap: () => ref
              .watch(appScreenConfigProvider.notifier)
              .goto(screen: Screens.settings),
          iconBuilder: (selected, hovered) => iconBuilder(
            selected,
            hovered,
            Icons.settings,
          ),
        )
      ],
    );
  }

  static SidebarXTheme sideBarTheme = SidebarXTheme(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blueGrey.withOpacity(.1),
      borderRadius: BorderRadius.circular(20),
    ),
    hoverColor: Colors.grey,
    itemTextPadding: const EdgeInsets.only(left: 20),
    selectedItemTextPadding: const EdgeInsets.only(left: 20),
    textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
    selectedTextStyle: const TextStyle(color: Colors.white),
    hoverTextStyle: const TextStyle(
      color: Colors.white,
    ),
  );

  static SidebarXTheme sidebarExtendedTheme = SidebarXTheme(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Colors.grey.withOpacity(.1),
    ),
  );
}

Widget iconBuilder(bool selected, bool hovered, IconData icon) {
  if (selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Icon(
      icon,
      color: Colors.grey,
      size: 30,
    ),
  );
}
