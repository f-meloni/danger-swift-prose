import Foundation

protocol CommandExecuting {
    func execute(command: String) throws -> String
}

struct CommandExecutor: CommandExecuting {
    public enum CommandError: Error {
        case commandFailed(exitCode: Int32)
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
        
        guard task.terminationStatus == 0 else {
            throw CommandError.commandFailed(exitCode: task.terminationStatus)
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}
