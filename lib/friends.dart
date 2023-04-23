import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maya_app/chatDetail.dart';
import 'package:maya_app/friendList.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class FriendUser {
  String name;
  String imageURL;
  FriendUser({required this.name, required this.imageURL});
}

Future<List<FriendUser>> _getFriends() async {
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference database = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(user!.email!.replaceAll('.', ','))
      .child('friends');

  final DatabaseEvent event = await database.once();
  final DataSnapshot snapshot = event.snapshot;

  final friendsList = <FriendUser>[];
  final Map<dynamic, dynamic>? values = snapshot.value as Map?;
  if (values != null) {
    values.forEach((key, value) {
      final friend = FriendUser(
        name: value['name'] ?? '',
        imageURL: value['imageURL'] ?? '',
      );
      friendsList.add(friend);
    });
  }
  return friendsList;
}


class _FriendsScreenState extends State<FriendsScreen> {
  final database = FirebaseDatabase.instance.ref();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    const Text(
                      "Friends",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: const <Widget>[
                Text(
                  "       Active Now",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _getFriends(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatDetailPage(),
                            ),
                          );
                        },
                        child: FriendList(
                          name: snapshot.data[index].name,
                          imageUrl: snapshot.data[index].imageURL,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the UI based on the selection.
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the UI based on the selection.
              },
            ),
          ],
        ),
      ),
    );
  }
}
