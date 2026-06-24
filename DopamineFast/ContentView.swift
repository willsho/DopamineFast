import SwiftUI

struct ContentView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @State private var selectedTab: AppTab = .pause

    var body: some View {
        TabView(selection: $selectedTab) {
            PauseView()
                .tabItem {
                    Label("暂停", systemImage: "pause.circle")
                }
                .tag(AppTab.pause)

            PlanView()
                .tabItem {
                    Label("计划", systemImage: "calendar")
                }
                .tag(AppTab.plan)

            ReviewView()
                .tabItem {
                    Label("复盘", systemImage: "chart.bar")
                }
                .tag(AppTab.review)
        }
        .environmentObject(screenTimeManager)
    }
}

private enum AppTab {
    case pause
    case plan
    case review
}

#Preview {
    ContentView()
}
