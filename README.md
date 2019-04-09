# DangerSwiftProse

Danger plugin to validate Markdown files
This plugin used the orta's fork of [mdspell](https://github.com/orta/node-markdown-spellcheck)

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
```

- Create a folder called `DangerDependencies` on `Sources` with an empty file inside like [Fake.swift](Sources/DangerDependencies/Fake.swift)
- To run `Danger` use `swift run danger-swift command`
- (Recommended) If you are using SPM to distribute your framework, use [Rocket](https://github.com/f-meloni/Rocket), or similar to comment out all the dev depencencies from your `Package.swift`.
This prevents the dev dependencies to be downloaded and compiled with your framework.

#### Marathon
- Add this to your `Dangerfile.swift`

```swift
import DangerSwiftProse // package: https://github.com/f-meloni/DangerSwiftProse

Coverage.xcodeBuildCoverage(.derivedDataFolder("Build"), 
                            minimumCoverage: 50, 
                            excludedTargets: ["DangerSwiftProseTests.xctest"])
```

- (Recommended) Cache the `~/.danger-swift` folder

### Mdspell

Add to your Dangerfile

```
MdspellCheck.performSpellCheck(ignoredWords: [], language: "en-us")
```
