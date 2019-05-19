import XCTest

extension MdspellCheckExecutorTests {
    static let __allTests = [
        ("testDeletesTheSpellingCheckFile", testDeletesTheSpellingCheckFile),
        ("testItExecutesTheCorrectCommand", testItExecutesTheCorrectCommand),
        ("testReturnsAnErrorIfMdspellIsNotInstalled", testReturnsAnErrorIfMdspellIsNotInstalled),
    ]
}

extension MdspellFinderTests {
    static let __allTests = [
        ("testItReturnsTheCorrectPath", testItReturnsTheCorrectPath),
        ("testReturnsNilIfTheExecutorFails", testReturnsNilIfTheExecutorFails),
    ]
}

extension MdspellInstallerTests {
    static let __allTests = [
        ("testItSendsTheCorrectCommandToTheExecutor", testItSendsTheCorrectCommandToTheExecutor),
    ]
}

extension MdspellTests {
    static let __allTests = [
        ("testDoesntSendAMarkdownIfThereAreNoViolations", testDoesntSendAMarkdownIfThereAreNoViolations),
        ("testItSendsAFailIfTheExecutionFails", testItSendsAFailIfTheExecutionFails),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
    ]
}

extension ProselintExecutorTests {
    static let __allTests = [
        ("testExcludesFilesWhereProselintCommandIsNotSuccessful", testExcludesFilesWhereProselintCommandIsNotSuccessful),
        ("testReturnsCorrectResultsWhenProselintCommandIsSuccessful", testReturnsCorrectResultsWhenProselintCommandIsSuccessful),
        ("testSendsCorrectCommandsToCommandExecutor", testSendsCorrectCommandsToCommandExecutor),
        ("testThrowsProselintNotFoundErrorWhenProselintFinderThrowsAnError", testThrowsProselintNotFoundErrorWhenProselintFinderThrowsAnError),
    ]
}

extension ProselintFinderTests {
    static let __allTests = [
        ("testItSendsTheCorrectCallToTheExecutor", testItSendsTheCorrectCallToTheExecutor),
        ("testItThrowsErrorWhenTheExecutorThrowsAnError", testItThrowsErrorWhenTheExecutorThrowsAnError),
    ]
}

extension ProselintInstallerTests {
    static let __allTests = [
        ("testSendsCorrectCommandOnInstall", testSendsCorrectCommandOnInstall),
    ]
}

extension ProselintTests {
    static let __allTests = [
        ("testDoesntSendAMarkdownIfThereAreNoViolations", testDoesntSendAMarkdownIfThereAreNoViolations),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
        ("testSendsTheErrorsToDanger", testSendsTheErrorsToDanger),
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(MdspellCheckExecutorTests.__allTests),
            testCase(MdspellFinderTests.__allTests),
            testCase(MdspellInstallerTests.__allTests),
            testCase(MdspellTests.__allTests),
            testCase(ProselintExecutorTests.__allTests),
            testCase(ProselintFinderTests.__allTests),
            testCase(ProselintInstallerTests.__allTests),
            testCase(ProselintTests.__allTests),
        ]
    }
#endif
