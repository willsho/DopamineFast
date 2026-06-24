# Dopamine Fast 项目状态

更新时间：2026-06-24

## 项目位置

本地项目目录：

```text
/Users/willwang/codebase/DopamineFast
```

GitHub 仓库：

```text
https://github.com/willsho/DopamineFast.git
```

当前已推送提交：

```text
beb8e33 Initial Dopamine Fast iOS prototype
```

## 产品方向

Dopamine Fast 是一个 iOS 自控工具原型，核心理念是：

```text
刷之前，先停三分钟。
```

它不是监听用户当前打开了哪个 App，而是走 Apple Screen Time 合规路线：

1. 用户授权 Screen Time。
2. 用户通过系统选择器选择容易沉迷的 App、分类或网站。
3. App 使用 `ManagedSettings` 对这些 token 应用 Shield。
4. 用户打开被 Shield 的目标时，系统展示自定义拦截页。

当前产品定位是“冲动中断器”，不是“后台监控器”。

## 已完成

### 项目基础

- 在 `/Users/willwang/codebase/DopamineFast` 创建了 SwiftUI iOS 项目。
- 项目使用 XcodeGen 管理，配置文件是 `project.yml`。
- 生成了 `DopamineFast.xcodeproj`。
- 创建了英文 README：`README.md`。
- 创建了中文 README：`README.zh-CN.md`。
- 创建了 agent 说明：`AGENTS.md`。
- 创建了 `CLAUDE.md -> AGENTS.md` 符号链接。
- 创建了 `.gitignore`，排除了 `DerivedData/`、截图和 Xcode 本地状态。
- 初始化 git 仓库并推送到 GitHub。

### SwiftUI App

主 App target：

```text
DopamineFast
```

Bundle ID：

```text
com.willwang.dopaminefast
```

当前 UI 包含三个 Tab：

- `暂停`
- `计划`
- `复盘`

核心文件：

- `DopamineFast/DopamineFastApp.swift`
- `DopamineFast/ContentView.swift`
- `DopamineFast/PauseView.swift`
- `DopamineFast/PlanView.swift`
- `DopamineFast/ReviewView.swift`
- `DopamineFast/DesignSystem.swift`

### Screen Time 集成

已实现基础 Screen Time 闭环：

- `FamilyControls.AuthorizationCenter` 授权入口。
- `FamilyActivityPicker` 系统 App / 分类 / 网站选择器。
- `ManagedSettingsStore.shield` 手动开启/关闭 Shield。
- 选择结果通过 `UserDefaults` 保存。
- Shield 状态通过 `UserDefaults` 保存。

核心文件：

```text
DopamineFast/ScreenTimeManager.swift
```

### Shield Extensions

已新增两个 extension target。

#### Shield Configuration Extension

目录：

```text
ShieldConfigurationExtension/
```

Bundle ID：

```text
com.willwang.dopaminefast.ShieldConfigurationExtension
```

扩展点：

```text
com.apple.ManagedSettingsUI.shield-configuration-service
```

作用：

- 自定义系统 Shield 页文案。
- 当前文案主题是“刷之前，先停三分钟”。

核心文件：

```text
ShieldConfigurationExtension/ShieldConfigurationExtension.swift
```

#### Shield Action Extension

目录：

```text
ShieldActionExtension/
```

Bundle ID：

```text
com.willwang.dopaminefast.ShieldActionExtension
```

扩展点：

```text
com.apple.ManagedSettings.shield-action-service
```

作用：

- 处理 Shield 页面按钮点击。
- 当前 primary button 返回 `.close`。
- 当前 secondary button 返回 `.defer`。

核心文件：

```text
ShieldActionExtension/ShieldActionExtension.swift
```

### Entitlements

三个 target 都创建了 entitlements 文件：

```text
DopamineFast/DopamineFast.entitlements
ShieldConfigurationExtension/ShieldConfigurationExtension.entitlements
ShieldActionExtension/ShieldActionExtension.entitlements
```

内容都声明：

```text
com.apple.developer.family-controls = true
```

注意：文件已配置到 build settings，但真机使用还依赖 Apple Developer 后台 capability。

## 关键限制

Family Controls 是 Apple 受限 capability。

已确认限制：

```text
Personal development teams, do not support the Family Controls (Development) capability.
```

含义：

- 免费 Personal Team 不能真机测试 Family Controls。
- 需要付费 Apple Developer Program。
- 主 App 和两个 extension 的 App ID 都需要在 Apple Developer 后台开启 Family Controls capability。
- Simulator 可以验证编译、UI、extension 嵌入和扩展点配置，但不能完整验证真实 Screen Time 授权和 Shield 行为。

## Xcode / 构建环境

本机必须使用 Xcode 27：

```text
/Applications/Xcode-beta.app
```

不要使用系统默认 Xcode。默认 `/Applications/Xcode.app` 是 Xcode 26.5，之前会导致 destination / SDK 行为不一致。

所有构建命令建议显式设置：

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
```

已验证 simulator：

```text
iPhone 17
iOS 27.0
Device ID: E470C84E-F51B-4866-848F-A5081580D6C6
```

## 常用命令

### 重新生成 Xcode 项目

```sh
xcodegen generate
```

### 构建

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -project DopamineFast.xcodeproj -scheme DopamineFast -configuration Debug -destination id=E470C84E-F51B-4866-848F-A5081580D6C6 -derivedDataPath DerivedData build
```

最近一次构建结果：

```text
BUILD SUCCEEDED
```

构建图包含 3 个 target：

- `DopamineFast`
- `ShieldConfigurationExtension`
- `ShieldActionExtension`

### 安装到 simulator

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl install E470C84E-F51B-4866-848F-A5081580D6C6 "DerivedData/Build/Products/Debug-iphonesimulator/Dopamine Fast.app"
```

### 启动 simulator App

```sh
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun simctl launch --terminate-running-process E470C84E-F51B-4866-848F-A5081580D6C6 com.willwang.dopaminefast
```

## 当前 Git 状态

远端：

```text
origin https://github.com/willsho/DopamineFast.git
```

当前分支：

```text
main
```

当前 `main` 已跟踪：

```text
origin/main
```

上次确认状态：

```text
main...origin/main
```

## 正在做什么

当前阶段已经完成“可编译的 Screen Time 基础原型”。

项目处于：

```text
MVP scaffold + Screen Time manual shield integration
```

也就是说：

- UI 原型已存在。
- Screen Time 授权入口已存在。
- 系统 App 选择器已存在。
- 手动 Shield 开关已存在。
- Shield extension 已存在。
- 真机真实授权和拦截还没验证，因为需要付费开发者账号和 Family Controls capability。

## 下一步建议

### 1. 解决 Apple Developer capability

优先级最高。

需要：

- 使用付费 Apple Developer Program 团队。
- 在 Apple Developer 后台创建/配置三个 App ID。
- 分别开启 Family Controls capability。
- 更新 Xcode signing team。
- 重新生成 provisioning profiles。
- 在真机测试授权、选择器和 Shield。

### 2. 做 DeviceActivity 自动时段

当前是手动 Shield 开关。下一步可以加：

- `DeviceActivityMonitorExtension`
- 工作时段自动开始 shield
- 睡前自动开始 shield
- 时段结束自动解除 shield

### 3. 实现“三分钟停顿后临时放行”

当前 Shield action 只有 `.close` 和 `.defer`。

后续目标：

- 用户点击 Shield 页面按钮后回到 Dopamine Fast。
- App 内开始 3 分钟倒计时。
- 倒计时结束后允许短时放行，例如 5 分钟。
- 放行结束后重新 shield。

需要设计好主 App、Shield extension、ManagedSettingsStore 之间的状态同步。

### 4. 增强复盘数据

当前复盘页是静态原型。

后续可记录：

- 今天触发多少次停顿。
- 成功停下多少次。
- 放行多少次。
- 最容易冲动的时间段。
- 本周减少使用估算。

### 5. 清理原型资源

当前根目录有本地截图文件：

```text
screenshot.png
screenshot-launched.png
screenshot-screentime.png
```

它们已被 `.gitignore` 排除，没有推到 GitHub。后续可以手动删除或保留本地参考。

## 重要原则

- 不要实现私有 API 或当前前台 App 监听。
- 不要承诺“用户一打开抖音/小红书就立刻收到 push”。
- 合规路线是用户授权后选择 token，再通过 Screen Time shield 中断使用。
- 产品文案避免羞辱用户，保持“重新选择一次”的语气。
- 修改 target、entitlements、scheme 时优先改 `project.yml`，然后运行 `xcodegen generate`。
