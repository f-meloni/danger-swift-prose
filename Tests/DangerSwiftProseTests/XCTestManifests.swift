import XCTest

extension MdspellFinderTests {
    static let __allTests = [
        ("testItReturnsTheCorrectPath", testItReturnsTheCorrectPath),
        ("testReturnsNilIfTheExecutorFails", testReturnsNilIfTheExecutorFails),
    ]
}

extension MdspellTests {
    static let __allTests = [
        ("testItSendsAFailIfTheExecutionFails", testItSendsAFailIfTheExecutionFails),
        ("testSendsTheCorrectReportToDanger", testSendsTheCorrectReportToDanger),
    ]
}

extension SpellCheckExecutorTests {
    static let __allTests = [
        ("testDeletesTheSpellingCheckFile", testDeletesTheSpellingCheckFile),
        ("testItExecutesTheCorrectCommand", testItExecutesTheCorrectCommand),
        ("testReturnsAnErrorIfMdspellIsNotInstalled", testReturnsAnErrorIfMdspellIsNotInstalled),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MdspellFinderTests.__allTests),
        testCase(MdspellTests.__allTests),
        testCase(SpellCheckExecutorTests.__allTests),
    ]
}
#endif
