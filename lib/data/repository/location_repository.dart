import 'package:haiku/data/services/location/location_service.dart';

abstract class LocationRepositoryImpl {
  Future<void> updateCurrentLocationInfo();
}


class LocationRepository  implements LocationRepositoryImpl  {
    LocationRepository(this._locationService);

  final LocationService _locationService;
  @override
  Future<void> updateCurrentLocationInfo() =>
      _locationService.updateLocationInfo();
  }