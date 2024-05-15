import 'package:flutter/material.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/models/marathon.dart';

class MarathonCard extends StatelessWidget {
  final SimpleMarathon marathon;
  final bool isPast;
  final VoidCallback? onTap;

  const MarathonCard({
    super.key,
    required this.marathon,
    required this.isPast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isPast ? Color(0xffF2F2F2) : OATMEAL_COLOR;
    final textColor = isPast ? GRAY_400 : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.all(30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (marathon.containsKey('image') && !isPast)
            //   ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(20),
            //       topRight: Radius.circular(20),
            //     ),
            //     child: Image.network(
            //       marathon['image'],
            //       height: 200,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPast
                              ? GRAY_400
                              : (isPast ? Colors.grey : GREEN_COLOR),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isPast ? '종료' : 'D-${DateTime.now().day}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: isPast ? GRAY_400 : GREEN_COLOR),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: textColor),
                      SizedBox(width: 10),
                      Text(
                        '일시',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 58),
                      Expanded(
                        child: Text(
                          '${marathon.marathonStart} ~ ${marathon.marathonEnd}',
                          style: TextStyle(
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.flag_outlined, color: textColor),
                      SizedBox(width: 10),
                      Text(
                        '거리',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 58),
                      Expanded(
                        child: Text(
                          '${marathon.marathonDist} km',
                          style: TextStyle(
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_alt_rounded, color: textColor),
                      SizedBox(width: 10),
                      Text(
                        '참여 인원',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          '${marathon.marathonParticipate}명',
                          style: TextStyle(
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
