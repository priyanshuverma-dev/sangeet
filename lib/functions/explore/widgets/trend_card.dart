import 'package:flutter/material.dart';

class TrendCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData badgeIcon;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onPlay;
  final bool explicitContent;
  final Color? accentColor;
  const TrendCard({
    super.key,
    required this.onTap,
    required this.image,
    this.accentColor,
    required this.title,
    required this.subtitle,
    required this.badgeIcon,
    required this.explicitContent,
    required this.onLike,
    required this.onPlay,
  });

  @override
  State<TrendCard> createState() => _TrendCardState();
}

class _TrendCardState extends State<TrendCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation padding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
      reverseCurve: Curves.easeIn,
    ));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _controller.forward();
        });
      },
      onExit: (value) {
        setState(() {
          _controller.reverse();
        });
      },
      child: Card(
        surfaceTintColor: widget.accentColor,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Badge(
                      backgroundColor: widget.explicitContent
                          ? Colors.redAccent
                          : Colors.teal,
                      label: Icon(
                        widget.badgeIcon,
                        size: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.image,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                            Text(
                              widget.subtitle,
                              style: const TextStyle(
                                overflow: TextOverflow.fade,
                              ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                child: AnimatedScale(
                  curve: Curves.bounceOut,
                  alignment: Alignment.bottomRight,
                  duration: const Duration(microseconds: 100),
                  scale: _animation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconButton(
                          onPressed: widget.onLike,
                          icon: const Icon(
                            Icons.favorite,
                            size: 15,
                          ),
                          splashColor: Colors.red,
                          constraints:
                              const BoxConstraints(maxHeight: 35, maxWidth: 35),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconButton(
                          onPressed: widget.onPlay,
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 15,
                          ),
                          splashColor: Colors.teal,
                          constraints:
                              const BoxConstraints(maxHeight: 35, maxWidth: 35),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
