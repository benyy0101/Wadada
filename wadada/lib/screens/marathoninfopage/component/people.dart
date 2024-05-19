import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/marathonController.dart';
import 'package:wadada/models/marathon.dart';

final List<Map<String, dynamic>> peopleData = [
  {
    'profileImage':
        'https://github.com/jjeong41/t/assets/103355863/6604ea7a-8002-4426-8c5b-234de49dfb62',
    'nickname': '히히',
    'time': '01:30:45',
  },
  {
    'profileImage':
        'https://github.com/jjeong41/t/assets/103355863/c28cdda8-9eff-4925-b505-8a187d474e58',
    'nickname': '닉네임',
    'time': '01:35:20',
  },
  {
    'profileImage':
        'https://github.com/jjeong41/t/assets/103355863/9a284ab2-a2cb-4991-9627-a0e8897c14c2',
    'nickname': '3',
    'time': '01:40:10',
  },
  {
    'profileImage':
        'https://github.com/jjeong41/t/assets/103355863/6604ea7a-8002-4426-8c5b-234de49dfb62',
    'nickname': '4',
    'time': '01:45:00',
  },
];

class People extends StatelessWidget {
  final SimpleMarathon marathon;
  final bool isPast;

  const People({super.key, required this.marathon, required this.isPast});

  @override
  Widget build(BuildContext context) {
    MarathonController controller = Get.put(MarathonController());
    controller.getAttendant(marathon.marathonSeq.toString());
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Text(
          //   isPast ? '랭킹 정보' : '참가자 정보',
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          SizedBox(height: 10),
          if (isPast)
            Expanded(child: _RankingList())
          else
            Expanded(
                child: ParticipantsList(
              peopleData: controller.participantList.value,
            ))
        ],
      ),
    );
  }

  Widget _RankingList() {
    return ListView.builder(
      itemCount: peopleData.length,
      itemBuilder: (context, index) {
        final person = peopleData[index];
        final rank = index + 1;

        return Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                // padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(children: [
                  Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: DARK_GREEN_COLOR,
                    ),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    backgroundImage: NetworkImage(person['profileImage']),
                    radius: 30,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      person['nickname'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // 시간
                  Text(
                    person['time'],
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1.5,
                    ),
                  ),
                ])),
            if (index != peopleData.length - 1)
              Divider(
                color: Color.fromARGB(255, 211, 211, 211),
              ),
          ],
        );
      },
    );
  }
}

class ParticipantsList extends StatefulWidget {
  final List<MarathonParticipant> peopleData;

  const ParticipantsList({super.key, required this.peopleData});

  @override
  _ParticipantsListState createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  int currentPage = 0;
  final int itemsPerPage = 12;
  @override
  Widget build(BuildContext context) {
    // 페이지 수 계산
    final totalPages = (widget.peopleData.length / itemsPerPage).ceil();

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              Icon(
                Icons.people,
                color: DARK_GREEN_COLOR,
                size: 24.0,
              ),
              SizedBox(width: 8),
              Text(
                '참가자 수 ${widget.peopleData.length}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: DARK_GREEN_COLOR,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: PageView.builder(
            itemCount: totalPages,
            onPageChanged: (pageIndex) {
              setState(() {
                currentPage = pageIndex;
              });
            },
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * itemsPerPage;
              final endIndex = (startIndex + itemsPerPage)
                  .clamp(0, widget.peopleData.length);
              print(widget.peopleData.length);
              if (widget.peopleData.isEmpty) {
                print("NOBODY HERE");
                return Center(
                  child: Text("아무도 없습니다."),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: endIndex - startIndex,
                  itemBuilder: (context, index) {
                    final personIndex = startIndex + index;
                    final person = widget.peopleData[personIndex];

                    return Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(person.memberImage),
                          radius: 44,
                        ),
                        SizedBox(height: 5),
                        Text(
                          person.memberName,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    index == currentPage ? GREEN_COLOR : OATMEAL_COLOR,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
