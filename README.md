# Dopamine Fast

Dopamine Fast is an iOS SwiftUI prototype for a "pause before scrolling" product.

The product idea is simple: when a user is about to enter a high-stimulation app loop, the app inserts a short pause so the user can choose deliberately instead of acting on impulse.

## What It Does

The current prototype includes:

- A SwiftUI app with `Pause`, `Plan`, and `Review` tabs.
- Screen Time authorization through `FamilyControls.AuthorizationCenter`.
- App, category, and web-domain selection through `FamilyActivityPicker`.
- Manual shielding through `ManagedSettingsStore.shield`.
- A `ShieldConfigurationExtension` with custom interruption copy.
- A `ShieldActionExtension` for shield button handling.

The first version focuses on a manual shield flow. Scheduled protection windows with `DeviceActivity` are the next natural step.

## Technical Approach

Dopamine Fast follows the App Store-compliant Screen Time path:

- `FamilyControls` lets the user privately select apps, categories, and web domains.
- `ManagedSettings` applies shields to the selected tokens.
- `ManagedSettingsUI` provides the custom shield configuration UI.
- Shield action handling decides how the system responds when a shield button is tapped.

The app does not monitor foreground apps directly and does not rely on private APIs.

## Requirements

- Xcode 27
- iOS 18.0+ deployment target
- XcodeGen
- A paid Apple Developer Program team for real-device Family Controls testing

This machine's Xcode 27 install is:

```sh
/Applications/Xcode-beta.app
```

Use `DEVELOPER_DIR` explicitly so commands do not fall back to the system default Xcode.

## Capability Limitation

Family Controls is a restricted Apple capability.

Free Personal Teams do not support `Family Controls (Development)`. To test Screen Time authorization and shielding on a physical device, the main app and both extensions need Family Controls enabled on their App IDs in the Apple Developer portal.

Bundle IDs:

- `com.willwang.dopaminefast`
- `com.willwang.dopaminefast.ShieldConfigurationExtension`
- `com.willwang.dopaminefast.ShieldActionExtension`

Simulator builds can verify compilation, app launch, UI, target embedding, and extension metadata. Real Screen Time behavior must be validated on a physical device.

## Project Structure

```text
DopamineFast/
  DopamineFast/                    Main SwiftUI app
  ShieldConfigurationExtension/    Custom shield appearance
  ShieldActionExtension/           Shield button behavior
  project.yml                      XcodeGen project definition
  AGENTS.md                        Agent/developer instructions
  CLAUDE.md -> AGENTS.md           Symlink for Claude-compatible tooling
```

## Generate the Xcode Project

The Xcode project is generated from `project.yml`:

```sh
xcodegen generate
```

Prefer editing `project.yml` for targets, entitlements, dependencies, and scheme changes.

## Build

Verified simulator:

- `iPhone 17`
- iOS 27.0
- Device ID: `E470C84E-F51B-4866-848F-A5081580D6C6`

Build command:

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -project DopamineFast.xcodeproj -scheme DopamineFast -configuration Debug -destination id=E470C84E-F51B-4866-848F-A5081580D6C6 -derivedDataPath DerivedData build
```

## Run on Simulator

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl install E470C84E-F51B-4866-848F-A5081580D6C6 "DerivedData/Build/Products/Debug-iphonesimulator/Dopamine Fast.app"
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl launch --terminate-running-process E470C84E-F51B-4866-848F-A5081580D6C6 com.willwang.dopaminefast
```

## Current Status

Implemented and building:

- SwiftUI prototype UI
- Screen Time authorization entry point
- System app/category/domain picker
- Manual shield activation
- Shield configuration extension
- Shield action extension

Not implemented yet:

- `DeviceActivity` schedules for automatic focus windows
- Real "pause for 3 minutes, then temporary unlock" flow
- Persistent review analytics beyond the prototype UI
- Production signing and provisioning
