protocol ToolInstalling {
    func install(_ tool: MarkdownTool) throws
}

struct ToolInstaller: ToolInstalling {
    let executor: CommandExecuting

    init(executor: CommandExecuting = CommandExecutor()) {
        self.executor = executor
    }

    func install(_ tool: MarkdownTool) throws {
        try executor.spawn(command: tool.installationCommand)
    }
}
