# tp_media example

Requires Dart 3.10.0+, Android SDK 37+, and JDK 17. Flutter 3.44+ is
recommended for the example's AGP 9.1.1 configuration. The package itself
requires Flutter 3.38.1+.

From this directory:

```bash
flutter pub get
flutter run --dart-define=USE_NEXT_GEN_SDK=true
flutter build apk --debug --dart-define=USE_NEXT_GEN_SDK=true
flutter build appbundle --dart-define=USE_NEXT_GEN_SDK=true
```

The repository's VS Code launch configuration includes the Next-Gen flag.
Include it in Android Studio run arguments and CI build commands too.
Omitting it selects the plugin's legacy Android SDK.

The Android manifest and ad widgets use Google's test IDs. On a device,
verify banner and native templates load, interstitial dismiss callbacks run,
reward callbacks fire after earning a reward, and app-open ads load and show
on foreground transitions.

See the [package setup guide](../README.md#android-gma-next-gen-sdk) for host
app configuration and mediation migration notes.
