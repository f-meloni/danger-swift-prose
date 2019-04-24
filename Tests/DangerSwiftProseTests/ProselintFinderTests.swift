import XCTest
@testable import DangerSwiftProse
import Nimble
import TestSpy

final class ProselintFinderTests: XCTestCase {
    var executor: MockedCommandExecutor!
    var proselintFinder: ProselintFinder!
    
    override func setUp() {
        super.setUp()
        executor = MockedCommandExecutor()
        proselintFinder = ProselintFinder()
    }
    
    override func tearDown() {
        executor = nil
        proselintFinder = nil
        super.tearDown()
    }
    
    func testItSendsTheCorrectCallToTheExecutor() throws {
        executor.success = true
        let result = try proselintFinder.findProselint(executor: executor)
        
        expect(self.executor).to(haveReceived(.spawn("which proselint")))
        expect(result) == "result"
    }
    
    func testItThrowsErrorWhenTheExecutorThrowsAnError() throws {
        executor.success = false
        
        expect(try self.proselintFinder.findProselint(executor: self.executor)).to(throwError(MockedCommandExecutor.CommandError.error))
    }
}
