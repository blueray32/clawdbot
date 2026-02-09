import Foundation

public enum PaddyCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum PaddyCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum PaddyCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum PaddyCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct PaddyCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: PaddyCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: PaddyCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: PaddyCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: PaddyCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct PaddyCameraClipParams: Codable, Sendable, Equatable {
    public var facing: PaddyCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: PaddyCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: PaddyCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: PaddyCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
