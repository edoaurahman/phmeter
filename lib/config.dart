class Environments {
  static const String production = 'prod';
  static const String homolog = 'homolog';
  static const String develop = 'dev';
  static const String local = 'local';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Environments.local;
  static const List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.local,
      'url': 'http://103.150.191.174/',
    },
    {
      'env': Environments.develop,
      'url': 'https://api-dev.orderplizz.com/',
    },
    {
      'env': Environments.homolog,
      'url': '',
    },
    {
      'env': Environments.production,
      'url': 'https://api-production.orderplizz.com/',
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
    );
  }
}