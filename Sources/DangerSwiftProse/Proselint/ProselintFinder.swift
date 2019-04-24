struct ProselintFinder {
    func findProselint(executor: CommandExecuting = CommandExecutor()) throws -> String {
        return try executor.spawn(command: "which proselint")
    }
}
