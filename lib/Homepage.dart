import 'dart:async';
import 'package:chatapp/Chat.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController _countryController = TextEditingController();

  final List<ChatMessages> messages = [];

  var openAI = OpenAI.instance.build(
      token: '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',//your own key
      orgId: "",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 3000)),
      enableLog: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openAI = OpenAI.instance;
  }

  Future<void> _sendMessage() async {
    ChatMessages newMessage = ChatMessages(
      text: _countryController.text,
      sender: 'user',
      img: 'assets/man.png',
      color: Colors.yellow.withOpacity(0.3),
    );

    setState(() {
      messages.insert(0,
          newMessage); // Insert at the beginning of the list to show new messages at the bottom.
    });
    _countryController.clear();

    final request = CompleteText(
        prompt: newMessage.text, model: TextDavinci3Model(), maxTokens: 200);

    final response = await openAI.onCompletion(request: request);
    ChatMessages BotMessage = ChatMessages(
      text: response!.choices[0].text,
      sender: 'Chatbot',
      img: 'assets/robot.png',
      color: Color.fromRGBO(224, 243, 250, 0.969),
    );

    setState(() {
      messages.insert(0,
          BotMessage); // Insert at the beginning of the list to show new messages at the bottom.
    });

    print(response!.choices[0].text);
  }

  Widget _textcomposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
              onSubmitted: (value) => _sendMessage(),
              controller: _countryController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined,color: Colors.yellow,),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      width: 1, color: Colors.yellow),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 1, color: Colors.green)),
                hintText: 'Enter Your Quiry',
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              )),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 10,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: IconButton(
                onPressed: () {
                  _sendMessage();
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                //color: Colors.amber,
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(
            left: 20,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('assets/robot.png',
                fit: BoxFit.cover,
              )),
        ),
        backgroundColor: Colors.yellow.withOpacity(0.8),
        title: ListTile(
          title: Text(
            'AR ChatGPT ',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
          ),
          subtitle: Row(
            children: [Text('online ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              CircleAvatar(
                radius: 3,
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: messages[index]);
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(),
                child: _textcomposer(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
