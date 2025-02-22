///
mixin class ModelMetadata {
  ///
  int get version => -1;

  ///
  String get domain => '';

  ///
  String get producer => '';

  ///
  String get graphName => '';

  ///
  String get graphDescription => '';

  ///
  Map<String, String> get extraProperties => const {};

  @override
  String toString() {
    return 'ModelMetadata('
        'version: $version, domain: "$domain", producer: "$producer", '
        'graphName: "$graphName", graphDescription: "$graphDescription", '
        'extraProperties: $extraProperties'
        ')';
  }
}
