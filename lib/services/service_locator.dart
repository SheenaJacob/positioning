import 'package:get_it/get_it.dart';

import 'indoor_positioning_service.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<IndoorPositioningService>(
    () => IndoorPositioningService(
        referenceLatitude: 50.12,
        referenceLongitude: 12.22,
        referenceAzimuth: 35.0),
  );
}
