# Localization and Theme Updates

## Supported languages
- English (default)
- Urdu (RTL)
- Arabic (RTL)

Change the language from **Settings → Language**. The selection is stored in
SharedPreferences and restored the next time the app starts.

## Theme
The existing Light/Dark switch remains in Settings → Appearance. Its value is
stored in SharedPreferences. Main screen backgrounds, task cards, and form
surfaces now read from the active ThemeData where applicable.

## Architecture
- `lib/core/localization/locale_provider.dart`: saved locale state.
- `lib/core/localization/app_localizations.dart`: app translation dictionary
  and `context.tr('English key')` extension.
- `lib/app.dart`: supported locales and Flutter localization delegates.
- `lib/main.dart`: registers the locale provider with the existing providers.

Task category and priority values remain in English internally so SQLite data
and filtering continue to work; only their displayed labels are translated.

Run:
```bash
flutter pub get
flutter analyze
flutter run
```
