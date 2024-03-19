import 'package:flutter/material.dart';

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
              height: _widthXheight! * 2.7,
              width: _widthXheight! * 5,
            ),
            Padding(
              padding: EdgeInsets.only(right: _widthXheight! * 1),
              child: Icon(
                Icons.notifications_none_outlined,
                size: _widthXheight! * 1.5,
              ),
            ),
          ],
        ),
        SizedBox(
          height: _widthXheight! * 8,
        ),
        _profileImage(),
        SizedBox(
          height: _widthXheight! * 1,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "<<Name>>", //TODO: add name
              style: TextStyle(
                fontSize: _widthXheight! * 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "<<Reg No>>", //TODO: add name
              style: TextStyle(
                fontSize: _widthXheight! * 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "<<Post>>", //TODO: add name
              style: TextStyle(
                fontSize: _widthXheight! * 1,
                fontWeight: FontWeight.w600,
              ),
            ),
    
          ],
        ),
      ],
    );
  }

  Widget _profileImage() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
      height: _widthXheight! * 7,
      width: _widthXheight! * 7,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
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
