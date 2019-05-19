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

    init(commandExecutor: CommandExecuting = CommandExecutor(),
         proselintFinder: ProselintFinding = ProselintFinder(),
         installer: ToolInstalling = ToolInstaller()) {
        self.commandExecutor = commandExecutor
        self.proselintFinder = proselintFinder
        self.installer = installer
    }

    func executeProse(files: [String]) throws -> [ProselintResult] {
        if (try? proselintFinder.findProselint()) == nil {
            try installer.install(.proselint)

            if (try? proselintFinder.findProselint()) == nil {
                throw Errors.proselintNotFound
            }
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
