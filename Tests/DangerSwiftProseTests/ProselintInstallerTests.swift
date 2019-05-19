@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

final class ProselintInstallerTests: XCTestCase {
    func testSendsCorrectCommandOnInstall() throws {
        let commandExecutor = MockedCommandExecutor()
        let proselint = ProselintInstaller(executor: commandExecutor)

        try proselint.installProselint()

        expect(commandExecutor).to(haveReceived(.spawn("pip install --user proselint")))
    }
}
