# Liriku

Liriku mobile using Flutter

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

## Development

### Generate Localizations

```
$ flutter pub run intl_translation:extract_to_arb --output-dir=lib/resource/l10n lib/localizations.dart
```

```
$ flutter pub run intl_translation:generate_from_arb \
      --output-dir=lib/resource/l10n --no-use-deferred-loading \
      lib/localizations.dart lib/resource/l10n/intl_*.arb
```
