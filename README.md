# Auth0.swift as a Swift Package

This is a special fork of [Auth0.swift](https://github.com/auth0/Auth0.swift) that (theoretically) supports Swift Package Manager 🎉😬

I say "theoretically" because so far I've only tested the iOS version in a real project (I was able to log in and get tokens etc, but definitely need to test everything else properly)

## Why?
Because Auth0 is _that_ dependency that is stopping us from moving to the Swift Package Manager

## How?
Have a look at `Auth0toSPM.rb` - it's a script that performs the necessary modifications required to convert [the Auth0.swift source](https://github.com/auth0/Auth0.swift) to a Swift Package.
This is so (theoretically) when there is a new version of Auth0 we don't need to worry about manually making all the changes again

Steps include:

1. Using `#if os(...)` instead of target-to-platform source file management. Use the same rules as in [the original Podspec](https://github.com/auth0/Auth0.swift/blob/master/Auth0.podspec).
2. Add additional `import Foundation` lines where necessary as SPM is happily strict about this
3. Replace the `WEB_AUTH_PLATFORM` preprocessor macro with `#if os` using the same rules as the Podspec
4. Create a specific module for Objective-C files due to SPM not supporting multiple languages in a single module. Don't use `<` and `>` in Objective-C imports anymore. Guess where this Objective-C module needs to be imported and add `import` lines for it in the Swift source files
5. Make similar changes for Tests. We need to stub the `plistValues(bundle:)` function as including the `Auth0.plist` in the bundle won't be supported until Swift 5.3 - however this breaks the real source so.. it's commented out in `Auth0toSPM.rb` for now - you can make the change manually if you want to run the tests.

You can see what was changed by the script by searching for `// Added by Auth0toSPM` in the source files or looking at 9the diff](https://github.com/maxchuquimia/Auth0.swift/blob/master/changes.diff)

Note: generating the package and listing dependencies was done manually. Tests are commented out.

## TODO
- I have a feeling that `watchOS` won't work... maybe because we shouldn't be adding `SimpleKeychain` to it? It does compile... It's 11:30pm now now, I can't remember my thoughts from this morning.
- Get tests to work - most tests pass but then one causes a crash. Currently there are two `.m` test files in the `Auth0.swift` tests that I haven't figured out the best way to copy across.. maybe all tests will be working when that's done. Feel free to make suggestions on how to achieve this. Also tests only run under iOS and you need to update the lowest supported platform from `v9` (in the Podspec) to `.v10` (in the Package.swift) in order to get tests running.

---

> Things are only impossible until they are not

_Jean-Luc Picard_
