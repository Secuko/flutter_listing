abstract class IToken {
  IToken({
    required this.accessToken,
    required this.isAuthorized,
  });

  final String accessToken;
  final bool isAuthorized;

  Map<String, dynamic> toJson();
}
