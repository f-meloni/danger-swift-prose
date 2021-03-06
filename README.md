# DangerSwiftProse

Danger plugin to validate Markdown files

## Getting Started

### Install DangerSwiftCoverage
#### Swift Package Manager (More performant)
You can use a "full SPM" solution to install both `danger-swift` and `DangerSwiftProse`.

- Add to your `Package.swift`:

```swift
let package = Package(
    ...
    products: [
        ...
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
        ...
    ],
    dependencies: [
        ...
        // Danger Plugins
        .package(url: "https://github.com/f-meloni/DangerSwiftProse", from: "0.1.0") // dev
        ...
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["Danger", "DangerSwiftProse"]), // dev
        ...
    ]
)
```

- Add the correct import to your `Dangerfile.swift`:
```swift
import DangerSwiftProse

MdspellCheck.performSpellCheck(ignoredWords: [], language: "en-us")
```

- Create a folder called `DangerDependencies` on `Sources` with an empty file inside like [Fake.swift](Sources/DangerDependencies/Fake.swift)
- To run `Danger` use `swift run danger-swift command`
- (Recommended) If you are using SPM to distribute your framework, use [Rocket](https://github.com/f-meloni/Rocket), or similar to comment out all the dev depencencies from your `Package.swift`.
This prevents the dev dependencies to be downloaded and compiled with your framework.

#### Marathon
- Add this to your `Dangerfile.swift`

```swift
import DangerSwiftProse // package: https://github.com/f-meloni/danger-swift-prose.git

MdspellCheck.performSpellCheck(ignoredWords: [], language: "en-us")
```

- (Recommended) Cache the `~/.danger-swift` folder

### Mdspell

Add to your Dangerfile
This uses the orta's fork of [mdspell](https://github.com/orta/node-markdown-spellcheck)

```
MdspellCheck.performSpellCheck(ignoredWords: [], language: "en-us")
```
### Proselint

Add to your Dangerfile

```
Proselint.performSpellCheck()
```

