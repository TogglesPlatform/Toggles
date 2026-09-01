<!-- FOR AI AGENTS - Human readability is a side effect, not a goal -->
<!-- Last updated: 2026-07-31T10:19:20Z | Last verified: 2026-07-31T10:19:20Z -->

# AGENTS.md

Toggles is a Swift Package (`swift-tools-version: 6.0`) implementing feature flagging for Apple platforms (iOS 15+, macOS 12+, watchOS 7+, tvOS 15+). `TogglesDemo/` is a separate Xcode app project that consumes the package to showcase it.

## Commands
> Verified 2026-07-31 by running each command directly.

| Task | Command | Notes |
|------|---------|-------|
| Build package | `swift build` | ~15s clean |
| Test package | `swift test` | 191 tests, ~6s |
| Test single suite | `swift test --filter <TestClassName>` | e.g. `swift test --filter Value_UtilitiesTests` |
| Build demo app | `cd TogglesDemo && xcodebuild build -scheme TogglesDemo -destination "platform=iOS Simulator,OS=18.4,name=iPhone 16 Pro"` | mirrors `.github/workflows/build-TogglesDemo.yml`; requires Xcode 16.4 per CI |
| Generate DocC docs | `swift package --allow-writing-to-directory docs generate-documentation --target Toggles --disable-indexing --transform-for-static-hosting --hosting-base-path Toggles --output-path docs` | see `DocC.md`; output is pushed to the `DocC` branch, not committed on `main` |

No linter/formatter config (no SwiftLint/SwiftFormat) is present in this repo — don't invent lint commands.

## Repository Layout
```
Sources/            # library code (target "Toggles")
  Ciphers/           # ChaCha20Poly1305 for encrypting secure values
  Extensions/        # type extensions (Toggle, Group, Value, String, Dictionary, Object)
  Models/            # Datasource, Group, Toggle, Value, Variable, Metadata, ObjectSupportedType
  ObservableObjects/ # ToggleObservable (SwiftUI observation glue)
  Protocols/         # ValueProvider, MutableValueProvider, Ciphering, Logger, Publishing, Reacting
  Providers/         # DefaultValueProvider, LocalValueProvider, InMemoryValueProvider, PersistentValueProvider
  ToggleManager/     # ToggleManager + its extensions (Caching, Ciphering, Logging, Overrides, Publishing, Reacting, Trace)
  Utilities/         # GroupLoader, ValueCache, TogglesValidator, SearchFilter, InputValidationHelper, CipherConfiguration
  Views/             # SwiftUI debug UI (TogglesView, ToggleDetailView) — a component-per-file style, see Views/TogglesView and Views/ToggleDetailView
  Toggles.docc/      # DocC catalog (articles + reference images)
Tests/               # target "TogglesTests", mirrors Sources/ under Suites/<Area>/
TogglesDemo/         # standalone Xcode app project demonstrating the package (own xcodeproj, not part of Package.swift)
```

## Testing Conventions
- Test files live under `Tests/Suites/<Area>/` mirroring the `Sources/<Area>/` layout (e.g. `Sources/Providers/LocalValueProvider.swift` → `Tests/Suites/Providers/LocalValueProviderTests.swift`).
- Uses both XCTest (`Test Suite ... passed`) and swift-testing — `swift test` runs both.
- Test resources (sample JSON datasources, etc.) live in `Tests/Resources/`.

## CI
- `.github/workflows/run-tests.yml` calls a reusable workflow (`TogglesPlatform/Pipelines/.github/workflows/run-tests.yml@v1`) with Xcode 16.4.0 on `macos-15` — this is the source of truth for the test command CI actually runs, not a local script in this repo.
- `.github/workflows/build-TogglesDemo.yml` builds the demo app on every push/PR to `main`.
- `.github/workflows/publish-release.yml` creates a GitHub release on tag push via `TogglesPlatform/Pipelines/actions/create-release@v1`.

## Boundaries

### Always Do
- Run `swift test` before committing changes to `Sources/`.
- Add/update tests under the mirrored `Tests/Suites/<Area>/` path for any `Sources/` change.
- Keep `Package.swift` platform minimums (iOS 15 / macOS 12 / watchOS 7 / tvOS 15) in mind — don't use APIs unavailable on those OS versions without availability checks.
- Show command output as evidence before claiming a build/test passes.

### Ask First
- Adding a new Swift Package dependency (currently only `swift-docc-plugin`, and only as a doc-generation tool, not a runtime dependency).
- Raising the minimum platform versions in `Package.swift`.
- Changes to `.github/workflows/*.yml` or the `TogglesPlatform/Pipelines` reusable workflows.
- Regenerating and force-pushing the `DocC` branch.

### Never Do
- Commit secrets or cipher keys (`Sources/Ciphers/ChaCha20Poly1305.swift` handles encryption of secure values — do not hardcode keys anywhere).
- Push directly to `main` — open a PR.
- Modify `TogglesDemo/TogglesDemo/GeneratedCode` by hand — it's generated (likely by ToggleGen; verify before assuming).

## When instructions conflict
The nearest `AGENTS.md` wins. Explicit user prompts override this file.
