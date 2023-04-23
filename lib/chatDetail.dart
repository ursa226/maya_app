import 'package:flutter/material.dart';
import 'package:maya_app/chatMessageModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();

}





class _ChatDetailPageState extends State<ChatDetailPage> {




  // Future<void> _saveChatMessages() async {
  //   List<ChatMessage> messages = [
  //     ChatMessage(
  //       messageContent: "Hello, Marvin",
  //       messageType: "receiver",
  //       timeStamp: DateTime.parse('2022-09-23 09:30:00').toIso8601String(),
  //     ),
  //     ChatMessage(
  //       messageContent: "How have you been?",
  //       messageType: "receiver",
  //       timeStamp: DateTime.parse('2022-08-23 09:31:00').toIso8601String(),
  //     ),
  //     ChatMessage(
  //       messageContent: "Hey John, I am doing fine dude. wbu?",
  //       messageType: "sender",
  //       timeStamp: DateTime.parse('2022-07-23 09:32:00').toIso8601String(),
  //     ),
  //     ChatMessage(
  //       messageContent: "eh-hhh, doing OK.",
  //       messageType: "receiver",
  //       timeStamp: DateTime.parse('2022-06-23 09:33:00').toIso8601String(),
  //     ),
  //     ChatMessage(
  //       messageContent: "Is there anything wrong?",
  //       messageType: "sender",
  //       timeStamp: DateTime.parse('2022-05-23 09:34:00').toIso8601String(),
  //     ),
  //   ];
  //
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   final DatabaseReference database = FirebaseDatabase.instance
  //       .ref()
  //       .child('users')
  //       .child(user!.email!.replaceAll('.', ','))
  //       .child('messages');
  //
  //   for (var message in messages) {
  //     await database.push().set({
  //       'content': message.messageContent,
  //       'type': message.messageType,
  //       'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _saveChatMessages();
  // }

  List<ChatMessage> messages = [];

  Future<List<ChatMessage>> _getChatMessages() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DatabaseReference database = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user!.email!.replaceAll('.', ','))
        .child('messages');

    final DatabaseEvent event = await database.once();
    final DataSnapshot snapshot = event.snapshot;
    final chatMessages = <ChatMessage>[];
    final Map<dynamic, dynamic>? values = snapshot.value as Map?;
    if (values != null) {
      values.forEach((key, value) {
        final message = ChatMessage(
          messageContent: value['content'] ?? '',
          messageType: value['type'] ?? '',
          timeStamp: value['timestamp'].toString() ?? '', // Use 'timestamp' instead of 'timeStamp'
        );
        chatMessages.add(message);
      });
    }

    // Sort the messages by their time stamp in ascending order
    chatMessages.sort((a, b) => int.parse(a.timeStamp).compareTo(int.parse(b.timeStamp)));

    return chatMessages;
  }





  @override
  void initState() {
    super.initState();
    _getChatMessages().then((messages) {
      setState(() {
        this.messages = messages;
      });
    });
    // _saveChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.black,),
                ),
                const SizedBox(width: 2,),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("John Anthony Davis",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                const Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(messages[index].messageContent, style: const TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white,size: 18,),
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
}

