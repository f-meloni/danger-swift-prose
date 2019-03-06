import XCTest
@testable import DangerSwiftProse
import Nimble
import TestSpy

final class SpellCheckExecutorTests: XCTestCase {
    private var checkExecutor: SpellCheckExecutor!
    private var finder: MockedMdspellFinder!
    private var commandExecutor: MockedCommandExecutor!
    
    override func setUp() {
        super.setUp()
        checkExecutor = SpellCheckExecutor()
        finder = MockedMdspellFinder()
        commandExecutor = MockedCommandExecutor()
    }
    
    override func tearDown() {
        checkExecutor = nil
        finder = nil
        super.tearDown()
    }
    
    func testItExecutesTheCorrectCommand() throws {
        let result = try executeSpellCheck()
        
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file1 -r -a -n --en-us")))
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file2 -r -a -n --en-us")))
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file3 -r -a -n --en-us")))
        expect(result) == [
            SpellCheckResult(file: "file1", checkResult: "result"),
            SpellCheckResult(file: "file2", checkResult: "result"),
            SpellCheckResult(file: "file3", checkResult: "result")
        ]
    }
    
    func testReturnsAnErrorIfMdspellIsNotInstalled() {
        finder.result = nil
        
        expect(try self.executeSpellCheck()).to(throwError(closure: { error in
            expect(error.localizedDescription) == "mdspell is not installed"
        }))
    }
    
    func testDeletesTheSpellingCheckFile() throws {
        _ = try executeSpellCheck()
        expect(FileManager.default.fileExists(atPath: self.checkExecutor.spellingFile)) == false
    }
    
    private func executeSpellCheck() throws -> [SpellCheckResult] {
        return try checkExecutor.executeSpellCheck(onFiles: [
                "file1",
                "file2",
                "file3"
            ], ignoredWords: [
                "word1",
                "word2",
                "word3"
            ],
            language: "en-us",
            mdspellFinder: finder,
            commandExecutor: commandExecutor
        )
    }
}

private final class MockedMdspellFinder: MdspellFinding {
    var result: String? = "/usr/bin/mdspell"
    
    func findMdspell(commandExecutor: CommandExecuting) -> String? {
        return result
    }
}
