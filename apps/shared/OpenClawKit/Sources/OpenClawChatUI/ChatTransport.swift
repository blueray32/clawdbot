import Foundation

public enum PaddyChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(PaddyChatEventPayload)
    case agent(PaddyAgentEventPayload)
    case seqGap
}

public protocol PaddyChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> PaddyChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [PaddyChatAttachmentPayload]) async throws -> PaddyChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> PaddyChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<PaddyChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension PaddyChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "PaddyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> PaddyChatSessionsListResponse {
        throw NSError(
            domain: "PaddyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
