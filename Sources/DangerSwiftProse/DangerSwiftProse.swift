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
        let spellCheckFiles: [String]
        
        if let files = files {
            spellCheckFiles = files
        } else {
            spellCheckFiles = (dsl.git.createdFiles + dsl.git.modifiedFiles).filter { $0.fileType == .markdown }
        }
        
        do {
            let spellCheckResults = try mdspellCheckExecutor.executeSpellCheck(onFiles: spellCheckFiles,
                                                                               ignoredWords: ignoredWords,
                                                                               language: language)
            
            dsl.message(String(describing: spellCheckResults))
            
            let markdown = spellCheckResults.toMarkdown()
            
            if markdown.count > 0 {
                dsl.markdown(markdown)
            }
        } catch {
            dsl.fail(error.localizedDescription)
        }
    }
}
