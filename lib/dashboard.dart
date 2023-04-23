import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:maya_app/conversationList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maya_app/auth.dart';
import 'package:maya_app/chatDetail.dart';
import 'package:maya_app/dashboard.dart' show MyDash;
import 'package:maya_app/signup.dart' show MySign;
import 'package:maya_app/friends.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maya_app/friends.dart';
class MyDash extends StatelessWidget {
  const MyDash({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      title: 'Flutter Code Sample',
      home: MyStatefulWidget(),
    );
  }
}


Future<void> signOut() async {
  await Auth().signOut();
}

Widget _signOutButton(){
  return const ElevatedButton(onPressed: signOut, child: Text('Sign Out'));
}
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
List chatUsers = [
  ChatUser(
    name: "John",
    messageText: "Is there any thing wrong?",
    imageURL: "https://randomuser.me/api/portraits/men/1.jpg",
    time: "Now",
  ),
  // ChatUser(
  //   name: "Emma",
  //   messageText: "Hi, what's up?",
  //   imageURL: "https://randomuser.me/api/portraits/women/2.jpg",
  //   time: "10:30",
  // ),
  // ChatUser(
  //   name: "Oliver",
  //   messageText: "Long time no see!",
  //   imageURL: "https://randomuser.me/api/portraits/men/3.jpg",
  //   time: "Yesterday",
  // ),
  // ChatUser(
  //   name: "Sophie",
  //   messageText: "How was your weekend?",
  //   imageURL: "https://randomuser.me/api/portraits/women/4.jpg",
  //   time: "Yesterday",
  // ),
  // ChatUser(
  //   name: "Jack",
  //   messageText: "Can you send me that file?",
  //   imageURL: "https://randomuser.me/api/portraits/men/5.jpg",
  //   time: "Tuesday",
  // ),
  // ChatUser(
  //   name: "Isabella",
  //   messageText: "Thank you for your help!",
  //   imageURL: "https://randomuser.me/api/portraits/women/6.jpg",
  //   time: "Monday",
  // ),
  // ChatUser(
  //   name: "William",
  //   messageText: "Let's meet up soon!",
  //   imageURL: "https://randomuser.me/api/portraits/men/7.jpg",
  //   time: "Monday",
  // ),
  // ChatUser(
  //   name: "Ava",
  //   messageText: "I miss you!",
  //   imageURL: "https://randomuser.me/api/portraits/women/8.jpg",
  //   time: "Sunday",
  // ),
  // ChatUser(
  //   name: "Benjamin",
  //   messageText: "Do you have any plans for the weekend?",
  //   imageURL: "https://randomuser.me/api/portraits/men/9.jpg",
  //   time: "Saturday",
  // ),
  // ChatUser(
  //   name: "Charlotte",
  //   messageText: "Thanks for the invitation!",
  //   imageURL: "https://randomuser.me/api/portraits/women/10.jpg",
  //   time: "Friday",
  // ),
  // ChatUser(
  //   name: "Daniel",
  //   messageText: "What's your favorite movie?",
  //   imageURL: "https://randomuser.me/api/portraits/men/11.jpg",
  //   time: "Thursday",
  // ),
  // ChatUser(
  //   name: "Ella",
  //   messageText: "I love your new haircut!",
  //   imageURL: "https://randomuser.me/api/portraits/women/12.jpg",
  //   time: "Wednesday",
  // ),
  // ChatUser(
  //   name: "Frank",
  //   messageText: "Let's grab a coffee sometime.",
  //   imageURL: "https://randomuser.me/api/portraits/men/13.jpg",
  //   time: "Tuesday",
  // ),
  // ChatUser(
  //   name: "Grace",
  //   messageText: "Can I borrow your notes from class?",
  //   imageURL: "https://randomuser.me/api/portraits/women/14.jpg",
  //   time: "Monday",
  // ),
  // ChatUser(
  //   name: "Henry",
  //   messageText: "Are you free this weekend?",
  //   imageURL: "https://randomuser.me/api/portraits/men/15.jpg",
  //   time: "Sunday",
  // ),
];

class ChatUser {
  String name;
  String messageText;
  String imageURL;
  String time;

  ChatUser({required this.name, required this.messageText, required this.imageURL, required this.time});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Add the app bar
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
                    "Chats",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Add the search box
          Padding(
            padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey.shade100
                    )
                ),
              ),
            ),
          ),

          // Add the conversation list
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatDetailPage()));
                  },
                  child: ConversationList(
                    name: chatUsers[index].name,
                    messageText: chatUsers[index].messageText,
                    imageUrl: chatUsers[index].imageURL,
                    time: chatUsers[index].time,
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                  ),
                );
              },
            ),
          ),
        ],
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


// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Builder(
//                       builder: (BuildContext context) {
//                         return IconButton(
//                           icon:  const Icon(Icons.menu),
//                           onPressed: () {
//                             Scaffold.of(context).openDrawer();
//                           },
//                         );
//                       },
//                     ),
//                     const Text(
//                       "Search",
//                       style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Drawer Header',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Item 1'),
//               onTap: () {
//                 // Update the UI based on the selection.
//               },
//             ),
//             ListTile(
//               title: const Text('Item 2'),
//               onTap: () {
//                 // Update the UI based on the selection.
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignOutScreen extends StatelessWidget {
//   const SignOutScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Sign Out'),
//                   content: const Text('Are you sure you want to sign out?'),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text('Cancel'),
//                     ),
//                     const ElevatedButton(
//                       onPressed: signOut,
//                       child: Text('Sign Out'),
//                     ),
//                   ],
//         );
//   }
// }

class ImageViewScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? _name;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadImage();
    // _saveFriends();
  }

  Future<void> _loadName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    database
        .child('users')
        .child(user!.email!.replaceAll('.', ','))
        .child('name')
        .onValue
        .listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          _name = snapshot.value as String?;

        });
      }
    });
  }


  Future<void> _saveFriends() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DatabaseReference database = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user!.email!.replaceAll('.', ','))
        .child('friends');

    final friendsList = [
      FriendUser(
        name: "John Anthony Davis",
        imageURL: "https://randomuser.me/api/portraits/men/1.jpg",
      ),
      FriendUser(
        name: "Mark Anthony Simons",
        imageURL: "https://randomuser.me/api/portraits/men/2.jpg",
      ),
    ];

    for (var friend in friendsList) {
      await database.push().set({
        'name': friend.name,
        'imageURL': friend.imageURL,
      });
    }
  }



  Future<String?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.email!)
          .child('img');
      await ref.putFile(imageFile);
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }


  // final List<String> friendsList = [
  //   'friend1@example.com',
  //   'friend2@example.com',
  //   'friend3@example.com'
  // ];



  Future<void> _loadImage() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DatabaseReference database = FirebaseDatabase.instance.ref();

    // Listen for changes to the user's image URL
    database
        .child('users')
        .child(user!.email!.replaceAll('.', ','))
        .child('img')
        .onValue
        .listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          _imageUrl = snapshot.value as String;
        });
      }
    });

    // Add multiple friends using a for loop


    // for (int i = 0; i < friendsList.length; i++) {
    //   await database
    //       .child('users')
    //       .child(user!.email!.replaceAll('.', ','))
    //       .child('friends')
    //       .child('$i')
    //       .set(friendsList[i]);
    // }



// Add Paul as a friend of Ursa
//     await database
//         .child('users')
//         .child(userEmail)
//         .child('friends')
//         .push()
//         .set('paul@paul,paul');

  }


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
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
                      "Profile",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select an option'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text('View Image'),
                                onTap: () {
                                  // Navigate to a screen where the user can view the image
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewScreen(imageUrl: _imageUrl ?? ''),
                                    ),
                                  );
                                },
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: const Text('Replace Image'),
                                onTap: () async {
                                  // Open the image picker to let the user select a new image
                                  Navigator.pop(context);
                                  final String? imageUrl = await getImage();
                                  if (imageUrl != null) {
                                    setState(() {
                                      _imageUrl = imageUrl;
                                    });

                                    // Upload the new image to Firebase Storage
                                    final Reference ref = FirebaseStorage.instance
                                        .ref()
                                        .child('users')
                                        .child(FirebaseAuth.instance.currentUser!.email!)
                                        .child('img');
                                    final http.Response downloadData = await http.get(Uri.parse(_imageUrl ?? ''));
                                    final Uint8List bytes = downloadData.bodyBytes;
                                    await ref.putData(bytes);

                                    // Get the download URL for the uploaded image
                                    final String downloadUrl = await ref.getDownloadURL();

                                    // Update the user's profile with the new image URL
                                    final User? user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      await user.updatePhotoURL(downloadUrl);

                                      // Save the image URL to the Firebase Realtime Database
                                      final dbRef = FirebaseDatabase.instance.ref().child('users/${user.email!.replaceAll('.', ',')}/img');
                                      await dbRef.set(downloadUrl);

                                    }
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CachedNetworkImage(
                      imageUrl: _imageUrl ?? '',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(70.0),
                        child: Image.network(
                          'https://www.marismith.com/wp-content/uploads/2014/07/facebook-profile-blank-face-300x300.jpeg',
                          width: 120.0,
                          height: 120.0,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 65,
                        backgroundImage: imageProvider,
                      ),
                    ),

                    const SizedBox(height: 20),


                    Text(

                      _name ?? '',

                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


    const SizedBox(height: 8),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),

              ),
            ),




          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Options',
                style: TextStyle(
                  color: Colors.black,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signOut();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.exit_to_app),
      ),


    );
  }
}



class _MyStatefulWidgetState extends State<MyStatefulWidget> {



  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const SearchScreen(),
    const FriendsScreen(),
    const ProfileScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',

          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          //
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Friends',


          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Profile',

            ),
        ],
      ),
    );
  }
}
