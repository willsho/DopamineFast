import SwiftUI

struct ReviewView: View {
    private let insights = [
        Insight(title: "最容易冲动", value: "23:00 后", icon: "moon.fill"),
        Insight(title: "本周少刷", value: "2h 20m", icon: "clock.fill"),
        Insight(title: "选择权", value: "31 次", icon: "checkmark.seal.fill")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("每一次停下，都是一次重新投票。")
                            .font(.title2.bold())
                        Text("复盘只记录选择，不制造羞耻感。目标是看见模式，然后减少自动驾驶。")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 12)

                    ForEach(insights) { insight in
                        HStack(spacing: 14) {
                            Image(systemName: insight.icon)
                                .font(.title3)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 30)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(insight.title)
                                    .font(.headline)
                                Text(insight.value)
                                    .font(.title3.bold())
                            }

                            Spacer()
                        }
                        .padding(18)
                        .background(Color.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("下一步")
                            .font(.headline)
                        Text("把睡前防冲动时段提前 30 分钟，优先保护入睡前的注意力。")
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(20)
            }
            .background(Color.appBackground)
            .navigationTitle("复盘")
        }
    }
}

private struct Insight: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
}

#Preview {
    ReviewView()
}
