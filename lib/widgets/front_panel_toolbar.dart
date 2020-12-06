import 'package:flutter/material.dart';
import 'package:player/utils/constants.dart';

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.expand_more,
              color: kPrimaryColor,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.queue_music,
                color: kDarkGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
