import 'package:flutter/material.dart';
// import 'package:wadada/screens/singleoptionpage/single_free_option.dart';

class SelectMode extends StatelessWidget{
  final String icon, name, des, btn;
  
  const SelectMode({
    super.key,
    required this.icon,
    required this.name,
    required this.des,
    required this.btn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleFreeMode()));
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
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Image.asset(icon),
              ),
              SizedBox(width:15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Color(0xff5BC879),
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    )
                  ),
                  SizedBox(height:5),
                  Text(
                    des,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                    )
                  ),
                ],
              ),
              SizedBox(width: double.parse(btn)),
              SizedBox(
                width: 20,
                child: Image.asset('assets/mode_select_btn.png'),
              ),
            ],
          )
        ),
      ),
    );
  }
}