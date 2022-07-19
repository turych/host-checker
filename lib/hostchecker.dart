import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HostChecker {
  static final String apiEndpoint = "check-host.net";

  final CheckType _checkType;
  final String _host;

  int _nodeCount = 0;

  HostChecker(CheckType checkType, String host)
      : _checkType = checkType,
        _host = host;

  void run() async {
    await checkNodes();
    // var host = Uri.parse(_host);
    // var params = {"host": host.authority};
    // var headers = {"Accept": "application/json"};
    // var url = Uri.https(apiEndpoint, "/check-${_checkType.name}", params);
    // var response = await http.get(url, headers: headers);
    // if (response.statusCode == 200) {
    //   print(response.body);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
  }

  // https://check-host.net/nodes/hosts
  Future<void> checkNodes() async {
    print("Checking nodes ...");
    var headers = {"Accept": "application/json"};
    var url = Uri.https(apiEndpoint, "/nodes/hosts");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var nodeList = NodeList.fromJson(result["nodes"]);
      
      _nodeCount = nodeList.nodes.length;
      if (_nodeCount == 0) {
        print("Nodes not available.");
        return;
      }

      print("\x1B[32mAvailable nodes: $_nodeCount\x1B[0m");
      for (var node in nodeList.nodes) { 
        print("${node.location} ${node.ip} ${node.host}");
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}

class NodeList {
  List<Node> nodes = [];

  NodeList.fromJson(Map<String, dynamic> json) {
    json.forEach((host, value) { 
      nodes.add(Node(host: host, asn: value["asn"], ip: value["ip"], location: value["location"].cast<String>()));
    });
  }
}

class Node {
  String? host;
  String? asn;
  String? ip;
  List<String>? location;

  Node({required this.host, required this.asn, required this.ip, required this.location});
}


enum CheckType { ping, http, tcp, dns }
