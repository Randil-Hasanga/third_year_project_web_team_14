import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/services/chat_services.dart';
import 'package:jms_desktop/services/firebase_services.dart';
import 'package:jms_desktop/widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
RichTextWidget? _richTextWidget;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
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
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    //_loadUsers();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  void _loadUsers() async {
    List<Map<String, dynamic>> data =
        _chatService.getUserStream() as List<Map<String, dynamic>>;
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
    );
  }
}

class SelectedUserDetailsWidget extends StatelessWidget {
  final Map<String, dynamic>? selectedUser;
  const SelectedUserDetailsWidget({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
