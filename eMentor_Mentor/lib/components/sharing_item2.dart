import '../models/sharing/sharing.dart';
import '../screens/sharing_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharingItem2 extends StatelessWidget {
  final Sharing sharing;

  const SharingItem2({Key key, @required this.sharing}) : super(key: key);

// list view
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SharingDetailScreen.routeName, arguments: sharing);
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
            height: 140.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        child: Text(
                          sharing.sharingName,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '${sharing.price}',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'sharing.description',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 180.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Start: ${DateFormat.yMEd().format(sharing.startTime)} - ${DateFormat.Hm().format(sharing.startTime)}',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 15.0,
            bottom: 15.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                width: 110.0,
                image: NetworkImage(
                  sharing.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
