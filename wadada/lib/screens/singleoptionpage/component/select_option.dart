import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/common/const/colors.dart';

class SelectOption extends StatefulWidget{
  final String option, optionstr;
  
  const SelectOption({
    super.key,
    required this.option,
    required this.optionstr,
  });

  @override
  SelectOptionState createState() => SelectOptionState();
}

class SelectOptionState extends State<SelectOption> {
  int selectnum = 0;
  final TextEditingController _controller = TextEditingController(text: "0");

  void incrementNum() {
    setState(() {
      selectnum += 1;
      _controller.text = selectnum.toString();
    });
  }

  void decrementNum() {
    setState(() {
      if (selectnum > 0) {
        selectnum -= 1;
      }
      _controller.text = selectnum.toString();
    });
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
                      ),
                      // textAlign: TextAlign.center,
                      controller: _controller,
                      onChanged: (value) {
                          setState(() {
                              selectnum = int.tryParse(value) ?? 0;
                          });
                        },
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: DARK_GREEN_COLOR,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_drop_up),
                            color: Colors.white,
                            onPressed: incrementNum,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: DARK_GREEN_COLOR,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_drop_down),
                            color: Colors.white,
                            onPressed: decrementNum,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Text(
                    widget.optionstr,
                    style: TextStyle(
                      color: DARK_GREEN_COLOR,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}