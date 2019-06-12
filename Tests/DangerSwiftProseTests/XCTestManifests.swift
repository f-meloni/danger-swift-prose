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

extension MdspellTests {
    static let __allTests = [
        ("testDoesntSendAMarkdownIfThereAreNoViolations", testDoesntSendAMarkdownIfThereAreNoViolations),
        ("testItSendsAFailIfTheExecutionFails", testItSendsAFailIfTheExecutionFails),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
    ]
}

extension ProselintExecutorTests {
    static let __allTests = [
        ("testDeletesTheConfigurationFileAfterExecution", testDeletesTheConfigurationFileAfterExecution),
        ("testDoesntThrowsAnErrorIfProselintIsNotFoundButThenIsInstalled", testDoesntThrowsAnErrorIfProselintIsNotFoundButThenIsInstalled),
        ("testExcludesFilesWhereProselintCommandIsNotSuccessful", testExcludesFilesWhereProselintCommandIsNotSuccessful),
        ("testGeneratesConfigurationFile", testGeneratesConfigurationFile),
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

extension ProselintTests {
    static let __allTests = [
        ("testDoesntSendAMarkdownIfThereAreNoViolations", testDoesntSendAMarkdownIfThereAreNoViolations),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
        ("testSendsTheErrorsToDanger", testSendsTheErrorsToDanger),
    ]
}

extension ToolInstallerTests {
    static let __allTests = [
        ("testSendsCorrectCommandOnMdspellInstall", testSendsCorrectCommandOnMdspellInstall),
        ("testSendsCorrectCommandOnProselintInstall", testSendsCorrectCommandOnProselintInstall),
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(MdspellCheckExecutorTests.__allTests),
            testCase(MdspellFinderTests.__allTests),
            testCase(MdspellTests.__allTests),
            testCase(ProselintExecutorTests.__allTests),
            testCase(ProselintFinderTests.__allTests),
            testCase(ProselintTests.__allTests),
            testCase(ToolInstallerTests.__allTests),
        ]
    }
#endif
