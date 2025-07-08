// Dart imports:
import 'dart:async';

// Package imports:
import 'package:airbridge_flutter_sdk_restricted/airbridge_flutter_sdk_restricted.dart';
import 'package:logging/logging.dart';

abstract class AirbridgeRemoteDataSource {
  Future<void> registerTokenAirbridge(String token);
  Future<void> setUserInfo(
    String userId,
    String? email,
    String? phone,
    String? name,
    bool? isPaid,
    bool? isAuthenticated,
  );
  Future<String> getDeviceId();

  void pushEvent(
    String eventName,
    Map<String, dynamic>? semanticProperties,
    Map<String, dynamic>? customProperties,
  );
  Stream<Map<String, dynamic>> get attributionDataStream;
  void listenToAttribution();
}

class AirbridgeRemoteDataSourceImpl implements AirbridgeRemoteDataSource {
  final Logger _logger = Logger('AirbridgeRemoteDataSourceImpl');
  final _attributionDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get attributionDataStream =>
      _attributionDataController.stream;

  @override
  void listenToAttribution() {
    Airbridge.setOnAttributionReceived((result) {
      _logger.info('Attribution result received: $result');
      final data = Map<String, dynamic>.from(result);
      _attributionDataController.add(data);
        });
  }

  @override
  Future<void> registerTokenAirbridge(String token) async {
    Airbridge.registerPushToken(token);
  }

  @override
  Future<void> setUserInfo(
    String userId,
    String? email,
    String? phone,
    String? name,
    bool? isPaid,
    bool? isAuthenticated,
  ) async {
    Airbridge.setUserID(userId);
    if (email != null && email.isNotEmpty) {
      Airbridge.setUserEmail(email);
    }
    if (phone != null && phone.isNotEmpty) {
      Airbridge.setUserPhone(phone);
    }
    if (name != null && name.isNotEmpty) {
      Airbridge.setUserAttribute(key: 'name', value: name);
    }
    Airbridge.setUserAttribute(key: 'isPaid', value: isPaid);
    Airbridge.setUserAttribute(key: 'isAuthenticated', value: isAuthenticated);
  }

  @override
  Future<String> getDeviceId() async {
    final completer = Completer<String>();

    await Airbridge.fetchAirbridgeGeneratedUUID(
      onSuccess: (uuid) {
        completer.complete(uuid);
      },
      onFailure: (error) {
        completer.completeError('Failed to fetch UUID');
      },
    );

    return completer.future;
  }

  @override
  void pushEvent(
    String eventName,
    Map<String, dynamic>? semanticProperties,
    Map<String, dynamic>? customProperties,
  ) {
    _logger.info('pushEvent: $eventName');
    _logger.info('semanticProperties: $semanticProperties');
    _logger.info('customProperties: $customProperties');

    Airbridge.trackEvent(
      category: eventName,
      semanticAttributes: semanticProperties,
      customAttributes: customProperties,
    );
  }
}
