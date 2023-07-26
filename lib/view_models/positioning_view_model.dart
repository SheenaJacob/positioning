import 'dart:convert';
import 'dart:io';

import 'package:easylocate_flutter_sdk/tracelet_api.dart';

import 'package:get_it/get_it.dart';


import '../services/indoor_positioning_service.dart';
import '../services/service_locator.dart';

class PositioningViewModel {
  final IndoorPositioningService _positioningService =
      getIt<IndoorPositioningService>();

  String get notification => _positioningService.notification;

  Wgs84Position? get position => _positioningService.wgs84position;

  bool get isConnected => _positioningService.isConnected;

  startPositioning() {
    _positioningService.connectTracelet();
  }

  stopPositioning() {
    _positioningService.disconnectTracelet();
  }

  importFile(String filePath) async {
    final File jsonFile = File(filePath);
    final jsonContents = await jsonFile.readAsString();
    _positioningService.updateWgs84Parameters(
        [IndoorPositioningService.fromJson(json.decode(jsonContents))]);
  }

  void dispose() {
    GetIt.I.unregister<IndoorPositioningService>();
  }
}
