import SwiftUI

struct PauseView: View {
    @State private var isTimerRunning = false
    @State private var remainingSeconds = 180

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    hero
                    impulseCard
                    actionGrid
                    todayCard
                }
                .padding(20)
            }
            .background(Color.appBackground)
            .navigationTitle("停三分钟")
            .onReceive(timer) { _ in
                guard isTimerRunning, remainingSeconds > 0 else { return }
                remainingSeconds -= 1
                if remainingSeconds == 0 {
                    isTimerRunning = false
                }
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("刷之前，先停三分钟。")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)

            Text("不是戒掉快乐，是在冲动替你做决定之前，把选择权拿回来。")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 12)
    }

    private var impulseCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text(timeText)
                    .font(.system(size: 54, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                Spacer()
                Image(systemName: remainingSeconds == 0 ? "checkmark.circle.fill" : "timer")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(remainingSeconds == 0 ? Color.green : Color.accentColor)
            }

            Text(promptText)
                .font(.headline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                if remainingSeconds == 0 {
                    remainingSeconds = 180
                }
                isTimerRunning.toggle()
            } label: {
                Label(isTimerRunning ? "暂停倒计时" : "开始 3 分钟", systemImage: isTimerRunning ? "pause.fill" : "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var actionGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickAction(title: "喝水", icon: "drop.fill")
            QuickAction(title: "站起来", icon: "figure.stand")
            QuickAction(title: "写下逃避点", icon: "pencil.line")
            QuickAction(title: "看今日首要任务", icon: "target")
        }
    }

    private var todayCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("今天")
                .font(.title3.bold())

            HStack(spacing: 12) {
                MetricTile(value: "7", label: "次停下")
                MetricTile(value: "42m", label: "少刷")
                MetricTile(value: "4", label: "连续天数")
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var timeText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var promptText: String {
        if remainingSeconds == 0 {
            return "现在再决定一次：还要打开那个 App 吗？"
        }

        return "你现在未必是真的想刷，只是在期待下一次更强的刺激。先把这三分钟还给自己。"
    }
}

private struct QuickAction: View {
    let title: String
    let icon: String

    var body: some View {
        Button {
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 92)
        }
        .buttonStyle(.bordered)
        .tint(.primary)
    }
}

private struct MetricTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2.bold())
                .monospacedDigit()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.tileBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    PauseView()
}
