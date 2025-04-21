// system keys for normal package work

interface class AppKeysInterface {
  AppKeysInterface(this.textValue);

  final String textValue;
}

enum AppKeysSystem implements AppKeysInterface {
  token('token'),
  isFirstRun('isFirstRun'),
  isOnboardingCompleted('isOnboardingCompleted'),
  city('city');

  const AppKeysSystem(this.textValue);

  @override
  final String textValue;
}
