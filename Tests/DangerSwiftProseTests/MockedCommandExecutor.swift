@testable import DangerSwiftProse
import TestSpy

final class MockedCommandExecutor: CommandExecuting, TestSpy {
    enum CommandError: Error, Equatable {
        case error
    }

    enum Method: Equatable {
        case execute(String)
        case spawn(String)
    }

    var callstack = CallstackContainer<Method>()

    let defaultResult = "result"

    lazy var resultBlock: ((String) throws -> String)? = { _ in
        self.defaultResult
    }

    func execute(command: String) -> String {
        callstack.record(.execute(command))

        return (try? resultBlock?(command) ?? "") ?? ""
    }

    func spawn(command: String) throws -> String {
        callstack.record(.spawn(command))

        if let resultBlock = resultBlock {
            return try resultBlock(command)
        } else {
            throw CommandError.error
        }
    }
}
