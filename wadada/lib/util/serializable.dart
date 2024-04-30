abstract class Serializable {
  Map<String, dynamic> toJson();
  // fromJson은 정적(static) 또는 팩토리 생성자로 구현되므로 추상 클래스에서 직접 정의할 수 없습니다.
  // 대신, 각 구현 클래스에서 명시적으로 정의해야 합니다.
}
