/// Class for all app endpoints
abstract class ApiPath {
  const ApiPath._();

  static const baseUrl = String.fromEnvironment('baseUrl');


  // Главная
  static const getCatalog = '$baseUrl/products';

  // Профиль
  static const getProfile = '$baseUrl/customer/info';
}
