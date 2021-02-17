import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';
import 'package:http/http.dart' as http;

class SettingService {
  SettingService._privateConstructor();
  static final SettingService instance = SettingService._privateConstructor();
  final AwsCognitoService awsCognitoService = AwsCognitoService.instance;
  static final String path = '/api/privacy';

  Future<void> cleanData() async {
    final SigV4Request signedRequest = this.awsCognitoService.getSigV4Request('DELETE', path);
    await http.delete('${signedRequest.url}/${RouteHandler.loggedInUser.id}', headers: signedRequest.headers);
  }

  Future<void> deleteAccount() async {
    await this.cleanData();
    this.awsCognitoService.deleteUser();
  }
}