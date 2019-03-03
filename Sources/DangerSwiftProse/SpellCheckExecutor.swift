import XCTest

struct SpellCheckExecutor {
    let spellingFile = ".spelling"
    
    enum Errors: Error, LocalizedError {
        case mdspellNotFound
        
        var errorDescription: String? {
            return "mdspell is not installed"
        }
    }
    
    func executeProse(onFiles files: [String],
                      ignoredWords: [String],
                      language: String,
                      mdspellFinder: MdspellFinding = MdSpellFinder(),
                      commandExecutor: CommandExecuting = CommandExecutor()) throws -> [String] {
        guard let mdspellPath = mdspellFinder.findMdspell(commandExecutor: commandExecutor),
            mdspellPath.count > 0 else {
            throw Errors.mdspellNotFound
        }
        
        var arguments: [String] = ["-r"]
        arguments.append("-a") // ignore acronyms
        arguments.append("-n") // ignore numbers
        arguments.append("--\(language)")
        
        try ignoredWords.joined(separator: "\n").write(toFile: spellingFile, atomically: true, encoding: .utf8)
        defer {
            try?  FileManager.default.removeItem(atPath: spellingFile)
        }
        
        let result = try files.map { try commandExecutor.execute(command: mdspellPath + " \($0) " + arguments.joined(separator: " ")) }
        
        return result
    }
}
