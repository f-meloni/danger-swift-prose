@testable import DangerSwiftProse
import Nimble
import TestSpy
import XCTest

final class ProselintInstallerTests: XCTestCase {
    func testSendsCorrectCommandOnInstall() {
        let commandExecutor = MockedCommandExecutor()
        let proselint = ProselintInstaller(executor: commandExecutor)

        proselint.installProselint()

        expect(commandExecutor).to(haveReceived(.execute("pip install --user proselint")))
    }
}
