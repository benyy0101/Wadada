import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MusicController extends StatefulWidget {
  const MusicController({
    super.key,
  });

  @override
  State<MusicController> createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.backward_fill, color: grayColor),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(color: grayColor),
          ),
          icon: Icon(
              isPlaying ? CupertinoIcons.play_fill : CupertinoIcons.pause_fill,
              color: grayColor),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.forward_fill, color: grayColor),
        ),
      ],
    );
  }
}
