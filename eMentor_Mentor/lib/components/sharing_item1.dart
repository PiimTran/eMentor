import '../models/sharing/sharing.dart';
import '../screens/sharing_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharingItem1 extends StatelessWidget {
  Sharing sharing;

  SharingItem1(this.sharing);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SharingDetailScreen.routeName, arguments: sharing);
      },
      child: Container(
        width: 210.0,
        margin: EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              bottom: 15.0,
              child: Container(
                height: 120.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        sharing.sharingName,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(sharing.price.toString()),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      height: 180,
                      width: 180,
                      image: NetworkImage(sharing.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start: ${DateFormat.yMEd().format(sharing.startTime)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
