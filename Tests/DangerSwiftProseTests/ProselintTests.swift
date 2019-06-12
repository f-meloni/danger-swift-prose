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
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], excludedRules: [], proselintExecutor: MockedProselintExecutor(), dsl: dsl)

        expect(dsl.markdowns.map { $0.message }) == [
            """
            ### Proselint report on filePath
            | Line | Message | Severity |
            | --- | ----- | ----- |
            | 29 | Use curly quotes “”, not straight quotes "". Found once elsewhere. | warning |
            | 82 | '...' is an approximation, use the ellipsis symbol '…'. | warning |

            ### Proselint report on filePath2
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
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], excludedRules: [], proselintExecutor: executor, dsl: dsl)

        expect(dsl.fails).to(beEmpty())
        expect(dsl.markdowns).to(beEmpty())
    }

    func testSendsTheErrorsToDanger() {
        let dsl = githubFixtureDSL
        let executor = MockedProselintExecutor()
        executor.success = false
        Proselint.performSpellCheck(files: ["filePath", "filePath2"], excludedRules: [], proselintExecutor: executor, dsl: dsl)

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
            ProselintViolation(line: 29,
                               message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                               severity: .warning),
            ProselintViolation(line: 82,
                               message: "'...' is an approximation, use the ellipsis symbol '…'.",
                               severity: .warning),
        ]),
        ProselintResult(filePath: "filePath2", violations: [
            ProselintViolation(line: 29,
                               message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                               severity: .warning),
            ProselintViolation(line: 82,
                               message: "'...' is an approximation, use the ellipsis symbol '…'.",
                               severity: .warning),
        ]),
    ]

    var success = true

    func executeProse(files _: [String], excludedRules: [String]) throws -> [ProselintResult] {
        if success {
            return response
        } else {
            throw TestError.error
        }
    }
}
