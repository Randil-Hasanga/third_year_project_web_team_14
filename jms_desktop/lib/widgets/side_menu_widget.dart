import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';
import 'package:jms_desktop/data/side_menu_data.dart';

class SideMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideMenuWidgetState();
  }
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  double? _deviceWidth, _deviceHeight;
  int seletedIndex = 0;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    final SideMenuData data = SideMenuData();
    return Container(
      constraints: BoxConstraints(
        minWidth: 200,
      ),
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.1, horizontal: _deviceWidth! * 0.02),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = seletedIndex == index;
    return Column(
      children: [
        SizedBox(height: _deviceHeight! * 0.02,),
        AnimatedContainer(
          
          
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? selectionColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            onTap: () => setState(() => seletedIndex = index),
            child: Row(
              
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01, vertical: _deviceHeight! * 0.015),
                  child: Icon(
                    data.menu[index].icon,
                    color: isSelected ? Colors.black : selectionColor,
                    size: _deviceWidth! * 0.015,
                  ),
                ),
                Text(
                  data.menu[index].title,
                  style: TextStyle(
                    fontSize: _deviceWidth! * 0.013,
                    color: isSelected ? Colors.black : selectionColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
