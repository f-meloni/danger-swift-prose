import XCTest

struct SpellCheckExecutor {
    func executeProse(files: [String], ignoredWords: [String], mdspellFinder: MdspellFinding = MdSpellFinder(), commandExecutor: CommandExecuting = CommandExecutor()) {
        let mdSpellPath = mdspellFinder.findMdspell(commandExecutor: commandExecutor)
        
        
    }
}
