import Danger
import DangerSwiftProse

let danger = Danger()

Mdspell.performSpellCheck(files: ["README.md"], ignoredWords: [], language: "en-us")
Proselint.performSpellCheck(files: ["README.md"])
