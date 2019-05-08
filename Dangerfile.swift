import Danger
import DangerSwiftProse

let danger = Danger()

MdspellCheck.performSpellCheck(files: ["README.md"], ignoredWords: [], language: "en-us")
Proselint.performSpellCheck(files: ["README.md"])
