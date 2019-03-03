import TestSpy
@testable import DangerSwiftProse

final class MockedCommandExecutor: CommandExecuting, TestSpy {
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
