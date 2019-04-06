import XCTest
@testable import DangerSwiftProse
import Nimble
import TestSpy

final class MdspellInstallerTests: XCTestCase {
    func testItSendsTheCorrectCommandToTheExecutor() throws {
        let executor = MockedCommandExecutor()
        try MdspellInstaller().installMdspell(executor: executor)
        
        expect(executor).to(haveReceived(.spawn("npm install -g orta/node-markdown-spellcheck")))
    }
}
