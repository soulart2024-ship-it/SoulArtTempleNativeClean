import SwiftUI

enum MembershipTier {
    case none
    case essential
    case premium
}

private struct MembershipTierKey: EnvironmentKey {
    static let defaultValue: MembershipTier = .none
}

extension EnvironmentValues {
    var membershipTier: MembershipTier {
        get { self[MembershipTierKey.self] }
        set { self[MembershipTierKey.self] = newValue }
    }
}
