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

    init(commandExecutor: CommandExecuting = CommandExecutor(),
         proselintFinder: ProselintFinding = ProselintFinder()) {
        self.commandExecutor = commandExecutor
        self.proselintFinder = proselintFinder
    }

    func executeProse(files: [String]) throws -> [ProselintResult] {
        guard (try? proselintFinder.findProselint()) != nil else {
            throw Errors.proselintNotFound
        }

        return files.compactMap { file -> ProselintResult? in
            let result = try? commandExecutor.spawn(command: "proselint -j \(file)")

            guard let data = result?.data(using: .utf8),
                !data.isEmpty,
                let response = try? JSONDecoder().decode(ProselintResponse.self, from: data) else {
                return nil
            }

            return ProselintResult(filePath: file, violations: response.data.errors)
        }
    }
}
