import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/common/const/colors.dart';

class SelectDistOption extends StatefulWidget {
  final String option, optionstr;
  final Function(SelectDistOptionState)? onStateUpdated;

  const SelectDistOption({
    super.key,
    required this.option,
    required this.optionstr,
    this.onStateUpdated,
  });

  @override
  SelectDistOptionState createState() => SelectDistOptionState();
}

class SelectDistOptionState extends State<SelectDistOption> {
  int dist = 0;
  int distselectnum = 0;
  final TextEditingController distcontroller = TextEditingController();
  String? errorText;
  bool isError = false;

  void updateErrorText() {
    final value = distcontroller.text;
    // int? intValue = int.tryParse(value);
    if (value.startsWith('0') && value.length > 1 ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value) == 0) {
      errorText = '정수 값을 입력하세요.';
      isError = true;
    } else {
        errorText = null;
        isError = false;
        dist = int.tryParse(value) ?? 0;
    }

    setState(() {});
    if (widget.onStateUpdated != null) {
      widget.onStateUpdated!(this);
      print('onStateUpdated called: isError = $isError');
    }
    // dist = double.tryParse(value) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xffF6F4E9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(1, 2),
            ),
          ],
        ),
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.option,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        color: Color.fromARGB(255, 137, 137, 137),
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        errorText: errorText,
                      ),
                      // textAlign: TextAlign.center,
                      controller: distcontroller,
                      onChanged: (value) {
                        setState(() {
                            distselectnum = int.tryParse(value) ?? 0;
                            updateErrorText();
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.optionstr,
                    style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
