@testable import DangerSwiftProse
import TestSpy

final class MockedCommandExecutor: CommandExecuting, TestSpy {
    enum CommandError: Error {
        case error
    }

    enum Method: Equatable {
        case execute(String)
        case spawn(String)
    }

    var callstack = CallstackContainer<Method>()

    var success = true
    let result = "result"

    func execute(command: String) -> String {
        callstack.record(.execute(command))

        if success {
            return result
        } else {
            return ""
        }
    }

    func spawn(command: String) throws -> String {
        callstack.record(.spawn(command))

        if success {
            return result
        } else {
            throw CommandError.error
        }
    }
}
