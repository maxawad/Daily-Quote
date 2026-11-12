# Daily Sutra (Daily Quote)

Daily Sutra is an iPhone app that sends you one short verse or quote each day as a notification, at a time you choose. A companion Apple Watch app and watch complication show the same daily text on your wrist. The project started in 2018 as "Daily Quote" and was renamed "Daily Sutra" in 2019.

## What it does

- Lets you pick a time of day and schedules a repeating local notification with that day's verse.
- Ships with a built-in list of verses (chapter 1 onward of the Bhagavad Gita, stored in `Daily Sutra/data.swift` and `Daily Sutra Watchkit App Extension/watchdata.swift`).
- Can also read a quote feed (BrainyQuote RSS) through the FeedKit library and save the latest quote with Core Data.
- Includes an Apple Watch app, notification interface and complications.
- Has a StoreKit auto-renewing subscription hook (`IAPService.swift`). The product identifier is a placeholder tied to the original App Store Connect account, so purchases will not work for anyone else.
- Uses background images and Lottie and GIF animations.

## Tech stack

- Swift, UIKit, storyboards
- UserNotifications, Core Data, StoreKit, WatchKit
- CocoaPods: FeedKit 6, lottie-ios 2.5, SwiftGifOrigin 1.6

## Run it

You need a Mac with Xcode. This is a native iOS app, so it cannot run as a website.

1. Clone the repository.
2. Open `Daily Sutra.xcworkspace` (not the `.xcodeproj`) in Xcode.
3. If Xcode reports missing pods, run `pod install` in the repository root, then reopen the workspace.
4. In the project settings, choose your own Apple development team and change the bundle identifiers (they currently use `com.maxmax2012...`).
5. Select the `Daily Sutra` scheme and an iPhone simulator, then press Run. Use the `Daily Sutra Watchkit App` scheme for the watch app.

The code targets the iOS 12 and watchOS 5 era SDKs (2018 and 2019), so newer Xcode versions may need small Swift syntax and deployment target fixes.

## Status

Prototype that was prepared for App Store submission in 2019 and has not been maintained since. No API keys are needed. The in-app purchase will not work without your own App Store Connect setup.

## Repository layout

- `Daily Sutra/` iPhone app source, storyboards and assets
- `Daily Sutra Watchkit App/` and `Daily Sutra Watchkit App Extension/` Apple Watch app
- `Model.xcdatamodeld/` Core Data model
- `Pods/` and `Podfile` CocoaPods dependencies
- `External Resources/` icon and animation source files (Photoshop and After Effects)

## Credits

- Verse text is from the Bhagavad Gita. Check the rights of the translation you use before redistributing the app.
- Background photos are from Unsplash photographers (see the image file names in `Daily Sutra/Images.xcassets`).
- Libraries: [FeedKit](https://github.com/nmdias/FeedKit), [lottie-ios](https://github.com/airbnb/lottie-ios), [SwiftGifOrigin](https://github.com/bahlo/SwiftGif).
- Original app by Moustafa (Max) Awad.
