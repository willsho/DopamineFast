import FamilyControls
import Foundation
import ManagedSettings

@MainActor
final class ScreenTimeManager: ObservableObject {
    @Published private(set) var authorizationStatus: AuthorizationStatus
    @Published var selection: FamilyActivitySelection {
        didSet {
            saveSelection()
            if isShieldActive {
                applyShield()
            }
        }
    }
    @Published var isShieldActive: Bool {
        didSet {
            UserDefaults.standard.set(isShieldActive, forKey: Self.isShieldActiveKey)
            isShieldActive ? applyShield() : clearShield()
        }
    }
    @Published var errorMessage: String?

    private static let selectionKey = "screenTime.selection"
    private static let isShieldActiveKey = "screenTime.isShieldActive"

    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("dopamineFast"))

    init() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        selection = Self.loadSelection()
        isShieldActive = UserDefaults.standard.bool(forKey: Self.isShieldActiveKey)

        if isShieldActive {
            applyShield()
        }
    }

    var isAuthorized: Bool {
        if authorizationStatus == .approved {
            return true
        }

        if #available(iOS 26.4, *), authorizationStatus == .approvedWithDataAccess {
            return true
        }

        return false
    }

    var selectedItemCount: Int {
        selection.applicationTokens.count + selection.categoryTokens.count + selection.webDomainTokens.count
    }

    var authorizationLabel: String {
        switch authorizationStatus {
        case .notDetermined:
            return "未授权"
        case .denied:
            return "已拒绝"
        case .approved:
            return "已授权"
        case .approvedWithDataAccess:
            return "已授权"
        @unknown default:
            return "未知"
        }
    }

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
            errorMessage = nil
        } catch {
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
            errorMessage = error.localizedDescription
        }
    }

    func refreshAuthorizationStatus() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }

    func applyShield() {
        guard isAuthorized else {
            clearShield()
            return
        }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
    }

    func clearShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
    }

    private func saveSelection() {
        do {
            let data = try JSONEncoder().encode(selection)
            UserDefaults.standard.set(data, forKey: Self.selectionKey)
        } catch {
            errorMessage = "无法保存 App 选择结果：\(error.localizedDescription)"
        }
    }

    private static func loadSelection() -> FamilyActivitySelection {
        guard let data = UserDefaults.standard.data(forKey: selectionKey) else {
            return FamilyActivitySelection()
        }

        return (try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)) ?? FamilyActivitySelection()
    }
}
