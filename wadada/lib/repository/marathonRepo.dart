import 'package:dio/dio.dart';
import 'package:wadada/models/marathon.dart';
import 'package:wadada/provider/marthonProvider.dart';

abstract class AbstractMarathonRepository {
  Future<List<SimpleMarathon>> getMarathonList();
  Future<List<MarathonParticipant>> getParticipant(String marathonSeq);
  Future<MyMarathonRecord> getRank(String marathonSeq);
  Future<bool> attendMarathon(String marathonSeq);
  Future<bool> startMarathon(MarathonStart start);
  Future<int> endMarathon(Marathon marathon);
}

class MarathonRepository extends AbstractMarathonRepository {
  MarathonProvider provider = MarathonProvider();
  @override
  Future<bool> attendMarathon(String marathonSeq) async {
    Response res = await provider.attendMarathon(marathonSeq);

    return res.data;
  }

  @override
  Future<int> endMarathon(Marathon marathon) async {
    Response res = await provider.marathonEnd(marathon);
    throw res.data;
  }

  @override
  Future<List<SimpleMarathon>> getMarathonList() async {
    Response res = await provider.marathonGetRoom();
    final List<SimpleMarathon> marathonList = res.data.map((item) {
      return SimpleMarathon.fromJson(item);
    }).toList();
    return marathonList;
  }

  @override
  Future<List<MarathonParticipant>> getParticipant(String marathonSeq) async {
    Response res = await provider.marathonGetParticipant(marathonSeq);
    final List<MarathonParticipant> pList = res.data.map((item) {
      return MarathonParticipant.fromJson(item);
    }).toList();
    return pList;
  }

  @override
  Future<MyMarathonRecord> getRank(String marathonSeq) async {
    Response res = await provider.marathonRank(marathonSeq);

    return MyMarathonRecord.fromJson(res.data);
  }

  @override
  Future<bool> startMarathon(MarathonStart start) async {
    Response res = await provider.marathonStart(start);
    return res.data;
  }
}
