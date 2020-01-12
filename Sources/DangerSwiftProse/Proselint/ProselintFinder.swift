protocol ProselintFinding {
    func findProselint() throws -> String
}

struct ProselintFinder: ProselintFinding {
    let executor: CommandExecuting

    init(executor: CommandExecuting = CommandExecutor()) {
        self.executor = executor
    }

    func findProselint() throws -> String {
        try executor.spawn(command: "which proselint")
    }
}
