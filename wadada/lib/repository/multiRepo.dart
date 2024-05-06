import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:dio/src/response.dart';

abstract class AbstractMultiRepository {
  Future<int> createRoom(MultiRoom roomInfo);
}

class MultiRepository extends AbstractMultiRepository {
  final MultiProvider provider;

  MultiRepository({
    required this.provider,
  });

  @override
  Future<int> createRoom(MultiRoom roomInfo) async {
    try {
      Response res = await provider.multiRoomCreate(roomInfo);
      return res.data['roomIdx'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
