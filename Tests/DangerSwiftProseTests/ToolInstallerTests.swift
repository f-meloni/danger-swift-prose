@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

final class ToolInstallerTests: XCTestCase {
    func testSendsCorrectCommandOnProselintInstall() throws {
        let commandExecutor = MockedCommandExecutor()
        let proselint = ToolInstaller(executor: commandExecutor)

        try proselint.install(.proselint)

        expect(commandExecutor).to(haveReceived(.spawn("pip install --user proselint")))
    }

    func testSendsCorrectCommandOnMdspellInstall() throws {
        let commandExecutor = MockedCommandExecutor()
        let proselint = ToolInstaller(executor: commandExecutor)

        try proselint.install(.mdspell)

        expect(commandExecutor).to(haveReceived(.spawn("npm install -g orta/node-markdown-spellcheck")))
    }
}
