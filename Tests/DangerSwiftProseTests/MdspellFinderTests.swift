@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

final class MdspellFinderTests: XCTestCase {
    var mdSpellFinder: MdSpellFinder!

    override func setUp() {
        super.setUp()
        mdSpellFinder = MdSpellFinder()
    }

    override func tearDown() {
        mdSpellFinder = nil
        super.tearDown()
    }

    func testItReturnsTheCorrectPath() {
        let executor = MockedCommandExecutor()

        let result = mdSpellFinder.findMdspell(commandExecutor: executor)

        expect(executor).to(haveReceived(.spawn("which mdspell")))
        expect(result) == executor.defaultResult
    }

    func testReturnsNilIfTheExecutorFails() {
        let executor = MockedCommandExecutor()
        executor.resultBlock = nil

        let result = mdSpellFinder.findMdspell(commandExecutor: executor)

        expect(executor).to(haveReceived(.spawn("which mdspell")))
        expect(result).to(beNil())
    }
}
