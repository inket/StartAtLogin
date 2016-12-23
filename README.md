## StartAtLogin ![](https://img.shields.io/badge/Carthage-supported-brightgreen.svg)

StartAtLogin is a framework for Swift macOS apps looking to add a "Start at Login" feature with minimal work.

Current solutions require a significant amount of steps to implement, with lots of variables and frequently imprecise instructions. StartAtLogin gets rid of that:

<img src="https://i.imgur.com/k48qkTx.jpg" width="520" height="203" />

StartAtLogin is App Store-approved and is currently being used in the app [stts](https://itunes.apple.com/app/stts/id1187772509?ls=1&mt=12)

### Usage

Add StartAtLogin via Carthage:

__Cartfile__
```
github "inket/StartAtLogin"
```

Add a new build phase "Run Script Phase" to your app, with the following script:

```sh
FRAMEWORKS_HELPER_PATH="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/StartAtLogin.framework/Versions/A/Resources/StartAtLoginHelper.app"
HELPER_DIR="$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/Library/LoginItems"
HELPER_PATH="$HELPER_DIR/StartAtLoginHelper.app"

mkdir -p "$HELPER_DIR"
rm -rf "$HELPER_PATH"
cp -rf "$FRAMEWORKS_HELPER_PATH" "$HELPER_DIR/"

if [ "$CONFIGURATION" == "Release" ]; then
  rm -rf "$FRAMEWORKS_HELPER_PATH"
fi

defaults write "$HELPER_PATH/Contents/Info" CFBundleIdentifier -string "$PRODUCT_BUNDLE_IDENTIFIER-StartAtLoginHelper"
codesign --force --entitlements "$CODE_SIGN_ENTITLEMENTS" -s "$EXPANDED_CODE_SIGN_IDENTITY_NAME" -v "$HELPER_PATH"
```

Use StartAtLogin in your app:

```swift
import StartAtLogin

// Enable
StartAtLogin.enabled = true

// Disable
StartAtLogin.enabled = false

// Check status
debugPrint(StartAtLogin.enabled)
```

#### Contact

[@inket](https://github.com/inket) / [@inket](https://twitter.com/inket) on Twitter / [mahdi.jp](https://mahdi.jp)


