# Core

In this article, we cover all the concepts required to understand how the framework operates.

## Toggle

A ``Toggle`` represents a feature flag. It can be of `Bool`, `Int`, `Double` or `String` type. Strings can be treated as secure and therefore encrypted.


## Datasource

A local ``Datasource`` represents the base toggles configuration.

Here is an example:

```json
{
  "toggles": [
    {
      "variable": "boolean_toggle",
      "bool": true
    },
    {
      "variable": "integer_toggle",
      "int": 42
    },
    {
      "variable": "string_toggle",
      "string": "Hello World"
    },
    ...
}
```

The keys hosting the values are `bool`, `int`, `number` (for decimal values), `string`, `secure` (for encrypted values).

Providing a local datasource is mandatory.


## Providers

Providers are used to provide toggle values and are inspected in priority order.

The framework comes with the following 3 providers:

- ``LocalValueProvider``: provides values from a local datasource.
- ``InMemoryValueProvider``: provides values from a datasource kept in memory. Values are not persisted across restarts.
- ``PersistentValueProvider``: provides values from a datasource stored in the user defaults. Values are persisted across restarts and installations.

You can implement your custom provider conforming to ``ValueProvider`` or ``MutableValueProvider`` that retrieves values from a datasource hosted on your backend or third-party service.


## Manager

``ToggleManager`` is the facade to interface with the toggles.

Here is a usage example:

```swift
let mutableValueProvider = PersistentValueProvider(userDefaults: .standard)
let myCustomValueProvider = try MyCustomValueProvider(url: customDatasourceUrl)
let datasourceUrl = Bundle.main.url(forResource: "DefaultDatasource", withExtension: "json")!

try ToggleManager(mutableValueProvider: mutableValueProvider,
                  valueProviders: [myCustomValueProvider],
                  datasourceUrl: datasourceUrl)
```


## Retrieving values and observing changes

Values can be retrieved in a sync fashion like so: 

```swift
let shouldEnableFeatureX = manager.value(for: "enable_feature_x").boolValue
let welcomeText = manager.value(for: "welcome_text").stringValue
```

or via publishers created on demand and managed by the manager:

```swift
private var cancellables: Set<AnyCancellable> = []

manager.publisher(for: "enable_feature_x")
    .sink { value in
        if case .bool(let boolValue) = value {
            // use `boolValue`
        }
    }
    .store(in: &cancellables)
```

`ToggleManager` looks for the toggle in the elements of `valueProviders` following the order of the array.  If a `MutableValueProvider` is provided to the `ToggleManager` instance, the manager will first search for the toggle in it. 

Using publishers is particularly useful when toggles can change unexpectedly for example via a remote configuration update and it's desirable to immediately reflect the changes in the app.

A handy ``ToggleObservable`` is available which is particularly useful for SwiftUI code.

```swift
// View init
self.stringObservable = ToggleObservable(manager: manager, variable: ToggleVariables.stringToggle)

// SwiftUI
Text(stringObservable.stringValue!)
```


## Secure toggles

You might need to encrypt the toggle values if they contain API keys, tokens, or any sensitive information.
Secure toggles have the value for the `secure` key set to an encrypted value.

```json
{
  "variable": "encrypted_toggle",
  "secure": "eDUxAQXW6dobqAMxhZIJLkyQKb8+36bFHc36eabacXDahMipVnGy/Q=="
}
```

If the datasource contains secure toggles, a cipher configuration must be provided to the ``ToggleManager``.

```swift
let cipherConfiguration = CipherConfiguration(algorithm: .chaCha20Poly1305,
                                              key: "AyUcYw-qWebYF-z0nWZ4")
try ToggleManager(valueProviders: [],
                  datasourceUrl: datasourceUrl,
                  cipherConfiguration: cipherConfiguration)
```


## Code Generation

The `ToggleGen` tool is available and extremely convenient to generate toggle accessors.
Please refer to the <doc:Tools> article for more information.


## Performance

Toggles has very high performance and it can load and filter huge datasources in a breeze.
It also uses a write-through cache but you don't need to know about that.


## Topics

### Articles

- <doc:Toggles>
- <doc:UI>
- <doc:Tools>

### Models

- ``Toggle``
- ``Datasource``
- ``Metadata``
- ``Variable``
- ``Value``

### Providers

- ``ValueProvider``
- ``MutableValueProvider``
- ``LocalValueProvider``
- ``InMemoryValueProvider``
- ``PersistentValueProvider``

### Facades

- ``ToggleManager``

### Ciphering

- ``CipherConfiguration``

### Observables

- ``ToggleObservable``
