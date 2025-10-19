# tp_media

A compact Flutter utility package providing fast AdMob ad integration, in-app purchase helpers, and a suite of common UI utilities and widgets for rapid app development.

[![pub.dev](https://img.shields.io/pub/v/tp_media.svg)](https://pub.dev/packages/tp_media)
[Repository](https://github.com/thienphan1996/tp_media)

## Features
- **AdMob Integration**: Fast banner, open, interstitial, and rewarded ad helpers
  - `AdmobBannerAd`: Responsive banner ad widget that adapts to orientation and screen size. Supports test mode for development.
  - `AdmobOpenAd`: Easily show app open ads on app launch or resume.
  - `InterstitialAdMixin` & `RewardedAdMixin`: Mixins for simple integration of interstitial and rewarded ads with callbacks for ad events.
  - `AdmobInitializer`: One-call initialization for Google Mobile Ads SDK.
  - `TrackingTransparencyDialog`: iOS dialog for ATT (App Tracking Transparency) permission.

- **IAP Utilities**: Easy in-app purchase setup and management
  - `IapInitializer`: Initialize in-app purchase plugins and handle platform setup.
  - `IapManager`: Manage product purchases, listen for updates, and restore transactions.

- **UI Widgets**: Common cards, empty states, icon/text buttons, text fields, snackbars, loading indicators
  - `CommonCard`, `CommonEmpty`, `CommonIconButton`, `CommonTextButton`, `CommonTextField`, `CommonSnackbar`, `GlobalLoading`, `TopRoundedContainer`, `MaterialInkWell`.
  - Consistent design and easy customization for rapid UI development.

- **Dialogs**: Customizable alert dialogs, iOS tracking transparency dialog
  - `CommonAlertDialog`: Flexible dialog for alerts, confirmations, and custom actions.
  - `TrackingTransparencyDialog`: Request user tracking permission on iOS.

- **Extensions**: Handy extensions for context, double, string, iterable, scroll controller, and text
  - `context.showSnackbar('Message')`: Show a SnackBar from any context.
  - `double.round()`: Format doubles with smart precision.
  - `String.capitalize()`, `String.isNullOrEmpty()`: String utilities.
  - `ScrollController.scrollToBottom`: Check if scroll is at the end.
  - `IterableExtension`: Extra methods for collections.

- **Utilities**: Toasts, date/time helpers
  - `ToastUtils.success('Success!')`, `ToastUtils.error('Error!')`.
  - `DateTimeUtils.toStringDisplay(date)`, `DateTimeUtils.nowDisplay`.

- **Mixins**: For interstitial and rewarded ad logic

## Getting Started
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  tp_media: ^latest_version
```

Then run:

```sh
flutter pub get
```

## Usage
Import the package:

```dart
import 'package:tp_media/tp_media.dart';
```

### More
- Use provided widgets for cards, empty states, buttons, and text fields
- Use extensions for concise code
- See the [example app](example) for full integration patterns

## Detailed Usage & API

### AdMob Ads
#### Banner Ad
A responsive banner ad that adapts to screen orientation and width.

```dart
AdmobBannerAd(
  'your-ad-unit-id',
)
```
- Set `AdmobBannerAd.isTestMode = true;` to enable test ads for iOS screenshots purpose.
- Automatically reloads on orientation change.

#### App Open Ad
```dart
await AdmobOpenAd.showAdIfAvailable();
```

#### Interstitial & Rewarded Ads
Use mixins for easy integration:
```dart
class MyWidgetState extends State<MyWidget> with InterstitialAdMixin, RewardedAdMixin {
  // Call showInterstitialAd() or showRewardedAd() as needed
}
```

### In-App Purchases (IAP)
#### Initialization
```dart
await IapInitializer.init([TestIapManager.instance,...]);
```
#### Purchase Flow
```dart
class TestIapManager extends IapManager {
  TestIapManager._internal();

  static final _instance = TestIapManager._internal();

  static TestIapManager get instance => _instance;

  @override
  String entitlementId = 'Testing';
}
```

### Dialogs
#### Common Alert Dialog
Customizable dialog for alerts and confirmations.
```dart
showDialog(
  context: context,
  builder: (_) => CommonAlertDialog(
    title: 'Title',
    message: 'Message',
    okText: 'okText',
    cancelText: 'cancelText',
    onOkButton: () {},
  ),
);
```
#### Tracking Transparency Dialog (iOS)
```dart
showDialog(
  context: context,
  builder: (_) => buildTrackingTransparencyDialog(),
);
```

### Extensions
- `context.showSuccessSnackBar('Message')` — Show a SnackBar from any context
- `3.14.round(1)` — Double extensions
- `'abc'.capitalize()` — String extensions
- `scrollController.scrollToBottom` — ScrollController extensions

### Utilities
- `ToastUtils.success('Message')` — Show a toast
- `DateTimeUtils.format(date)` — Format dates

### Widgets
- `CommonCard(child: ...)` — Card with consistent style
- `CommonEmpty()` — Empty state with animation
- `CommonIconButton(icon: Icons.add, onPressed: ...)`
- `CommonTextButton(text: 'OK', onPressed: ...)`
- `CommonTextField(controller: ...)`
- `CommonSnackbar.show(context, 'Message')`
- `GlobalLoading.show(context)` / `GlobalLoading.hide()`

### Mixins
- `InterstitialAdMixin` and `RewardedAdMixin` provide easy ad loading/showing with callbacks for success/failure.

## Platform Setup
### Android
- Add required permissions to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```
- For IAP, configure Google Play Billing in your app.

### iOS
- Add permissions and tracking descriptions to `Info.plist`:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
- Configure URL schemes for IAP if needed.

## Contributing
Contributions, bug reports, and feature requests are welcome! Fork the repo, create a branch, and submit a pull request.

## License
See the [LICENSE](LICENSE) file for details.

