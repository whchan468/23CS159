import 'package:googleapis/healthcare/v1.dart';

class Request extends AnalyzeEntitiesRequest {
  final String content;

  Request(this.content);

  getRequest() {
    return AnalyzeEntitiesRequest(documentContent: content);
  }
}
