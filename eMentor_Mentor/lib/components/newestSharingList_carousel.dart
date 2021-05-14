import './sharing_item1.dart';

import '../models/sharing/sharing.dart';

import 'package:flutter/material.dart';

class NewestSharingsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Newest sharings',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
            // height: 300,
            // child: ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: sharings.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     Sharing sharing = sharings[index];
            //     return SharingItem1(sharing);
            //   },
            // ),
            ),
      ],
    );
  }
}
