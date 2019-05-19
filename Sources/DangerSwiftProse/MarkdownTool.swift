enum MarkdownTool {
    case proselint
    case mdspell

    var installationCommand: String {
        switch self {
        case .proselint:
            return "pip install --user proselint"
        case .mdspell:
            return "npm install -g orta/node-markdown-spellcheck"
        }
    }
}
