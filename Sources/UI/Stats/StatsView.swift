import SwiftUI

/// The Stats screen: composes the Today card, the goal-vs-actual donut, and the
/// six-month bar chart into one scroll view. Everything is bound to injected
/// protocols (no concrete engine types — CLAUDE.md §3).
struct StatsView: View {
    let stats: StatsProviding
    let interval: IntervalProviding

    var body: some View {
        ZStack {
            GradientBackground()
            ScrollView {
                VStack(spacing: 20) {
                    TodayStatsCard(stats: stats)

                    DonutProgressRing(interval: interval)
                        .frame(width: 200, height: 200)
                        .frame(maxWidth: .infinity)

                    SixMonthBarChart(stats: stats)
                }
                .padding()
            }
        }
    }
}

#Preview {
    StatsView(stats: StatsProvidingMock(), interval: IntervalProvidingMock())
}
