# Test Coverage Analysis: NewPass

## Summary

The project has solid unit test coverage for its two core logic files (`PasswordBuilder` and `PasswordGeneratorViewModel`) with 23 tests total. However, roughly 75% of source files have no corresponding tests, and there are meaningful gaps even within the tested files — including one latent **bug** discoverable through testing.

---

## Current Coverage

| File | Lines | Status | Notes |
|------|-------|--------|-------|
| `PasswordBuilder.swift` | 98 | ✅ Tested | 11 tests |
| `PasswordGeneratorViewModel.swift` | 85 | ✅ Tested | 12 tests |
| `PasswordAttribute.swift` | 22 | ⚠️ Indirect | Only exercised through builder tests |
| `Constants.swift` | 30 | ❌ Untested | Values used in tests but never validated |
| `NPAlertViewController.swift` | 113 | ❌ Untested | Contains a latent bug (see below) |
| `PasswordGeneratorViewController.swift` | 187 | ❌ Untested | No unit or UI tests |
| `UIFont+Extensions.swift` | 35 | ❌ Untested | |
| `UIView+Extensions.swift` | 24 | ❌ Untested | |
| `HapticEngine.swift` | 22 | ❌ Untested | |
| `NPButton.swift` | 39 | ❌ Untested | |
| `NPBodyLabel.swift` | 36 | ❌ Untested | |
| `NPTitleLabel.swift` | 36 | ❌ Untested | |
| `NPAttributeSwitch.swift` | 23 | ❌ Untested | |
| `NPContainerView.swift` | 28 | ❌ Untested | |

---

## Proposed Improvements (by priority)

### 1. Bug: `NPAlertViewController` drops its `buttonHandler` callback

**Priority: High — this is a functional bug, not just missing coverage.**

In `NPAlertViewController.swift`, the `init` accepts a `buttonHandler` closure but **never stores it**:

```swift
// NPAlertViewController.swift:25–30
init(title: String, message: String, buttonTitle: String, buttonHandler: (() -> Void)?) {
    super.init(nibName: nil, bundle: nil)
    self.alertTitle = title
    self.message = message
    self.buttonTitle = buttonTitle
    // ⚠️ buttonHandler is accepted but never assigned to self.buttonHandler
}
```

The `didTouchUp` method then calls `buttonHandler?()`, which will always be `nil`. In `PasswordGeneratorViewController`, this callback is supposed to re-enable the generate button after the alert is dismissed — meaning the button stays permanently disabled after any error.

**Recommended test:**
```swift
func testButtonHandlerIsCalledWhenActionButtonIsTapped() {
    var handlerCalled = false
    let sut = NPAlertViewController(title: "Test", message: "Msg", buttonTitle: "Ok") {
        handlerCalled = true
    }
    // load the view, simulate the button tap action
    sut.loadViewIfNeeded()
    sut.actionButton.sendActions(for: .touchUpInside)
    XCTAssertTrue(handlerCalled)
}
```

---

### 2. Missing: Passwords must not contain characters outside the selected attributes

**Priority: High — this is a security property of the password generator.**

The existing tests verify that requested character types *are present*; none verify that *unrequested* character types are *absent*. A regression in `constructPasswordString` or `randomizeCharacters` could silently introduce unexpected characters.

**Recommended tests:**
```swift
func testPasswordWithOnlyNumbersContainsNoAlphabeticCharacters() {
    let request = PasswordBuildRequest(passwordAttributes: [.numbers],
                                       passwordLength: Constants.defaultPasswordLength)
    let password = sut.build(with: request)
    XCTAssertNil(password.rangeOfCharacter(from: .letters))
}

func testPasswordWithOnlyLowercaseContainsNoUppercaseOrSymbolsOrNumbers() {
    let request = PasswordBuildRequest(passwordAttributes: [.lowercaseLetters],
                                       passwordLength: Constants.defaultPasswordLength)
    let password = sut.build(with: request)
    let forbiddenSet = CharacterSet.uppercaseLetters
        .union(PasswordAttribute.numbers.characterSet)
        .union(PasswordAttribute.symbols.characterSet)
    XCTAssertNil(password.rangeOfCharacter(from: forbiddenSet))
}
```

---

### 3. Missing: `PasswordGenerationError` error descriptions

**Priority: Medium — the `unknown` error path is never exercised.**

`PasswordGenerationError` has two cases (`.noAttributes`, `.unknown`), each with a `description` string shown to the user. Tests only exercise `.noAttributes`. The `.unknown` case and both description strings are never verified.

**Recommended tests:**
```swift
func testNoAttributesErrorHasCorrectDescription() {
    let error = PasswordGenerationError.noAttributes
    XCTAssertEqual(error.description, "You need at least one attribute selected to generate a password.")
}

func testUnknownErrorHasCorrectDescription() {
    let error = PasswordGenerationError.unknown
    XCTAssertEqual(error.description, "Something went wrong. Give it another try.")
}
```

---

### 4. Missing: `PasswordGeneratorViewModel` default state and `styledPassword` before generation

**Priority: Medium — public API surface that goes unverified.**

Several properties of `PasswordGeneratorViewModel` are never directly tested:
- `placeholderPasswordText` content
- `styledPassword` when no password has been generated yet (should return an empty attributed string)
- The default `init()` produces the expected defaults

**Recommended tests:**
```swift
func testPlaceholderPasswordTextValue() {
    let sut = PasswordGeneratorViewModel()
    XCTAssertEqual(sut.placeholderPasswordText, "Tap Below or Shake")
}

func testStyledPasswordIsEmptyBeforeGeneration() {
    let sut = PasswordGeneratorViewModel()
    XCTAssertEqual(sut.styledPassword.length, 0)
}

func testDefaultInitUsesExpectedDefaults() {
    let sut = PasswordGeneratorViewModel()
    XCTAssertEqual(sut.passwordLength, Constants.defaultPasswordLength)
    XCTAssertEqual(sut.passwordAttributes, Constants.defaultPasswordAttributes)
}
```

---

### 5. Missing: `PasswordAttribute.characterSet` direct validation

**Priority: Medium — character sets are fundamental to correct password generation.**

`PasswordAttribute.characterSet` is only exercised indirectly. Direct tests can catch regressions in the raw values or `CharacterSet` construction, and verify that character sets do not overlap (a character cannot belong to two attribute sets simultaneously).

**Recommended tests:**
```swift
func testNumbersCharacterSetContainsOnlyDigits() {
    let set = PasswordAttribute.numbers.characterSet
    XCTAssertNotNil("9".rangeOfCharacter(from: set))
    XCTAssertNil("a".rangeOfCharacter(from: set))
}

func testCharacterSetsDoNotOverlap() {
    let numbersSet = PasswordAttribute.numbers.characterSet
    let symbolsSet = PasswordAttribute.symbols.characterSet
    let lowercaseSet = PasswordAttribute.lowercaseLetters.characterSet
    let uppercaseSet = PasswordAttribute.uppercaseLetters.characterSet

    XCTAssertTrue(numbersSet.isDisjoint(with: symbolsSet))
    XCTAssertTrue(numbersSet.isDisjoint(with: lowercaseSet))
    XCTAssertTrue(numbersSet.isDisjoint(with: uppercaseSet))
    XCTAssertTrue(lowercaseSet.isDisjoint(with: uppercaseSet))
}
```

---

### 6. Missing: `Constants` boundary invariants

**Priority: Medium — tests today silently depend on these relationships being true.**

All tests use `Constants.minPasswordLength`, `Constants.defaultPasswordLength`, and `Constants.maxPasswordLength` as assumed-correct values. If these constants were changed in a way that broke their ordering, tests would give confusing results without a clear failure pointing at the constants themselves.

**Recommended tests:**
```swift
func testPasswordLengthConstantsAreOrdered() {
    XCTAssertLessThan(Constants.minPasswordLength, Constants.defaultPasswordLength)
    XCTAssertLessThan(Constants.defaultPasswordLength, Constants.maxPasswordLength)
}

func testDefaultPasswordAttributesAreNonEmpty() {
    XCTAssertFalse(Constants.defaultPasswordAttributes.isEmpty)
}
```

---

### 7. Missing: `UIFont` extension trait composition

**Priority: Low — utility code with no tests.**

`UIFont+Extensions.swift` provides `.bold`, `.italic`, `.boldItalic`, and `.with(_:)`. These are pure functions on `UIFont` and straightforward to test.

**Recommended tests:**
```swift
func testBoldFontContainsBoldTrait() {
    let font = UIFont.systemFont(ofSize: 14)
    XCTAssertTrue(font.bold.fontDescriptor.symbolicTraits.contains(.traitBold))
}

func testItalicFontContainsItalicTrait() {
    let font = UIFont.systemFont(ofSize: 14)
    XCTAssertTrue(font.italic.fontDescriptor.symbolicTraits.contains(.traitItalic))
}

func testBoldItalicFontContainsBothTraits() {
    let font = UIFont.systemFont(ofSize: 14)
    let traits = font.boldItalic.fontDescriptor.symbolicTraits
    XCTAssertTrue(traits.contains(.traitBold))
    XCTAssertTrue(traits.contains(.traitItalic))
}
```

---

### 8. Missing: `UIView` extension behaviour

**Priority: Low — utility code with no tests.**

`UIView+Extensions.swift` provides `addSubviews(_:)` and `roundify(cornerRadius:)`. Both are easily unit-testable.

**Recommended tests:**
```swift
func testAddSubviewsAddsAllProvidedViews() {
    let parent = UIView()
    let child1 = UIView(), child2 = UIView(), child3 = UIView()
    parent.addSubviews(child1, child2, child3)
    XCTAssertEqual(parent.subviews.count, 3)
    XCTAssertTrue(parent.subviews.contains(child1))
}

func testRoundifySetsCornerRadiusAndClipsToBounds() {
    let view = UIView()
    view.roundify(cornerRadius: 8)
    XCTAssertEqual(view.layer.cornerRadius, 8)
    XCTAssertTrue(view.clipsToBounds)
}
```

---

### 9. Missing: UI / integration tests for `PasswordGeneratorViewController`

**Priority: Low — high effort but would protect key user flows.**

The main view controller has no tests at all. The most impactful user flows to cover with `XCUITest` (or by loading the VC programmatically in unit tests) would be:

- Tapping "Generate Password" produces a non-placeholder password in the label
- Disabling all attribute switches and tapping generate shows the error alert
- Moving the length slider updates the password length label text
- Shaking the device (simulated via `motionEnded`) triggers password generation
- Long-pressing the password label presents the share sheet

---

## Suggested Implementation Order

1. **Fix the `NPAlertViewController` bug** (missing `self.buttonHandler = buttonHandler`) and add the regression test
2. Add negative-attribute tests to `PasswordBuilderUnitTests` (passwords contain only requested chars)
3. Add `PasswordGenerationError` description tests to `PasswordViewModelUnitTests`
4. Add `PasswordAttribute` character-set disjointness tests in a new `PasswordAttributeUnitTests` file
5. Add `Constants` invariant tests in a new `ConstantsUnitTests` file
6. Add `UIFont` and `UIView` extension tests in a new `ExtensionsUnitTests` file
7. Add `PasswordGeneratorViewModel` default-state tests
8. Add UI tests for core user flows in a new `NewPassUITests` target
