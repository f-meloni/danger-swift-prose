import Foundation

protocol MdspellCheckExecuting {
    func executeSpellCheck(onFiles files: [String],
        ignoredWords: [String],
        language: String) throws -> [MdspellCheckResult]
}

struct MdspellCheckExecutor: MdspellCheckExecuting {
    let spellingFile = ".spelling"
    
    enum Errors: Error, LocalizedError {
        case mdspellNotFound
        
        var errorDescription: String? {
            return "mdspell is not installed"
        }
    }
    
    func executeSpellCheck(onFiles files: [String],
                           ignoredWords: [String],
                           language: String) throws -> [MdspellCheckResult] {
        return try executeSpellCheck(onFiles: files,
                          ignoredWords: ignoredWords,
                          language: language,
                          mdspellFinder: MdSpellFinder(),
                          commandExecutor: CommandExecutor())
    }
    
    func executeSpellCheck(onFiles files: [String],
                      ignoredWords: [String],
                      language: String,
                      mdspellFinder: MdspellFinding,
                      commandExecutor: CommandExecuting) throws -> [MdspellCheckResult] {
        guard mdspellFinder.findMdspell(commandExecutor: commandExecutor)?.count ?? 0 > 0 else {
            throw Errors.mdspellNotFound
        }
        
        var arguments: [String] = ["-r"]
        arguments.append("-a") // ignore acronyms
        arguments.append("-n") // ignore numbers
        arguments.append("--\(language)")
        
        try ignoredWords.joined(separator: "\n").write(toFile: spellingFile, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(atPath: spellingFile)
        }
        
        let result = try files.map { file -> MdspellCheckResult in
            let checkContent = try commandExecutor.execute(command: "mdspell \(file) " + arguments.joined(separator: " "))
            return MdspellCheckResult(file: file, checkResult: checkContent)
        }
        
        return result
    }
}
