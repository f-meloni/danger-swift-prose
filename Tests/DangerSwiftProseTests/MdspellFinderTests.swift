import XCTest
import Nimble
import TestSpy
@testable import DangerSwiftProse

final class MdspellFinderTests: XCTestCase {
    var mdSpellFinder: MdSpellFinder!
    
    override func setUp() {
        super.setUp()
        
        mdSpellFinder = MdSpellFinder()
    }
    
    override func tearDown() {
        super.tearDown()
        
        mdSpellFinder = nil
    }
    
    func testItReturnsTheCorrectPath() {
        let executor = MockedCommandExecutor()
        executor.success = true
        
        let result = mdSpellFinder.findMdspell(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which mdspell")))
        expect(result) == executor.result
    }
    
    func testReturnsNilIfTheExecutorFails() {
        let executor = MockedCommandExecutor()
        executor.success = false
        
        let result = mdSpellFinder.findMdspell(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which mdspell")))
        expect(result).to(beNil())
    }
}

private final class MockedCommandExecutor: CommandExecuting, TestSpy {
    enum CommandError: Error {
        case error
    }
    
    enum Method: Equatable {
        case execute(String)
    }
    
    var callstack = CallstackContainer<Method>()
    
    var success = true
    let result = "result"
    
    func execute(command: String) throws -> String {
        callstack.record(.execute(command))
        
        if success {
            return result
        } else {
            throw CommandError.error
        }
    }
}
