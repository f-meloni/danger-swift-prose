import Foundation

protocol CommandExecuting {
    func execute(command: String) throws -> String
}

struct CommandExecutor: CommandExecuting {
    public enum CommandError: Error, LocalizedError {
        case commandFailed(command: String, exitCode: Int32)
        
        public var errorDescription: String? {
            switch self {
            case let .commandFailed(command, code):
                return "\(command) exited with code: \(code)"
            }
        }
    }
    
    func execute(command: String) throws -> String {
        var env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", command]
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}
