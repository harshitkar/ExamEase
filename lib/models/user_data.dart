class UserData {
  String userId;
  String username;
  String phone;
  List<String> testIds;

  UserData({
    this.userId = '',
    this.username = '',
    this.phone = '',
    List<String>? testIds,
  }) : testIds = testIds ?? [];
}
