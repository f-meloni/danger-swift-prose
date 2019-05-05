import Foundation

struct ProselintExecutor {
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

    func executeProse(files: [String]) throws -> [ProselintResponse] {
        guard let proselintPath = try? proselintFinder.findProselint() else {
            throw Errors.proselintNotFound
        }

        return files.compactMap { file -> ProselintResponse? in
            let result = try? commandExecutor.spawn(command: "\(proselintPath) -j \(file)")

            guard let data = result?.data(using: .utf8),
                !data.isEmpty else {
                return nil
            }

            return try? JSONDecoder().decode(ProselintResponse.self, from: data)
        }
    }
}
