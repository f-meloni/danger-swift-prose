import Danger
import DangerSwiftProse

let danger = Danger()

Mdspell.performSpellCheck(files: ["README.md"], ignoredWords: [], language: "en-us")

if #available(OSX 10.12, *) {
    Proselint.performSpellCheck(files: ["README.md"], excludedRules: ["annotations.misc"])
}
