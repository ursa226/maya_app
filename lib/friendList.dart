import 'package:flutter/material.dart';
import 'package:maya_app/chatDetail.dart';
class FriendList extends StatefulWidget{
  String name;
  String imageUrl;

  FriendList({super.key, required this.name,required this.imageUrl});
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatDetailPage(),
          ),
        );
      },
      child: Column(
        children: <Widget>[

          Container(
            padding: const EdgeInsets.only(left: 30, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        maxRadius: 20,
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.name, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 6,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
