import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/componets/chat_bubble.dart';
import 'package:jms_desktop/componets/custom_textfeild.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/chat_services.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/Search_bar_widget.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> { // search fuction
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? user;
  final ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;
  Map<String, dynamic>? _selectedUser;
  bool _showLoader = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _loadUsers();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  void _loadUsers() async {
    List<Map<String, dynamic>>? data = await _firebaseService!.getAllUserData();
    if (mounted) {
      setState(() {
        user = data;
      });
    }

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: UserListWidget(),
            ),
            Expanded(
              flex: 3,
              child: _isDetailsVisible
                  ? SelectedUserDetailsWidget(selectedUser: _selectedUser)
                  : Container(
                      child: Center(
                        child: Text(
                          "Select a user to open chat",
                          style: TextStyle(
                            fontSize: _widthXheight! * 0.5,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget UserListWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.01,
        bottom: _deviceHeight! * 0.02,
        top: _deviceHeight! * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
      decoration: BoxDecoration(
        color: cardBackgroundColorLayer2,
        borderRadius: BorderRadius.circular(_widthXheight! * 1),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 0)),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: _widthXheight! * 0.7,
                left: _widthXheight! * 0.1,
              ),
              child: Row(
                children: [
                  Icon(Icons.message, size: 25),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Users",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // _searchBarWidget!.searchBar(_searchController, "Search users..."),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: user == null,
                  replacement: const Center(
                    child: Text("Users"),
                  ),
                  child: const CircularProgressIndicator(
                    color: selectionColor,
                  ),
                ),
                Visibility(
                  visible: user != null,
                  child: Scrollbar(
                    controller: _scrollControllerLeft,
                    child: ListView.builder(
                      controller: _scrollControllerLeft,
                      shrinkWrap: true,
                      itemCount: user?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return userListViewBuilderWidget(user![index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userListViewBuilderWidget(Map<String, dynamic> user) {
    return Padding(
      padding: EdgeInsets.only(
        right: _deviceWidth! * 0.0125,
        top: _deviceHeight! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              _isDetailsVisible = true;
              _selectedUser = user;
            },
          );
        },
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          height: _deviceHeight! * 0.08,
          width: _deviceWidth! * 0.175,
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(_widthXheight! * 0.66),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth! * 0.001,
                vertical: _deviceHeight! * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: _deviceWidth! * 0.01,
                    ),
                    Icon(
                      Icons.person,
                      size: _widthXheight! * 1,
                    ),
                    SizedBox(width: _deviceWidth! * 0.01),
                    if (user['username'] != null) ...{
                      Text(user['username']),
                    }
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedUserDetailsWidget extends StatefulWidget {
  final Map<String, dynamic>? selectedUser;
  const SelectedUserDetailsWidget({super.key, required this.selectedUser});

  @override
  State<SelectedUserDetailsWidget> createState() =>
      _SelectedUserDetailsWidgetState();
}

class _SelectedUserDetailsWidgetState extends State<SelectedUserDetailsWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    // Ensure that selectedUser is not null and that the required fields are not null
    if (widget.selectedUser == null ||
        widget.selectedUser!['email'] == null ||
        widget.selectedUser!['uid'] == null ||
        widget.selectedUser!['username'] == null) {
      return const Center(
        child: Text('No user selected or missing user information'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: _deviceWidth! * 0.01,
              vertical: _deviceHeight! * 0.02,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth! * 0.01,
              vertical: _deviceHeight! * 0.02,
            ),
            decoration: BoxDecoration(
              color: cardBackgroundColorLayer2,
              borderRadius: BorderRadius.circular(_widthXheight! * 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),

            //selected users chat
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                LayoutBuilder(builder: (context, Constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.selectedUser!['username'],
                        style: TextStyle(
                          fontSize: _widthXheight! * 0.9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      //chat messages
                      if (widget.selectedUser != null) ...{
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: _deviceHeight! * 0.7,
                          width: _deviceWidth! * 0.7,
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: ChatUI(
                            receiverEmail: widget.selectedUser!['email'],
                            receiverID: widget.selectedUser!['uid'],
                            receiverName: widget.selectedUser!['username'],
                          ),
                        ),
                      }
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUI extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverName;

  const ChatUI(
      {super.key,
      required this.receiverEmail,
      required this.receiverID,
      required this.receiverName});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController _messageController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();
  final ChatService _chatService = ChatService();

  // text feild focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    //if somthing in the textfield
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      //clear the textfield
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildMessageList()),
      ],
    );
  }

  Widget _buildMessageList() {
    String senderID = firebaseService.getCurrentUserChat()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: ((context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        //Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        // Null check for data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No messages');
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser =
        data['senderID'] == firebaseService.getCurrentUserChat()!.uid;

    //algin message to right if current user
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  //usser input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(
                hintText: "Tpye a message", controller: _messageController),
          ),

          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
