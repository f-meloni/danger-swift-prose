import XCTest
import Nimble
import TestSpy
@testable import DangerSwiftProse

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
        executor.success = true
        
        let result = mdSpellFinder.findMdspell(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which mdspell")))
        expect(result) == executor.result
    }
    
    func testReturnsNilIfTheExecutorFails() {
        let executor = MockedCommandExecutor()
        executor.success = false
        
        let result = mdSpellFinder.findMdspell(commandExecutor: executor)
        
        expect(executor).to(haveReceived(.execute("which mdspell")))
        expect(result).to(beNil())
    }
}
