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
        let result = try executeProse()
        
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file1 -r -a -n --en-us")))
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file2 -r -a -n --en-us")))
        expect(self.commandExecutor).to(haveReceived(.execute("/usr/bin/mdspell file3 -r -a -n --en-us")))
        expect(result) == [
            "result",
            "result",
            "result"
        ]
    }
    
    func testReturnsAnErrorIfMdspellIsNotInstalled() {
        finder.result = nil
        
        expect(try self.executeProse()).to(throwError(closure: { error in
            expect(error.localizedDescription) == "mdspell is not installed"
        }))
    }
    
    func testDeletesTheSpellingCheckFile() throws {
        _ = try executeProse()
        expect(FileManager.default.fileExists(atPath: self.checkExecutor.spellingFile)) == false
    }
    
    private func executeProse() throws -> [String] {
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
