import SwiftUI

struct SpireConsentPanel: View {
    let pageURL: URL
    let onAccept: () -> Void
    @State private var accepted = false

    var body: some View {
        ZStack {
            AppColor.deepNavy.ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Text("gate.welcome.title")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppColor.textOnNavy)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColor.textOnNavy.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
                .padding(.top, 26)

                TowerFrame(pageURL: pageURL, ephemeral: true)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(AppColor.jackpotYellow.opacity(0.35), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)

                Button(action: { accepted.toggle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: accepted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundStyle(accepted ? AppColor.jackpotYellow : AppColor.textOnNavy.opacity(0.55))
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppColor.textOnNavy)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(AppColor.surfacePanel)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 18)

                Button(action: { onAccept() }) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppColor.deepNavy)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(AppColor.jackpotYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!accepted)
                .opacity(accepted ? 1 : 0.4)
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
