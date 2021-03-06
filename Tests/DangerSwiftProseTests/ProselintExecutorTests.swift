@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

@available(OSX 10.12, *)
final class ProselintExecutorTests: XCTestCase {
    private var commandExecutor: MockedCommandExecutor!
    private var finder: StubbedProselintFinder!
    private var installer: SpyToolInstaller!
    private var executor: ProselintExecutor!
    private var fileManager: StubbedFileManager!

    override func setUp() {
        super.setUp()
        commandExecutor = MockedCommandExecutor()
        finder = StubbedProselintFinder()
        installer = SpyToolInstaller()
        fileManager = StubbedFileManager()
        executor = ProselintExecutor(commandExecutor: commandExecutor,
                                     proselintFinder: finder,
                                     installer: installer,
                                     excludedRulesDirectoryURL: FileManager.default.temporaryDirectory,
                                     fileManager: fileManager)
    }

    override func tearDown() {
        commandExecutor = nil
        installer = nil
        finder = nil
        executor = nil
        fileManager = nil
        super.tearDown()
    }

    func testSendsCorrectCommandsToCommandExecutor() throws {
        finder.response = "/bin/proselint"
        commandExecutor.resultBlock = nil

        _ = try executor.executeProse(files: ["file1", "file2"], excludedRules: [])

        expect(self.commandExecutor).to(haveReceived(.execute("proselint -j file1"), .before(.execute("proselint -j file2"))))
    }

    func testThrowsProselintNotFoundErrorWhenProselintFinderThrowsAnError() {
        expect(try self.executor.executeProse(files: [], excludedRules: [])).to(throwError(closure: {
            expect($0.localizedDescription) == "Proselint is not installed"
        }))
    }

    func testDoesntThrowsAnErrorIfProselintIsNotFoundButThenIsInstalled() throws {
        var proselintInstalled = false

        finder.responseBlock = {
            if proselintInstalled == false {
                proselintInstalled = true
                throw StubbedProselintFinder.TestError.error
            } else {
                return "/bin/proselint"
            }
        }

        commandExecutor.resultBlock = { _ in
            self.proselintJSON
        }

        let result = try executor.executeProse(files: ["filePath"], excludedRules: [])

        expect(self.installer).to(haveReceived(.install(.proselint)))
        expect(result) == [
            ProselintResult(filePath: "filePath", violations: [
                ProselintViolation(line: 29,
                                   message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                                   severity: .warning),
                ProselintViolation(line: 82,
                                   message: "'...' is an approximation, use the ellipsis symbol '…'.",
                                   severity: .warning),
            ]),
        ]
    }

    func testReturnsCorrectResultsWhenProselintCommandIsSuccessful() {
        finder.response = "/bin/proselint"
        commandExecutor.resultBlock = { _ in
            self.proselintJSON
        }

        expect(try self.executor.executeProse(files: ["filePath"], excludedRules: [])) == [
            ProselintResult(filePath: "filePath", violations: [
                ProselintViolation(line: 29,
                                   message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                                   severity: .warning),
                ProselintViolation(line: 82,
                                   message: "'...' is an approximation, use the ellipsis symbol '…'.",
                                   severity: .warning),
            ]),
        ]
    }

    func testExcludesFilesWhereProselintCommandIsNotSuccessful() {
        finder.response = "/bin/proselint"
        commandExecutor.resultBlock = { command in
            if command.hasSuffix("file1") {
                return self.proselintJSON
            } else {
                throw MockedCommandExecutor.CommandError.error
            }
        }

        expect(try self.executor.executeProse(files: ["file1", "file2"], excludedRules: [])) == [
            ProselintResult(filePath: "file1", violations: [
                ProselintViolation(line: 29,
                                   message: "Use curly quotes “”, not straight quotes \"\". Found once elsewhere.",
                                   severity: .warning),
                ProselintViolation(line: 82,
                                   message: "'...' is an approximation, use the ellipsis symbol '…'.",
                                   severity: .warning),
            ]),
        ]
    }

    func testGeneratesConfigurationFile() throws {
        finder.response = "/bin/proselint"
        commandExecutor.resultBlock = { command in
            if command.hasSuffix("file1") {
                return self.proselintJSON
            } else {
                throw MockedCommandExecutor.CommandError.error
            }
        }
        fileManager.removeFile = false

        let confURL = executor.excludedRulesDirectoryURL.appendingPathComponent(".proselintrc")
        _ = try executor.executeProse(files: ["file1"], excludedRules: ["annotations.misc", "typography.symbols"])
        let checks = try! JSONDecoder().decode(ExcludedChecks.self, from: Data(contentsOf: confURL))
        try? FileManager.default.removeItem(at: confURL)

        XCTAssertEqual(checks.checks.checkValues.keys.sorted { $0 < $1 }, ["annotations.misc", "typography.symbols"])
        XCTAssertTrue(checks.checks.checkValues.values.allSatisfy { !$0 })
    }

    func testDeletesTheConfigurationFileAfterExecution() throws {
        finder.response = "/bin/proselint"
        commandExecutor.resultBlock = { command in
            if command.hasSuffix("file1") {
                return self.proselintJSON
            } else {
                throw MockedCommandExecutor.CommandError.error
            }
        }

        _ = try executor.executeProse(files: ["file1", "file2"], excludedRules: ["annotations.misc", "typography.symbols"])

        XCTAssertFalse(
            FileManager.default
                .fileExists(atPath: executor.excludedRulesDirectoryURL.appendingPathComponent(".proselintrc").path)
        )
    }

    private var proselintJSON: String {
        """
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

private final class StubbedFileManager: FileManager {
    var removeFile = true

    override func removeItem(at URL: URL) throws {
        if removeFile {
            try super.removeItem(at: URL)
        }
    }
}

private final class StubbedProselintFinder: ProselintFinding {
    enum TestError: Error {
        case error
    }

    var response: String?
    lazy var responseBlock: () throws -> String = {
        if let response = self.response {
            return response
        } else {
            throw TestError.error
        }
    }

    func findProselint() throws -> String {
        try responseBlock()
    }
}
