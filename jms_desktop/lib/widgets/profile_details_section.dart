import 'package:flutter/material.dart';
import 'package:jms_desktop/const/constants.dart';

class ProfileDetailsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileDetailsSectionState();
  }
}

class _ProfileDetailsSectionState extends State<ProfileDetailsSection> {
  double? _deviceWidth, _deviceHeight, _widthXheight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _widthXheight = _deviceHeight! * _deviceWidth! / 50000;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: _deviceHeight! * 0.1,
              width: _deviceWidth! * 0.001,
            ),
            Padding(
              padding: EdgeInsets.only(right: _widthXheight! * 1),
              child: IconButton(
                onPressed: () {
                  //Navigator.pop(context);
                },
                icon: const Icon(Icons.notifications_none_outlined),
                iconSize: _widthXheight! * 1.5,
              ),
            ),
          ],
        ),
        SizedBox(
          height: _deviceHeight! * 0.15,
        ),
        Container(
          padding: EdgeInsets.all(_widthXheight! * 1),
          height: _widthXheight! * 13,
          width: _deviceWidth! * 0.2,
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
          child: Column(
            children: [
              _profileImage(),
              SizedBox(
                height: _widthXheight! * 0.5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "<<Name>>", //TODO: add name
                    style: TextStyle(
                      fontSize: _widthXheight! * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "<<Reg No>>", //TODO: add name
                    style: TextStyle(
                      fontSize: _widthXheight! * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "<<Post>>", //TODO: add name
                    style: TextStyle(
                      fontSize: _widthXheight! * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      height: _widthXheight! * 6,
      width: _widthXheight! * 6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50000),
        child: Image.network(
          "https://i.pravatar.cc/150?img=3", //TODO: profile pic
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }
}
