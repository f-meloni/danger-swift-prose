@testable import DangerSwiftProse
import TestSpy

final class SpyToolInstaller: ToolInstalling, TestSpy {
    enum Method: Equatable {
        case install(MarkdownTool)
    }

    var callstack = CallstackContainer<Method>()

    func install(_ tool: MarkdownTool) {
        callstack.record(.install(tool))
    }
}
