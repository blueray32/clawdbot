import Foundation

public enum PaddyLocationMode: String, Codable, Sendable, CaseIterable {
    case off
    case whileUsing
    case always
}
