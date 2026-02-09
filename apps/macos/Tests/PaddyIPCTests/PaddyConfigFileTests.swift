import Foundation
import Testing
@testable import Paddy

@Suite(.serialized)
struct PaddyConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("paddy-config-\(UUID().uuidString)")
            .appendingPathComponent("paddy.json")
            .path

        await TestIsolation.withEnvValues(["OPENCLAW_CONFIG_PATH": override]) {
            #expect(PaddyConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("paddy-config-\(UUID().uuidString)")
            .appendingPathComponent("paddy.json")
            .path

        await TestIsolation.withEnvValues(["OPENCLAW_CONFIG_PATH": override]) {
            PaddyConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(PaddyConfigFile.remoteGatewayPort() == 19999)
            #expect(PaddyConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(PaddyConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(PaddyConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("paddy-config-\(UUID().uuidString)")
            .appendingPathComponent("paddy.json")
            .path

        await TestIsolation.withEnvValues(["OPENCLAW_CONFIG_PATH": override]) {
            PaddyConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            PaddyConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = PaddyConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("paddy-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "OPENCLAW_CONFIG_PATH": nil,
            "OPENCLAW_STATE_DIR": dir,
        ]) {
            #expect(PaddyConfigFile.stateDirURL().path == dir)
            #expect(PaddyConfigFile.url().path == "\(dir)/paddy.json")
        }
    }
}
