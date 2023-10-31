import 'package:flutter/widgets.dart';
import 'package:vsound/src/core/core.dart';

export 'app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
