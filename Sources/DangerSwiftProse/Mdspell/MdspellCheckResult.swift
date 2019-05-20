import Foundation

struct MdspellCheckResult: MarkdownConvertible {
    private let checkResult: String
    let file: String

    init(file: String, checkResult: String) {
        self.file = file
        self.checkResult = checkResult
    }

    func violations() -> [MdspellCheckViolation] {
        return checkResult.split(separator: "\n").compactMap {
            let splittedLine = $0.split(separator: "|")

            guard splittedLine.count == 2 else {
                return nil
            }

            let splittedIndex = splittedLine[0].trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ":")
            let line = splittedIndex[0]
            let typoIndex = Int(splittedIndex[1]) ?? 0

            guard let fileContent = try? String(contentsOfFile: file),
                let typo = fileContent[String.Index(encodedOffset: typoIndex) ..< fileContent.endIndex]
                .lazy
                .split(whereSeparator: {
                    $0 == "\n" || $0 == " "
                })
                .first else {
                return nil
            }

            return MdspellCheckViolation(line: String(line), typo: String(typo))
        }
    }

    func toMarkdown() -> String? {
        let violations = self.violations()
        guard !violations.isEmpty else {
            return nil
        }

        let mdSpellReport = """
        ### Mdspell report on \(file):
        | Line | Typo |
        | ---- | ---- |\n
        """

        return violations.reduce(mdSpellReport) { result, violation in
            result + "| \(violation.line) | \(violation.typo) |\n"
        }
    }
}

extension MdspellCheckResult: Equatable {
    static func == (lhs: MdspellCheckResult, rhs: MdspellCheckResult) -> Bool {
        return lhs.file == rhs.file &&
            lhs.checkResult == rhs.checkResult
    }
}

struct MdspellCheckViolation {
    let line: String
    let typo: String
}
