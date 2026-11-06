# TP MEDIA

A comprehensive Flutter utility package providing fast AdMob ad integration, in-app purchase management via RevenueCat, network connectivity monitoring, and a rich suite of common UI utilities and widgets for rapid app development.

[![pub.dev](https://img.shields.io/pub/v/tp_media.svg)](https://pub.dev/packages/tp_media)
[![pub points](https://img.shields.io/pub/points/tp_media?color=2E8B57&label=pub%20points)](https://pub.dev/packages/tp_media/score)

## 🎯 Overview

`tp_media` is designed to streamline common development tasks in Flutter apps, especially those requiring monetization through ads and in-app purchases. It provides production-ready components with minimal boilerplate, built on top of popular packages like Google Mobile Ads, RevenueCat, and Flutter's ecosystem tools.

## ✨ Features

### 🎬 AdMob Integration
- **`AdmobBannerAd`**: Adaptive banners sized to their container, reused until their configuration changes. Failed loads recover with bounded retries and network reconnection; loaded ads use AdMob's refresh settings. Screenshot mode displays a local image without requesting ads.
- **`AdmobOpenAd`**: App open ad display for launch and resume scenarios.
- **`InterstitialAdMixin`**: Mixin for seamless interstitial ad loading and display with callbacks.
- **`RewardedAdMixin`**: Mixin for rewarded ad integration with reward callbacks.
- **`AdmobInitializer`**: One-call initialization for Google Mobile Ads SDK.
- **`TrackingTransparencyDialog`**: iOS-native ATT (App Tracking Transparency) permission dialog.
- **Internet-aware loading**: Fullscreen and native ads check connectivity before loading. Banners avoid an initial connectivity probe and pause retries while offline.

### 💳 In-App Purchase (IAP) Management
Powered by RevenueCat for cross-platform purchase handling:
- **`IapInitializer`**: Initialize RevenueCat SDK with custom managers.
- **`IapManager`**: Abstract base for managing subscriptions, listening to purchase updates, restoring transactions.
- **Stream-based subscription state**: Real-time subscription status monitoring.
- **Paywall integration**: Easy-to-use RevenueCat Paywall UI display.
- **Customer info caching**: Efficient customer data management.

### 🎨 UI Widgets
Production-ready widgets for rapid development:
- **`CommonCard`**: Customizable card with rounded corners and borders.
- **`CommonEmpty`**: Empty state widget with Lottie animation support.
- **`CommonIconButton`**: Styled icon button with feedback.
- **`CommonTextButton`**: Text button widget with consistent theming.
- **`CommonTextField`**: Customizable text input field.
- **`CommonSnackbar`**: Helper for showing snackbars.
- **`GlobalLoading`**: Full-screen loading indicator.
- **`TopRoundedContainer`**: Container with top-rounded corners.
- **`MaterialInkWell`**: Material ripple effect wrapper.
- **`DisableContainer`**: Wrapper to disable user interactions.
- **`TakeIfContainer`**: Conditional visibility wrapper.
- **`PremiumUser`**: Widget for premium content display.
- **`DialogHeader`**: Reusable dialog header component.
- **`ClearFocusOnTap`**: Dismiss keyboard on tap.
- **`InternetChecker`**: Network status indicator widget.
- **`HeaderSliverList`**: Sliver widget with header support.
- **`StickyHeaderDelegate`**: Custom sliver delegate for sticky headers.

### 🗣️ Dialogs
- **`CommonAlertDialog`**: iOS-native style alert dialog (Cupertino) with title, message, and custom actions.
- **`TrackingTransparencyDialog`**: iOS ATT permission request dialog.
- **`showAlertDialog()`**: Helper function for quick dialog creation.

### 🔌 Extensions & Utilities

**Context Extensions:**
- `context.showSnackbar('Message')` — Show snackbar
- `context.showSuccessSnackBar('Message')` — Green snackbar
- `context.showErrorSnackBar('Message')` — Red snackbar

**String Extensions:**
- `'hello'.capitalize()` — Capitalize first letter → "Hello"
- `'hello'.vnToEn` — Convert Vietnamese diacritics to English
- `'12345'.isPhoneNumber()` — Validate phone number (VN format)
- `'https://example.com'.isUri()` — Check if valid URI
- `'3.14'.replaceComma` — Replace commas with dots

**Double Extensions:**
- `3.14159.round(2)` — Smart rounding with precision

**ScrollController Extensions:**
- `scrollController.scrollToBottom()` — Check if scroll is at bottom
- `scrollController.isAtTop` — Check if scroll is at top

**Text Extensions:**
- Utility extensions for text formatting

**Iterable Extensions:**
- Extra utility methods for collections

### 📡 Network Management
- **`InternetManager`**: Singleton for checking internet connectivity.
  - `InternetManager.instance.isOnline` — Check current connection status
  - `InternetManager.instance.onStatusChange` — Stream of connection changes

### 🎚️ State Management
- **`LoadingDialogState`**: Mixin for showing/hiding loading dialogs from state.

### 🎨 Theming
- **`theme`** package: Pre-built theme configurations.

### ⏰ Utilities
- **`ToastUtils`**: 
  - `ToastUtils.success('Message')`
  - `ToastUtils.failed('Message')`
  - `ToastUtils.updated('Message')`
  - `ToastUtils.deleted('Message')`

- **`DateTimeUtils`**: Date and time formatting utilities.

- **`CommonUtils`**: General utility functions.

- **`InAppReviewChecker`**: Helper for requesting app reviews.

## 📦 Dependencies

This package relies on:
- `google_mobile_ads`: ^9.2.0 — Google AdMob SDK with Android Next-Gen support
- `purchases_flutter`: ^9.8.0 — RevenueCat IAP SDK
- `purchases_ui_flutter`: ^9.8.0 — RevenueCat Paywall UI
- `app_tracking_transparency`: ^2.0.6+1 — iOS ATT dialog
- `lottie`: ^3.3.2 — Animations
- `fluttertoast`: ^9.0.0 — Toast notifications
- `internet_connection_checker_plus`: ^2.9.0 — Connectivity detection
- `in_app_review`: ^2.0.11 — App review requests
- `intl`: ^0.20.2 — Internationalization

## 🚀 Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  tp_media: ^2.0.0
```

Then run:

```bash
flutter pub get
```

### Import

```dart
import 'package:tp_media/tp_media.dart';
```

## 📖 Usage Guide

### AdMob Setup

#### Android GMA Next-Gen SDK

Requires Flutter **3.38.1+**, Dart **3.10.0+**, and Android `minSdk` **24+**.
`tp_media` uses the official `google_mobile_ads`
plugin for banner, native templates, interstitial, rewarded, and app-open ads.
The resolved Android dependencies, including Lifecycle Compose 2.11.0,
require `compileSdk` **37+** and Android Gradle Plugin **9.1+**. The example
uses Android Gradle Plugin **9.1.1**, Gradle **9.3.1**, Kotlin
**2.2.21**, and JDK **17**. Update older host build tools alongside the SDK.
For AGP 9, Flutter recommends **3.44+** with the compatibility properties
`android.builtInKotlin=false` and `android.newDsl=false` in
`android/gradle.properties`; the example includes both. See the
[Flutter AGP migration guide](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers).

Next-Gen is selected at build time by the **host app**. Every Android run,
APK build, and app bundle build must include this flag, including CI builds:

```bash
flutter run --dart-define=USE_NEXT_GEN_SDK=true
flutter build apk --dart-define=USE_NEXT_GEN_SDK=true
flutter build appbundle --dart-define=USE_NEXT_GEN_SDK=true
```

Without the flag, the plugin selects the legacy Android SDK. A Dart package
cannot set this flag for apps that depend on it. The repository's VS Code
example launch already includes it. To run the example from a terminal:

```bash
cd example
flutter pub get
flutter run --dart-define=USE_NEXT_GEN_SDK=true
```

Keep the host app's AdMob application ID in `AndroidManifest.xml` under
`com.google.android.gms.ads.APPLICATION_ID`; the Flutter plugin uses it for
Next-Gen initialization too. Use your production app ID in your own app;
the example contains Google's test app ID.

The built-in `NativeTemplateStyle` integration needs no custom Android
factory changes. Host apps with their own native factories or mediation
adapters must also follow Google's
[Next-Gen migration guide](https://developers.google.com/admob/flutter/android-next)
for native imports, layouts, and compatible mediation dependencies.

The Next-Gen switch applies to Android. iOS continues to use the Google
Mobile Ads iOS SDK supplied by the plugin. After upgrading, run `pod install`
in the host app's `ios` directory to update native dependencies.

#### Initialize AdMob SDK

```dart
import 'package:tp_media/tp_media.dart';

// Call once from a mounted screen before loading ads.
Future<void> initializeAds(BuildContext context) async {
  await AdmobInitializer.init(
    context,
    buildTrackingTransparencyDialog(
      context,
      title: 'Personalized ads',
      message: 'Allow tracking to help us show relevant ads.',
      continueButton: 'Continue',
    ),
  );
}
```

#### Display Banner Ad

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(child: YourContent()),
      AdmobBannerAd('ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy'), // Replace with your ad unit ID
    ],
  );
}
```

**Test Mode** (for iOS screenshots):
```dart
AdmobBannerAd.isTestMode = true; // Set before showing
```

#### Display App Open Ad

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    AdmobOpenAd.showAdIfAvailable();
  }
}
```

#### Interstitial & Rewarded Ads with Mixins

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with InterstitialAdMixin, RewardedAdMixin {
  @override
  String get interstitialUnitId => 'ca-app-pub-xxx';

  @override
  String get rewardedUnitId => 'ca-app-pub-yyy';

  @override
  bool get isEnableAd => true;

  @override
  void initState() {
    super.initState();
    loadAd(); // Load interstitial
    loadRewardedAd(); // Load rewarded
  }

  void showInterstitialOnButtonTap() {
    loadAndShowAd(
      onDismissAd: () {
        print('User dismissed ad');
      },
    );
  }

  void showRewardOnButtonTap() {
    loadAndShowRewardedAd(
      onUserEarnedReward: (reward) {
        print('User earned: ${reward.amount} ${reward.type}');
      },
      onDismissAd: () {
        print('Rewarded ad dismissed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextButton(
              text: 'Show Interstitial',
              onPressed: showInterstitialOnButtonTap,
            ),
            SizedBox(height: 16),
            CommonTextButton(
              text: 'Show Rewarded',
              onPressed: showRewardOnButtonTap,
            ),
          ],
        ),
      ),
    );
  }
}
```

### In-App Purchases (RevenueCat)

#### Create Custom IAP Manager

```dart
class MyIapManager extends IapManager {
  MyIapManager._internal();
  
  static final _instance = MyIapManager._internal();
  static MyIapManager get instance => _instance;

  @override
  String entitlementId = 'pro_subscription'; // Your RevenueCat entitlement ID
}
```

#### Initialize IAP

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await IapInitializer.init([MyIapManager.instance]);
  
  runApp(MyApp());
}
```

#### Check Subscription Status

```dart
class PremiumContent extends StatefulWidget {
  @override
  State<PremiumContent> createState() => _PremiumContentState();
}

class _PremiumContentState extends State<PremiumContent> {
  @override
  void initState() {
    super.initState();
    MyIapManager.instance.stream.listen((isSubscribed) {
      print('Subscription status: $isSubscribed');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: MyIapManager.instance.stream,
      builder: (context, snapshot) {
        final isSubscribed = snapshot.data ?? false;
        
        return isSubscribed
            ? PremiumFeatures()
            : PaywallScreen();
      },
    );
  }
}
```

#### Show Paywall

```dart
CommonTextButton(
  text: 'Show Paywall',
  onPressed: () async {
    final result = await MyIapManager.instance.presentPaywallIfNeeded();
    if (result) {
      print('Purchase successful or already subscribed');
    }
  },
)
```

### Dialogs

#### Common Alert Dialog

```dart
showAlertDialog(
  context,
  title: 'Confirm',
  message: 'Are you sure?',
  okText: 'Yes',
  cancelText: 'No',
  onOkButton: () {
    print('User confirmed');
    Navigator.pop(context);
  },
);
```

#### iOS Tracking Transparency

```dart
showDialog(
  context: context,
  builder: (_) => buildTrackingTransparencyDialog(),
);
```

### Common Widgets

#### Cards
```dart
CommonCard(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
  radius: BorderRadius.circular(12),
  elevation: 4,
)
```

#### Empty State
```dart
CommonEmpty(
  title: 'No data',
  description: 'Try again later',
)
```

#### Buttons
```dart
CommonTextButton(
  text: 'Click Me',
  onPressed: () {},
)

CommonIconButton(
  icon: Icons.add,
  onPressed: () {},
)
```

#### Text Field
```dart
CommonTextField(
  controller: _controller,
  hintText: 'Enter text',
)
```

#### Loading
```dart
GlobalLoading.show(context); // Show loading
// ... async operation ...
GlobalLoading.hide(); // Hide loading
```

### Extensions Usage

```dart
// Context
context.showSnackbar('Hello');
context.showSuccessSnackBar('Success!');
context.showErrorSnackBar('Error!');

// String
print('hello'.capitalize()); // Hello
print('hà nội'.vnToEn); // ha noi

// Double
print(3.14159.round(2)); // 3.14

// ScrollController
if (scrollController.scrollToBottom) {
  print('Scrolled to bottom');
}
```

### Toasts

```dart
ToastUtils.success('Operation successful');
ToastUtils.failed('Operation failed');
ToastUtils.updated('Item updated');
ToastUtils.deleted('Item deleted');
```

### Network Connectivity

```dart
// Check current status
final isOnline = await InternetManager.instance.isOnline;
print('Online: $isOnline');

// Listen to changes
InternetManager.instance.onStatusChange.listen((status) {
  print('Status: $status');
});
```

## 🔧 Platform Configuration

### Android

Add to `android/app/build.gradle.kts`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

Add permissions to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS

Add to `ios/Podfile` (if needed):
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_APP_TRACKING_TRANSPARENCY=1',
      ]
    end
  end
end
```

Add to `ios/Runner/Info.plist`:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

## 📚 Example

See the [example app](example/) for a complete working implementation including:
- AdMob banner, interstitial, and rewarded ads
- RevenueCat in-app purchases
- Common widgets usage
- Extensions examples

Run it with:
```bash
cd example
flutter run
```

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Built with ❤️ using:
- [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads)
- [RevenueCat](https://pub.dev/packages/purchases_flutter)
- [Lottie](https://pub.dev/packages/lottie)
- [Flutter](https://flutter.dev)

---

For more information, visit the [repository](https://github.com/thienphan1996/tp_media).

