import Danger
import Foundation

protocol CommandExecuting {
    @discardableResult
    func execute(command: String) -> String

    @discardableResult
    func spawn(command: String) throws -> String
}

struct CommandExecutor: CommandExecuting {
    let danger = Danger()

    public enum CommandError: Error, LocalizedError {
        case commandFailed(command: String, exitCode: Int32)

        public var errorDescription: String? {
            switch self {
            case let .commandFailed(command, code):
                return "\(command) exited with code: \(code)"
            }
        }
    }

    @discardableResult
    func execute(command: String) -> String {
        danger.utils.exec(command)
    }

    @discardableResult
    func spawn(command: String) throws -> String {
        try danger.utils.spawn(command)
    }
}
