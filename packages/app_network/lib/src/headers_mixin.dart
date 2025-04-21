import 'package:app_network/src/i_base_client.dart';

mixin HeadersMixin {
  HeadersMap getAccessTokenHeader(String token) => {'accessToken': token};
  HeadersMap getAuthHeader(String token) => {'Authorization': 'Token $token'};
}
