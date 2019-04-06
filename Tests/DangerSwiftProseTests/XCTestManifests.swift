#if !canImport(ObjectiveC)
import XCTest

extension MdspellCheckExecutorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MdspellCheckExecutorTests = [
        ("testDeletesTheSpellingCheckFile", testDeletesTheSpellingCheckFile),
        ("testItExecutesTheCorrectCommand", testItExecutesTheCorrectCommand),
        ("testReturnsAnErrorIfMdspellIsNotInstalled", testReturnsAnErrorIfMdspellIsNotInstalled),
    ]
}

extension MdspellFinderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MdspellFinderTests = [
        ("testItReturnsTheCorrectPath", testItReturnsTheCorrectPath),
        ("testReturnsNilIfTheExecutorFails", testReturnsNilIfTheExecutorFails),
    ]
}

extension MdspellInstallerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MdspellInstallerTests = [
        ("testItSendsTheCorrectCommandToTheExecutor", testItSendsTheCorrectCommandToTheExecutor),
    ]
}

extension MdspellTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MdspellTests = [
        ("testItSendsAFailIfTheExecutionFails", testItSendsAFailIfTheExecutionFails),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MdspellCheckExecutorTests.__allTests__MdspellCheckExecutorTests),
        testCase(MdspellFinderTests.__allTests__MdspellFinderTests),
        testCase(MdspellInstallerTests.__allTests__MdspellInstallerTests),
        testCase(MdspellTests.__allTests__MdspellTests),
    ]
}
#endif
