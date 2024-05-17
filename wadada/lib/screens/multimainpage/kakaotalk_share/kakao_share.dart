// import 'package:kakao_flutter_sdk/link.dart';

// class KakaoShareManager {

//   static final KakaoShareManager _manager = KakaoShareManager._internal();

//   factory KakaoShareManager() {
//     return _manager;
//   }

//   KakaoShareManager._internal() {
//     // 초기화 코드
//   }

//   void initializeKakaoSDK() {
//     String kakaoAppKey = "49db......";
//     KakaoContext.clientId = kakaoAppKey;
//   }

//   Future<bool> isKakaotalkInstalled() async {
//     bool installed = await isKakaoTalkInstalled();
//     return installed;
//   }

//   void shareMyCode() async {
//     try {
//       var template = _getTemplate();
//       var uri = await LinkClient.instance.defaultWithTalk(template);
//       await LinkClient.instance.launchKakaoTalk(uri);
//     } catch (error) {
//       print(error.toString());
//     }
//   }

//   DefaultTemplate _getTemplate() {
//     String title = "안녕하세여";
//     Uri imageLink = Uri.parse("http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png");
//     Link link = Link(
//         webUrl: Uri.parse("https://developers.kakao.com"),
//         mobileWebUrl: Uri.parse("https://developers.kakao.com")
//     );

//     Content content = Content(
//       title,
//       imageLink,
//       link,
//     );

//     FeedTemplate template = FeedTemplate(
//         content,
//         social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
//         buttons: [
//           Button("웹으로 보기",
//               Link(webUrl: Uri.parse("https://developers.kakao.com"))),
//           Button("앱으로 보기",
//               Link(webUrl: Uri.parse("https://developers.kakao.com"))),
//         ]
//     );

//     return template;
//   }
// }