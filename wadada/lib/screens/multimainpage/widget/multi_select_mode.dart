import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';

class MultiSelectMode extends StatelessWidget {
  final String icon, name, des, btn;
  final VoidCallback onTapAction;

  const MultiSelectMode({
    super.key,
    required this.icon,
    required this.name,
    required this.des,
    required this.btn,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapAction();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * .9,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                  child: Image.asset(icon),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: TextStyle(
                          color: GREEN_COLOR,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 5),
                    Text(des,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        )),
                  ],
                ),
                SizedBox(width: double.parse(btn)),
                SizedBox(
                  width: 20,
                  child: Image.asset('assets/images/mode_select_btn.png'),
                ),
              ],
            )),
      ),
    );
  }
}
