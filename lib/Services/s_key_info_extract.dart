import 'package:googleapis/healthcare/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:medireminder/Constants/service_acc.dart';
import 'package:medireminder/Models/request.dart';

class SKeyInfoExtract {
  //sign in google
  static Future<AuthClient> obtainAuthenticatedClient() async {
    var accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": ServiceAcc.private_key_id,
      "private_key": ServiceAcc.private_key,
      "client_email": ServiceAcc.client_email,
      "client_id": ServiceAcc.client_id,
      "type": "service_account"
    });
    var scopes = [CloudHealthcareApi.cloudHealthcareScope];
    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);
    return client;
  }

  //create api
  static Future<CloudHealthcareApi> getApi() async {
    final httpClient = await obtainAuthenticatedClient();
    var api = CloudHealthcareApi(httpClient);
    return api;
  }

  static Future<AnalyzeEntitiesResponse?> apiRequest(String content) async {
    CloudHealthcareApi api = await getApi();
    String nlpService =
        "projects/mimetic-plate-418721/locations/asia-south1/services/nlp";
    final request = Request(content).getRequest();
    try {
      AnalyzeEntitiesResponse response = await api
          .projects.locations.services.nlp
          .analyzeEntities(request, nlpService);
      return response;
    } catch (e) {
      return null;
    }
  }
}
