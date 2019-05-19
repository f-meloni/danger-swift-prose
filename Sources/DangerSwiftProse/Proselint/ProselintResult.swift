struct ProselintResult: Equatable, MarkdownConvertible {
    let filePath: String
    let violations: [ProselintViolation]

    func toMarkdown() -> String? {
        guard !violations.isEmpty else {
            return nil
        }

        let fileHeader = """
        ### \(filePath)
        | Line | Message | Severity |
        | --- | ----- | ----- |\n
        """

        return violations.reduce(fileHeader) { (result, violation) -> String in
            result + "| \(violation.line) | \(violation.message) | \(violation.severity.rawValue) |\n"
        }
    }
}

struct ProselintViolation: Decodable, Equatable {
    enum Severity: String, Decodable {
        case warning
        case error
    }

    let check: String
    let column: Int
    let end: Int
    let extent: Int
    let line: Int
    let message: String
    let replacements: String?
    let severity: Severity
    let start: Int
}

struct ProselintResponse: Decodable, Equatable {
    let data: ProselintResponseData
}

struct ProselintResponseData: Decodable, Equatable {
    let errors: [ProselintViolation]
}
