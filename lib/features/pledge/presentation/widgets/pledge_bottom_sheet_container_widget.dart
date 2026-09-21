import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quittr/core/constants/string_constants.dart';

class PledgeBottomSheetContainerWidget extends StatelessWidget {
  final double height;
  final double width;
  const PledgeBottomSheetContainerWidget(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(),
          color: Colors.blueGrey.shade200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRowOne(
            Icons.check,
            Constants.pledgeBottomSheetBoxHeading1,
            Constants.pledgeBottomSheetBoxSubHeading1,
          ),
          _buildRowTwo(
            CupertinoIcons.wand_stars,
            Constants.pledgeBottomSheetBoxHeading2,
            Constants.pledgeBottomSheetBoxSubHeading2,
          ),
          _buildRowThree(
            Icons.headset,
            Constants.pledgeBottomSheetBoxHeading3,
            Constants.pledgeBottomSheetBoxSubHeading3,
          ),
        ],
      ),
    );
  }

  Widget _buildRowOne(
      IconData icon, String headingText, String subHeadingText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 3),
            ),
            child: Icon(
              icon,
              size: 15,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  subHeadingText,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRowTwo(
      IconData icon, String headingText, String subHeadingText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  subHeadingText,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRowThree(
      IconData icon, String headingText, String subHeadingText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  subHeadingText,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
