protocol MarkdownConvertible {
    func toMarkdown() -> String?
}

extension Array: MarkdownConvertible where Element: MarkdownConvertible {
    func toMarkdown() -> String? {
        let markdownItems = compactMap { $0.toMarkdown() }
        
        if markdownItems.isEmpty {
            return nil
        } else {
            return markdownItems.joined(separator: "\n")
        }
    }
}
