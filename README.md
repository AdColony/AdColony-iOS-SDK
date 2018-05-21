# AdColony iOS SDK
* Modified: May 18th, 2018
* SDK Version: 3.3.4


## Overview
AdColony delivers zero-buffering, [full-screen Instant-Play™ HD video](https://www.adcolony.com/technology/instant-play/), [interactive Aurora™ Video](https://www.adcolony.com/technology/auroravideo), and Aurora™ Playable ads that can be displayed anywhere within your application. Our advertising SDK is trusted by the world’s top gaming and non-gaming publishers, delivering them the highest monetization opportunities from brand and performance advertisers. AdColony’s SDK can monetize a wide range of ad formats including in-stream/pre-roll, out-stream/interstitial and V4VC™, a secure system for rewarding users of your app with virtual currency upon the completion of video and playable ads.



## Release Notes

### 3.3.4
* Added a new API to pass user consent as required for compliance with the European Union's General Data Protection Regulation (GDPR). If you are collecting consent from your users, you can make use of this new API to inform AdColony and all downstream consumers of the consent. Please see our [GDPR FAQ](https://www.adcolony.com/gdpr/) for more information and [our GDPR wiki](https://github.com/AdColony/AdColony-iOS-SDK-3/wiki/GDPR) for implementation details.
* Fixed a bug where advertisement video's close button was not easily tappable because of the status bar overlapping.
* Fixed a bug where unsafe access to the device's battery level was causing a crash mentioned in issue [#49] (https://github.com/AdColony/AdColony-iOS-SDK-3/issues/49).
* Several bug fixes and stability improvements.

Here is the link to the [release notes](https://github.com/AdColony/AdColony-iOS-SDK-3/blob/master/CHANGELOG.md) for all the previous SDK versions and please check out the 3.3 SDK [integration tips](https://www.adcolony.com/blog/2018/02/22/reaching-new-heights-sdk-3-3/).

## Getting Started
To get started, here is the link to [iOS SDK integration documentation](https://github.com/AdColony/AdColony-iOS-SDK-3/wiki).

**Note:**

* SDK 3.3 is tested and verified on iOS 11
* SDK 3.3 compiles on iOS 6; however, video ads will only show on iOS 8 and above.
* SDK 3.3 is not backwards compatible with any AdColony 2.0 integrations due to major API changes.

## Upgrade

#### SDK 2.X
Please note that updating from our 2.x SDK is not a drag and drop update, but rather includes breaking API and process changes. In order to take advantage of the 3.x SDK, a complete re-integration is necessary. Please review our [documentation](https://github.com/AdColony/AdColony-iOS-SDK-3/wiki) to get a better idea on what changes will be necessary in your app.

For detailed information about the AdColony SDK, see our [iOS SDK documentation](https://github.com/AdColony/AdColony-iOS-SDK-3/wiki).

#### SDK 3.X
Updating from our previous SDK 3.x to SDK 3.3 requires no code changes. If you are not using CocoaPods, all you need to do is drag and drop the framework into your Xcode project. If you are using Cocoapods, however, all you need to do is sync with the latest by running `pod update`.


## Legal Requirements
By downloading the AdColony SDK, you are granted a limited, non-commercial license to use and review the SDK solely for evaluation purposes.  If you wish to integrate the SDK into any commercial applications, you must register an account with AdColony and accept the terms and conditions on the AdColony website.

Note that U.S. based companies will need to complete the W-9 form and send it to us before publisher payments can be issued.

## Contact Us
For more information, please visit AdColony.com. For questions or assistance, please email us at support@adcolony.com.
