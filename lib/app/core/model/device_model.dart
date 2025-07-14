class DeviceInfo {
  final String name;
  final String identifier;
  final String version;
  final String appVersion;
  final String system;
  final String os;
  final bool verified;
  final bool biometric;

  DeviceInfo({
    required this.name,
    required this.identifier,
    required this.version,
    required this.appVersion,
    required this.system,
    required this.os,
    required this.verified,
    required this.biometric,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      name: json['name'],
      identifier: json['identifier'],
      version: json['version'],
      appVersion: json['appVersion'],
      system: json['system'],
      os: json['os'],
      verified: json['verified'],
      biometric: json['biometric'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "identifier": identifier,
      "version": version,
      "appVersion": appVersion,
      "system": system,
      "os": os,
      "verified": verified,
      "biometric": biometric,
    };
  }

  @override
  String toString() {
    return '''
  DeviceInfo {
    name: $name,
    identifier: $identifier,
    version: $version,
    appVersion: $appVersion,
    system: $system,
    os: $os,
    verified: $verified,
    biometric: $biometric,
  }
  ''';
  }
}