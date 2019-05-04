@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

final class ProselintExecutorTests: XCTestCase {
    private var commandExecutor: MockedCommandExecutor!
    private var finder: StubbedProselintFinder!
    private var executor: ProselintExecutor!

    override func setUp() {
        super.setUp()
        commandExecutor = MockedCommandExecutor()
        finder = StubbedProselintFinder()
        executor = ProselintExecutor(commandExecutor: commandExecutor, proselintFinder: finder)
    }

    override func tearDown() {
        executor = nil
        super.tearDown()
    }

    func testThrowsProselintNotFoundErrorWhenProselintFinderThrowsAnError() {
        expect(try self.executor.executeProse(files: [])).to(throwError(closure: {
            expect($0.localizedDescription) == "Proselint is not installed"
        }))
    }

    func testSends() {
        finder.response = "/bin/proselint"
        commandExecutor.result = proselintJSON

        expect(try self.executor.executeProse(files: ["filePath"])) == [
            ProselintResponse(data:
                ProselintResponseData(errors: [
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
                ])),
        ]
    }

    private var proselintJSON: String {
        return """
        {
            "data": {
                "errors": [{
                    "check": "typography.symbols.curly_quotes",
                    "column": 34,
                    "end": 784,
                    "extent": 2,
                    "line": 29,
                    "message": "Use curly quotes “”, not straight quotes \\"\\". Found once elsewhere.",
                    "replacements": "“ or ”",
                    "severity": "warning",
                    "start": 782
                }, {
                    "check": "typography.symbols.ellipsis",
                    "column": 12,
                    "end": 2276,
                    "extent": 2,
                    "line": 82,
                    "message": "'...' is an approximation, use the ellipsis symbol '…'.",
                    "replacements": null,
                    "severity": "warning",
                    "start": 2274
                }]
            },
            "status": "success"
        }
        """
    }
}

private final class StubbedProselintFinder: ProselintFinding {
    enum TestError: Error {
        case error
    }

    var response: String?

    func findProselint() throws -> String {
        if let response = response {
            return response
        } else {
            throw TestError.error
        }
    }
}
