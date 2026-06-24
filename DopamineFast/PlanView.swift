import SwiftUI
import FamilyControls

struct PlanView: View {
    @EnvironmentObject private var screenTimeManager: ScreenTimeManager
    @State private var isPickerPresented = false
    @State private var selectedMinutes = 3.0

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("Screen Time", systemImage: "hourglass")
                        Spacer()
                        Text(screenTimeManager.authorizationLabel)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(screenTimeManager.isAuthorized ? .green : .secondary)
                    }

                    Button {
                        Task {
                            await screenTimeManager.requestAuthorization()
                        }
                    } label: {
                        Label(screenTimeManager.isAuthorized ? "刷新授权状态" : "请求 Screen Time 授权", systemImage: "checkmark.shield")
                    }

                    Toggle("开启 Shield 拦截", isOn: $screenTimeManager.isShieldActive)
                        .disabled(!screenTimeManager.isAuthorized || screenTimeManager.selectedItemCount == 0)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("默认停顿")
                            Spacer()
                            Text("\(Int(selectedMinutes)) 分钟")
                                .foregroundStyle(.secondary)
                        }

                        Slider(value: $selectedMinutes, in: 1...10, step: 1)
                    }
                    .padding(.vertical, 4)
                } footer: {
                    Text("Shield 会在被选中的 App、分类或网站打开时显示系统拦截页。当前版本先做手动开关，后续再接 DeviceActivity 时段。")
                }

                Section("高刺激 App") {
                    SelectionMetricRow(
                        title: "已选 App",
                        value: screenTimeManager.selection.applicationTokens.count,
                        icon: "apps.iphone"
                    )
                    SelectionMetricRow(
                        title: "已选分类",
                        value: screenTimeManager.selection.categoryTokens.count,
                        icon: "square.grid.2x2"
                    )
                    SelectionMetricRow(
                        title: "已选网站",
                        value: screenTimeManager.selection.webDomainTokens.count,
                        icon: "globe"
                    )

                    Button {
                        isPickerPresented = true
                    } label: {
                        Label("选择要管理的 App", systemImage: "plus.circle")
                    }
                    .disabled(!screenTimeManager.isAuthorized)
                }

                Section("防冲动时段") {
                    ScheduleRow(title: "工作日上午", detail: "09:00 - 12:00")
                    ScheduleRow(title: "工作日下午", detail: "14:00 - 18:00")
                    ScheduleRow(title: "睡前", detail: "23:00 - 07:00")
                }
            }
            .navigationTitle("计划")
            .familyActivityPicker(
                headerText: "选择容易让你进入刷新循环的 App、分类或网站。",
                footerText: "Dopamine Fast 只能拿到系统 token，看不到具体 App 名称。",
                isPresented: $isPickerPresented,
                selection: $screenTimeManager.selection
            )
            .onAppear {
                screenTimeManager.refreshAuthorizationStatus()
            }
            .alert("Screen Time 操作失败", isPresented: errorAlertBinding) {
                Button("知道了", role: .cancel) {
                    screenTimeManager.errorMessage = nil
                }
            } message: {
                Text(screenTimeManager.errorMessage ?? "")
            }
        }
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { screenTimeManager.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    screenTimeManager.errorMessage = nil
                }
            }
        )
    }
}

private struct ScheduleRow: View {
    let title: String
    let detail: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }
}

private struct SelectionMetricRow: View {
    let title: String
    let value: Int
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)

            Text(title)
            Spacer()
            Text("\(value)")
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PlanView()
        .environmentObject(ScreenTimeManager())
}
