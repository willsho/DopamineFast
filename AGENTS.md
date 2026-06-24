# AGENTS.md

## Project

Dopamine Fast is an iOS SwiftUI prototype for interrupting high-stimulation app use with a short pause.

The current implementation includes:

- SwiftUI app shell with Pause, Plan, and Review tabs.
- Screen Time authorization flow via `FamilyControls.AuthorizationCenter`.
- App/category/web-domain selection via `FamilyActivityPicker`.
- Shield application through `ManagedSettingsStore`.
- `ShieldConfigurationExtension` for custom shield copy.
- `ShieldActionExtension` for shield button behavior.

## Toolchain

Use Xcode 27 from:

```sh
/Applications/Xcode-beta.app
```

Do not rely on the system default Xcode. Commands should set:

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
```

Fast build check:

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -project DopamineFast.xcodeproj -scheme DopamineFast -configuration Debug -destination id=E470C84E-F51B-4866-848F-A5081580D6C6 -derivedDataPath DerivedData build
```

The verified simulator is `iPhone 17` on iOS 27.0.

## Project Generation

The Xcode project is generated from `project.yml` using XcodeGen:

```sh
xcodegen generate
```

Edit `project.yml` for target, entitlement, dependency, and scheme changes. Avoid hand-editing `DopamineFast.xcodeproj/project.pbxproj` unless XcodeGen cannot express the change.

## Capability Constraints

Family Controls is a restricted Apple capability.

Important:

- Free Personal Teams do not support `Family Controls (Development)`.
- Real Screen Time authorization and shielding need a paid Apple Developer Program team.
- The main app and both extensions need the Family Controls capability enabled for their App IDs.
- Simulator builds can verify compilation, embedding, and UI, but real Screen Time behavior must be validated on a physical device.

Bundle IDs:

- `com.willwang.dopaminefast`
- `com.willwang.dopaminefast.ShieldConfigurationExtension`
- `com.willwang.dopaminefast.ShieldActionExtension`

## Code Style

- Prefer small, reviewable diffs.
- Keep Screen Time API usage isolated behind `ScreenTimeManager` unless a broader refactor is justified.
- Use SwiftUI idioms and existing view structure.
- Keep user-facing copy concise and non-shaming.
- Do not add telemetry, analytics, or network calls unless explicitly requested.
- Do not commit generated `DerivedData` or screenshots unless explicitly requested.

## Verification

After code changes, run the fastest relevant check first:

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -project DopamineFast.xcodeproj -scheme DopamineFast -configuration Debug -destination id=E470C84E-F51B-4866-848F-A5081580D6C6 -derivedDataPath DerivedData build
```

For UI sanity checks, install and launch:

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl install E470C84E-F51B-4866-848F-A5081580D6C6 "DerivedData/Build/Products/Debug-iphonesimulator/Dopamine Fast.app"
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl launch --terminate-running-process E470C84E-F51B-4866-848F-A5081580D6C6 com.willwang.dopaminefast
```
