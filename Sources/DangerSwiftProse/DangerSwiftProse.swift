import Danger
import Foundation

public enum Mdspell {
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

            if let markdown = spellCheckResults.toMarkdown() {
                dsl.markdown(markdown)
            }
        } catch {
            dsl.fail(error.localizedDescription)
        }
    }
}

public enum Proselint {
    @available(OSX 10.12, *)
    public static func performSpellCheck(files: [String]? = nil, excludedRules: [String] = []) {
        performSpellCheck(files: files, excludedRules: excludedRules, proselintExecutor: ProselintExecutor(), dsl: Danger())
    }

    static func performSpellCheck(files: [String]?,
                                  excludedRules: [String],
                                  proselintExecutor: ProselintExecuting,
                                  dsl: DangerDSL) {
        let spellCheckFiles: [String]

        if let files = files {
            spellCheckFiles = files
        } else {
            spellCheckFiles = (dsl.git.createdFiles + dsl.git.modifiedFiles).filter { $0.fileType == .markdown }
        }

        do {
            let proselintResults = try proselintExecutor.executeProse(files: spellCheckFiles, excludedRules: excludedRules)

            if let markdown = proselintResults.toMarkdown() {
                dsl.markdown(markdown)
            }
        } catch {
            dsl.fail(error.localizedDescription)
        }
    }
}
