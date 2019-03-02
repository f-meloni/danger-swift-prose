
struct ProseFinder {
    func findProse(commandExecutor: CommandExecuting = CommandExecutor()) -> String? {
        return try? commandExecutor.execute(command: "which proselint")
    }
}
