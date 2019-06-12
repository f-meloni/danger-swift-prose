import Foundation

protocol ProselintExecuting {
    func executeProse(files: [String]) throws -> [ProselintResult]
}

struct ProselintExecutor: ProselintExecuting {
    enum Errors: Error, LocalizedError {
        case proselintNotFound

        var errorDescription: String? {
            switch self {
            case .proselintNotFound:
                return "Proselint is not installed"
            }
        }
    }

    let commandExecutor: CommandExecuting
    let proselintFinder: ProselintFinding
    let installer: ToolInstalling
    let excludedRulesDirectoryURL: URL
    let fileManager: FileManager

    @available(OSX 10.12, *)
    init(commandExecutor: CommandExecuting = CommandExecutor(),
         proselintFinder: ProselintFinding = ProselintFinder(),
         installer: ToolInstalling = ToolInstaller(),
         excludedRulesDirectoryURL: URL = FileManager.default.homeDirectoryForCurrentUser,
         fileManager: FileManager = .default) {
        self.commandExecutor = commandExecutor
        self.proselintFinder = proselintFinder
        self.installer = installer
        self.excludedRulesDirectoryURL = excludedRulesDirectoryURL
        self.fileManager = fileManager
    }

    func executeProse(files: [String]) throws -> [ProselintResult] {
        return try executeProse(files: files, excludedRules: ["annotations.misc", "typography.symbols"])
    }

    func executeProse(files: [String], excludedRules: [String]) throws -> [ProselintResult] {
        if (try? proselintFinder.findProselint()) == nil {
            try installer.install(.proselint)

            if (try? proselintFinder.findProselint()) == nil {
                throw Errors.proselintNotFound
            }
        }

        let exludedRulesURL = excludedRulesDirectoryURL.appendingPathComponent(".proselintrc")
        try JSONEncoder().encode(ExcludedChecks(excludedChecks: excludedRules)).write(to: exludedRulesURL)

        defer {
            try? fileManager.removeItem(at: exludedRulesURL)
        }

        return files.compactMap { file -> ProselintResult? in
            let result = commandExecutor.execute(command: "proselint -j \(file)")

            guard let data = result.data(using: .utf8),
                !data.isEmpty,
                let response = try? JSONDecoder().decode(ProselintResponse.self, from: data) else {
                return nil
            }

            return ProselintResult(filePath: file, violations: response.data.errors)
        }
    }
}

struct ExcludedChecks: Codable {
    struct Checks: Codable {
        let checkValues: [String: Bool]

        init(checkNames: [String]) {
            checkValues = checkNames.reduce(into: [:]) { $0[$1] = false }
        }

        init(from decoder: Decoder) throws {
            checkValues = try decoder.singleValueContainer().decode([String: Bool].self)
        }

        func encode(to encoder: Encoder) throws {
            try checkValues.encode(to: encoder)
        }
    }

    let checks: Checks

    init(excludedChecks: [String]) {
        checks = Checks(checkNames: excludedChecks)
    }
}
