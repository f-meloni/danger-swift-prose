struct ProselintInstaller {
    let executor: CommandExecuting

    init(executor: CommandExecuting = CommandExecutor()) {
        self.executor = executor
    }

    func installProselint() {
        executor.execute(command: "pip install --user proselint")
    }
}
