# Dopamine Fast

Dopamine Fast 是一个 iOS SwiftUI 原型，用来验证“刷之前，先停三分钟”的产品想法。

它的核心不是监控用户正在打开哪个 App，而是在用户主动选择的高刺激 App、分类或网站前面插入一个系统级停顿，让用户从冲动进入重新选择。

## 当前功能

当前原型已经包含：

- `暂停 / 计划 / 复盘` 三个 SwiftUI Tab。
- 通过 `FamilyControls.AuthorizationCenter` 请求 Screen Time 授权。
- 通过 `FamilyActivityPicker` 让用户选择 App、分类和网站。
- 通过 `ManagedSettingsStore.shield` 手动开启/关闭 Shield 拦截。
- `ShieldConfigurationExtension` 自定义系统拦截页文案。
- `ShieldActionExtension` 处理拦截页按钮行为。

当前版本先实现手动 Shield 流程。下一步更自然的是接入 `DeviceActivity`，实现按工作时段、睡前时段自动启用拦截。

## 技术路线

Dopamine Fast 走的是 App Store 合规的 Screen Time 路线：

- `FamilyControls`：让用户私密地选择要管理的 App、分类和网站。
- `ManagedSettings`：对用户选择的 token 应用 shield。
- `ManagedSettingsUI`：配置系统 Shield 拦截页。
- Shield Action Extension：处理用户点击拦截页按钮后的系统响应。

这个项目不监听当前前台 App，也不使用私有 API。

## 环境要求

- Xcode 27
- iOS 18.0+ deployment target
- XcodeGen
- 如果要真机验证 Family Controls，需要付费 Apple Developer Program 团队

本机 Xcode 27 路径是：

```sh
/Applications/Xcode-beta.app
```

运行命令时请显式设置 `DEVELOPER_DIR`，避免误用系统默认的 Xcode。

## Capability 限制

Family Controls 是 Apple 的受限 capability。

免费的 Personal Team 不支持 `Family Controls (Development)`。如果要在真机上测试 Screen Time 授权和 Shield 拦截，主 App 和两个 extension 的 App ID 都需要在 Apple Developer 后台开启 Family Controls capability。

Bundle ID：

- `com.willwang.dopaminefast`
- `com.willwang.dopaminefast.ShieldConfigurationExtension`
- `com.willwang.dopaminefast.ShieldActionExtension`

Simulator 可以验证编译、启动、UI、extension 嵌入和扩展点配置。真正的 Screen Time 授权和拦截行为需要真机验证。

## 项目结构

```text
DopamineFast/
  DopamineFast/                    主 SwiftUI App
  ShieldConfigurationExtension/    自定义 Shield 外观
  ShieldActionExtension/           Shield 按钮行为
  project.yml                      XcodeGen 项目定义
  AGENTS.md                        Agent/开发说明
  CLAUDE.md -> AGENTS.md           面向 Claude 工具的符号链接
```

## 生成 Xcode 项目

Xcode project 由 `project.yml` 生成：

```sh
xcodegen generate
```

target、entitlements、依赖和 scheme 变更优先改 `project.yml`，不要手动改 `DopamineFast.xcodeproj/project.pbxproj`。

## 构建

已验证的模拟器：

- `iPhone 17`
- iOS 27.0
- Device ID: `E470C84E-F51B-4866-848F-A5081580D6C6`

构建命令：

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -project DopamineFast.xcodeproj -scheme DopamineFast -configuration Debug -destination id=E470C84E-F51B-4866-848F-A5081580D6C6 -derivedDataPath DerivedData build
```

## 在模拟器运行

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl install E470C84E-F51B-4866-848F-A5081580D6C6 "DerivedData/Build/Products/Debug-iphonesimulator/Dopamine Fast.app"
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl launch --terminate-running-process E470C84E-F51B-4866-848F-A5081580D6C6 com.willwang.dopaminefast
```

## 当前状态

已实现并可构建：

- SwiftUI 原型界面
- Screen Time 授权入口
- 系统 App / 分类 / 网站选择器
- 手动 Shield 开关
- Shield Configuration Extension
- Shield Action Extension

暂未实现：

- 基于 `DeviceActivity` 的自动防冲动时段
- “停 3 分钟后临时放行”的完整流程
- 原型 UI 之外的持久化复盘分析
- 生产签名和 provisioning
