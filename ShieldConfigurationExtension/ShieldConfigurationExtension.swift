import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        configuration()
    }

    private func configuration() -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterial,
            backgroundColor: UIColor(red: 0.96, green: 0.97, blue: 0.96, alpha: 1),
            icon: UIImage(systemName: "pause.circle.fill"),
            title: ShieldConfiguration.Label(
                text: "刷之前，先停三分钟。",
                color: .label
            ),
            subtitle: ShieldConfiguration.Label(
                text: "你现在未必是真的想刷，只是在期待下一次更强的刺激。先把选择权拿回来。",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "离开这里",
                color: .white
            ),
            primaryButtonBackgroundColor: .systemBlue,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "继续停一下",
                color: .systemBlue
            )
        )
    }
}
