protocol ProselintInstalling {
    func installProselint() throws
}

struct ProselintInstaller: ProselintInstalling {
    let executor: CommandExecuting

    init(executor: CommandExecuting = CommandExecutor()) {
        self.executor = executor
    }

    func installProselint() throws {
        try executor.spawn(command: "pip install --user proselint")
    }
}
