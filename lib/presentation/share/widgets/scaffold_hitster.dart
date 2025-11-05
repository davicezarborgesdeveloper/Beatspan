import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../resource/color_manager.dart';
import '../../resource/value_manager.dart';
import 'bubble_blur.dart';

class ScaffoldHitster extends StatefulWidget {
  final Color colorFst;
  final Color colorSnd;
  final int? bubbles;
  final Widget? child;
  final String sndRoute;
  const ScaffoldHitster({
    super.key,
    this.colorFst = Colors.black,
    this.colorSnd = Colors.black,
    required this.sndRoute,
    this.bubbles = 2,
    this.child,
  });

  @override
  State<ScaffoldHitster> createState() => _ScaffoldHitsterState();
}

class _ScaffoldHitsterState extends State<ScaffoldHitster> {
  late double sizeFst;
  late double sizeSnd;
  late double sizeTrd;

  List<Map<String, dynamic>> atr = <Map<String, dynamic>>[];
  @override
  void initState() {
    atr = [
      {
        'size': switch (widget.bubbles) {
          2 => AppSize.s250,
          3 => AppSize.s160,
          4 => AppSize.s190,
          _ => AppSize.zero,
        },
        'position': switch (widget.bubbles) {
          2 => [null, 235.0, -96.0, null], //left, top, right, bottom
          3 => [57.0, 13.0, null, null],
          4 => [8.0, 64.0, null, null],
          _ => 0,
        },
      },
      {
        'size': switch (widget.bubbles) {
          2 => AppSize.s150,
          3 => AppSize.s80,
          4 => AppSize.s80,
          _ => AppSize.zero,
        },
        'position': switch (widget.bubbles) {
          2 => [0.0, null, 0.0, 85.0], //left, top, right, bottom
          3 => [null, 0.0, 64.0, 100.0],
          4 => [null, 32.0, 12.0, 0.0],
          _ => 0,
        },
      },
      {
        'size': switch (widget.bubbles) {
          2 => AppSize.zero,
          3 => AppSize.s292,
          4 => AppSize.s170,
          _ => AppSize.zero,
        },
        'position': switch (widget.bubbles) {
          2 => [null, null, null, null], //left, top, right, bottom
          3 => [0.0, null, 0.0, 0.0],
          4 => [null, null, 20.0, 64.0],
          _ => 0,
        },
      }
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.help_outline,
            color: ColorManager.white,
            size: 42,
          ),
          onPressed: () {
            initFaqsModule();
            Navigator.of(context).pushNamed('/faq');
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              widget.sndRoute == '/close'
                  ? Navigator.pop(context)
                  : Navigator.of(context).pushNamed('/settings');
            },
            icon: Icon(
              widget.sndRoute == '/close'
                  ? Icons.cancel_outlined
                  : Icons.settings_outlined,
              color: ColorManager.white,
              size: 42,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          buildBackground(widget.colorFst, widget.colorSnd),
          widget.child != null ? widget.child! : const SizedBox(),
        ],
      ),
    );
  }

  Widget buildBackground(
    Color colorFst,
    Color colorSnd,
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorFst, colorSnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ...atr.map(
          (a) => Positioned(
            left: a['position'][0],
            top: a['position'][1],
            right: a['position'][2],
            bottom: a['position'][3],
            child: BubbleBlur(
              size: a['size'],
              color: ColorManager.white.withOpacity(.3),
              blur: 5,
            ),
          ),
        ),
      ],
    );
  }
}
