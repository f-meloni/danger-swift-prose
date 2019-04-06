import Cocoa

protocol MdspellInstalling {
    func installMdspell(executor: CommandExecuting) throws
}

struct MdspellInstaller: MdspellInstalling {
    func installMdspell(executor: CommandExecuting) throws {
        try executor.spawn(command: "npm install -g orta/node-markdown-spellcheck")
    }
}
