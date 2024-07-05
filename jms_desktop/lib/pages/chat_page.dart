import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_services.dart';
import '../widgets/Search_bar_widget.dart';
import '../widgets/buttons.dart';
import '../widgets/richText.dart';

double? _deviceWidth, _deviceHeight, _widthXheight;
RichTextWidget? _richTextWidget;
ButtonWidgets? _buttonWidgets;
FirebaseService? _firebaseService;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  SearchBarWidget? _searchBarWidget;
  bool _showLoader = true;
  TextEditingController _searchController = TextEditingController();

  ScrollController _scrollControllerLeft = ScrollController();
  bool _isDetailsVisible = false;

  double? _userListWidth, _userListHeight, _chatWidthXheight;
  bool _showNoUserFound = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _searchBarWidget = GetIt.instance.get<SearchBarWidget>();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _buttonWidgets = GetIt.instance.get<ButtonWidgets>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(),
      ),
    );
  }
}
