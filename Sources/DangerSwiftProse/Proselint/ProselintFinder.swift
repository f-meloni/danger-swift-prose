protocol ProselintFinding {
    func findProselint() throws -> String
}

struct ProselintFinder: ProselintFinding {
    let executor: CommandExecuting
    
    init(executor: CommandExecuting = CommandExecutor()) {
        self.executor = executor
    }
    
    func findProselint() throws -> String {
        return try executor.spawn(command: "which proselint")
    }
}
