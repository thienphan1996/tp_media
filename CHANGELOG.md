## 2.0.0

### Breaking changes

* Require Flutter >=3.38.1 and Dart >=3.10.0; older SDKs can continue using tp_media 1.x.
* Upgrade to google_mobile_ads 9.2.0. Android hosts must update their build tools for the resolved dependencies (compile SDK 37 and AGP 9.1+).
* Enable Android Next-Gen builds with `--dart-define=USE_NEXT_GEN_SDK=true`; see README for Gradle and Flutter compatibility settings.

### Improvements

* Optimize banner loading: reuse unchanged configurations, use available layout width, cancel obsolete loads, and handle ad enable/disable and unit ID changes.
* Retry initial banner failures with bounded backoff and recover on network reconnection or app resume; keep SDK-managed refresh for displayed ads.
* Render banner screenshot mode immediately without requesting a real ad.
* Migrate to `google_mobile_ads ^9.2.0` with Android GMA Next-Gen SDK support.
* Configure the example launch for Next-Gen and document the required build flag for consuming apps.
* Await ad request configuration before initializing Mobile Ads.
* Use the current large adaptive banner API.
* Update the example to compile SDK 37, Android Gradle Plugin 9.1.1, Gradle 9.3.1, and Kotlin 2.2.21 to satisfy resolved Lifecycle Compose dependencies.

## 0.0.1

* Initial release.
## 0.0.2

* Add IapInitializer.
## 0.0.3

* Add TopRoundedContainer, Paywall.
## 0.0.4

* Add extensions, common widgets.
* Add theme
* Add Context extensions
## 0.0.5

* Update logic cache In-app purchase
## 0.0.6

* Add logic check internet connection before load ad
## 0.0.7

* Add internet checker widget

## 0.0.8

* Add premium user widget

## 1.0.0

* Add in-app review checker
* Stable version

## 1.0.1

* Update logic init iap managers

## 1.0.2

* Fix show paywall when no internet

## 1.0.3

* Add common widgets

## 1.0.4

* Fix dismiss loading dialog

## 1.0.5

* Add common widgets

## 1.0.6

* Cleanup source

## 1.0.7

* Add Native Ad
* Optimize Premium User widget

## 1.0.8

* Add Upgrade Premium widget
* Optimize Premium User widget

## 1.0.9

* Fix show paywall when no internet
* Add listener customer info update

## 1.0.10

* Add check connection flag to presentPaywall functions

## 1.1.0

* Optimize load ads
