import XCTest
import Nimble
import TestSpy
@testable import DangerSwiftProse

final class ProseFinderTests: XCTestCase {
    var proseFinder: ProseFinder!
    
    override func setUp() {
        super.setUp()
        
        proseFinder = ProseFinder()
    }
    
    func testItReturnsTheCorrectPath() {
        let executor = MockedCommandExecutor()
        executor.success = true
        
        let result = proseFinder.findProse(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which proselint")))
        expect(result) == executor.result
    }
    
    func testReturnsNilIfTheExecutorFails() {
        let executor = MockedCommandExecutor()
        executor.success = false
        
        let result = proseFinder.findProse(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which proselint")))
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
