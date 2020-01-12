protocol MdspellFinding {
    func findMdspell(commandExecutor: CommandExecuting) -> String?
}

struct MdSpellFinder: MdspellFinding {
    func findMdspell(commandExecutor: CommandExecuting) -> String? {
        try? commandExecutor.spawn(command: "which mdspell")
    }
}
