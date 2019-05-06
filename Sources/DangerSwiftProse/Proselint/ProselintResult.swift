struct ProselintResult: Equatable {
    let filePath: String
    let violations: [ProselintViolation]
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
