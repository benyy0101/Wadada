import 'package:dio/dio.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/provider/marthonProvider.dart';

abstract class AbstractMarathonRepository {
  Future<List<SimpleMarathon>> getMarathonList();
  Future<List<MarathonParticipant>> getParticipant(String marathonSeq);
  Future<MyMarathonRecord> getRank(String marathonSeq);
  Future<int> attendMarathon(String marathonSeq);
  Future<int> startMarathon(MarathonStart start);
  Future<int> endMarathon(Marathon marathon);
}

class MarathonRepository extends AbstractMarathonRepository {
  MarathonProvider provider = MarathonProvider();
  @override
  Future<int> attendMarathon(String marathonSeq) async {
    Response res = await provider.attendMarathon(marathonSeq);

    return res.data;
  }

  @override
  Future<int> endMarathon(Marathon marathon) async {
    Response res = await provider.marathonEnd(marathon);
    return res.data['marathonRecordSeq'];
  }

  @override
  Future<List<SimpleMarathon>> getMarathonList() async {
    print("----------Marathon repo-----------");
    Response res = await provider.marathonGetRoom();
    print(res.data);
    List<SimpleMarathon> temp = [];
    res.data.forEach((item) {
      temp.add(SimpleMarathon.fromJson(item));
    });

    return temp;
  }

  @override
  Future<List<MarathonParticipant>> getParticipant(String marathonSeq) async {
    Response res = await provider.marathonGetParticipant(marathonSeq);
    final List<MarathonParticipant> pList = [];
    print("---------------participants-------------------");
    print(res.data);
    res.data.forEach((item) {
      pList.add(MarathonParticipant.fromJson(item));
    });
    return pList;
  }

  @override
  Future<MyMarathonRecord> getRank(String marathonSeq) async {
    Response res = await provider.marathonRank(marathonSeq);

    return MyMarathonRecord.fromJson(res.data);
  }

  @override
  Future<int> startMarathon(MarathonStart start) async {
    Response res = await provider.marathonStart(start);
    print('--------------');
    print(res);
    return res.data["marathonRecordSeq"];
  }

  Future<void> udpateDistance(
      int roomSeq, String userName, int userDist, int userTime) async {
    print("SENDING");
    print(roomSeq);
    print(userName);
    print(userDist);
    print(userTime);
    DistanceRecord record = DistanceRecord(
        roomSeq: roomSeq,
        userName: userName,
        userDist: userDist,
        userTime: userTime);
    final res = await provider.distSave(record);
    print(res);
  }
}
