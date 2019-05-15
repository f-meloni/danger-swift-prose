@testable import Danger
import DangerFixtures
@testable import DangerSwiftProse
import Nimble
import XCTest

final class ProselintTests: XCTestCase {
    override func tearDown() {
        resetDangerResults()
        super.tearDown()
    }

    func testSendsTheCorrectReportToDanger() {
        let dsl = githubFixtureDSL
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], proselintExecutor: MockedProselintExecutor(), dsl: dsl)

        expect(dsl.markdowns.map { $0.message }) == [
            """
            ### filePath
            | Line | Message | Severity |
            | --- | ----- | ----- |
            | 29 | Use curly quotes “”, not straight quotes "". Found once elsewhere. | warning |
            | 82 | '...' is an approximation, use the ellipsis symbol '…'. | warning |

            ### filePath2
            | Line | Message | Severity |
            | --- | ----- | ----- |
            | 29 | Use curly quotes “”, not straight quotes "". Found once elsewhere. | warning |
            | 82 | '...' is an approximation, use the ellipsis symbol '…'. | warning |

            """,
        ]
    }

    func testDoesntSendAMarkdownIfThereAreNoViolations() {
        let dsl = githubFixtureDSL
        let executor = MockedProselintExecutor()
        executor.success = true
        executor.response = [
            ProselintResult(filePath: "filePath", violations: []),
            ProselintResult(filePath: "filePath1", violations: []),
        ]
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], proselintExecutor: executor, dsl: dsl)

        expect(dsl.fails).to(beEmpty())
        expect(dsl.markdowns).to(beEmpty())
    }

    func testSendsTheErrorsToDanger() {
        let dsl = githubFixtureDSL
        let executor = MockedProselintExecutor()
        executor.success = false
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], proselintExecutor: executor, dsl: dsl)

        expect(dsl.fails.map { $0.message }) == [
            "test message",
        ]
    }
}

private final class MockedProselintExecutor: ProselintExecuting {
    enum TestError: LocalizedError {
        case error

        var errorDescription: String? {
            return "test message"
        }
    }

    var response = [
        ProselintResult(filePath: "filePath", violations: [
            ProselintViolation(check: "typography.symbols.curly_quotes",
                               column: 34,
                               end: 784,
                               extent: 2,
                               line: 29,
                               message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                               replacements: "“ or ”",
                               severity: .warning,
                               start: 782),
            ProselintViolation(check: "typography.symbols.ellipsis",
                               column: 12,
                               end: 2276,
                               extent: 2,
                               line: 82,
                               message: "'...' is an approximation, use the ellipsis symbol '…'.",
                               replacements: nil,
                               severity: .warning,
                               start: 2274),
        ]),
        ProselintResult(filePath: "filePath2", violations: [
            ProselintViolation(check: "typography.symbols.curly_quotes",
                               column: 34,
                               end: 784,
                               extent: 2,
                               line: 29,
                               message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                               replacements: "“ or ”",
                               severity: .warning,
                               start: 782),
            ProselintViolation(check: "typography.symbols.ellipsis",
                               column: 12,
                               end: 2276,
                               extent: 2,
                               line: 82,
                               message: "'...' is an approximation, use the ellipsis symbol '…'.",
                               replacements: nil,
                               severity: .warning,
                               start: 2274),
        ]),
    ]

    var success = true

    func executeProse(files _: [String]) throws -> [ProselintResult] {
        if success {
            return response
        } else {
            throw TestError.error
        }
    }
}
