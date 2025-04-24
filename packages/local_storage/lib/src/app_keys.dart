// system keys for normal package work

interface class AppKeysInterface {
  AppKeysInterface(this.textValue);

  final String textValue;
}

enum AppKeysSystem implements AppKeysInterface {
  name('name'),
  surname('surname'),
  secondName('secondName'),
  phone('phone'),
  token('token'),
  isFirstRun('isFirstRun'),
  isOnboardingCompleted('isOnboardingCompleted'),
  city('city');

  const AppKeysSystem(this.textValue);

  @override
  final String textValue;
}
