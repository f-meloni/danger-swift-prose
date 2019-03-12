import Danger
import Foundation

public enum MdspellCheck {
    public static func performSpellCheck(files: [String]? = nil,
                                         ignoredWords: [String],
                                         language: String) {
        performSpellCheck(files: files,
                          ignoredWords: ignoredWords,
                          language: language,
                          mdspellCheckExecutor: MdspellCheckExecutor(),
                          dsl: Danger())
    }
    
    static func performSpellCheck(files: [String]?,
                                  ignoredWords: [String],
                                  language: String,
                                  mdspellCheckExecutor: MdspellCheckExecuting,
                                  dsl: DangerDSL) {
        let spellCheckFiles = files ?? dsl.git.createdFiles + dsl.git.modifiedFiles
        
        do {
            let spellCheckResults = try mdspellCheckExecutor.executeSpellCheck(onFiles: spellCheckFiles,
                                                                               ignoredWords: ignoredWords,
                                                                               language: language)
            
            
            let markdown = spellCheckResults.toMarkdown()
            
            if markdown.count > 0 {
                dsl.markdown(markdown)
            }
        } catch {
            dsl.fail(error.localizedDescription)
        }
    }
}
