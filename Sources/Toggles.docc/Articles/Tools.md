# Tools

Toggles comes with some secondary tools in the form of packages.

## Overview

Should you need it, all the tools mentioned in this article can be exported as executables with the following command run from the respective tool's folder:

```sh
swift build -c release --arch arm64 --arch x86_64
```

`arm64` is for Apple Silicon (M1 ship) while `x86_64` is for Intel.


## ToggleGen

Toggle values are accessed via the ``ToggleManager`` but it can get repetitive and error-prove to manually implement the getters and setters for all of your toggles. `ToggleGen` allows you to automatically create the accessors for a given datasource, making sure that the types are respected and that values will always be found.

![ToggleGen](ToggleGen_arguments)

The generated code consists of 2 files:

- __accessor__: containing the accessors for every toggle present in the datasource
- __variables__: containing the variables in the form of an enum

A reasonable naming for said files is `ToggleAccessor.swift` and `ToggleVariables.swift`.

A `ToggleManager` instance must be provided to the accessor at initialization time.

Having the variables in a separate file is useful for sharing them with other targets that don't necessarily need to import Toggles. For example, in the case of UI tests, where the process could marshal the variables to the app process via `ProcessInfo`).

It is recommended to export an executable and run it as a build phase so that code for toggles added to the datasource will be generated at build time. The files will not be regenerated if the content hasn't changed, without the risk of impacting existing workflows. 

Here is an example of invocation:

```sh
executables/ToggleGen \
--datasource-path Resources/Toggles/Datasource.json \
--accessor-class-name ToggleAccessor \
--constants-enum-name ToggleVariables \
--accessor-template-path ../Toggles/ToggleGen/Templates/Accessor.stencil \
--constants-template-path ../Toggles/ToggleGen/Templates/Variables.stencil \
--output-path <OUTPUT_PATH>
```

It's important to provide the same local datasource provided to the ``ToggleManager``. In the datasource, toggles can have a `propertyName` to dictate the name of the generated property that will otherwise be inferred based on the variable.

```json
{
  "toggles": [
    {
      "variable": "enable_feature_x",
      "bool": true
    }
    {
      "variable": "welcome_text",
      "string": "Greetings!",
      "propertyName": "customWelcomeText"
    }
  ]
}
```

You can then allocate the `ToggleAccessor` class and inject it around your code (ideally behind protocols) and request values that, thanks to the generated code, will not be optional.

```swift
let accessor = ToggleAccessor(manager: manager)
let shouldEnableFeatureX = accessor.enableFeatureX
let welcomeText = accessor.customWelcomeText
```


## ToggleCipher

Toggles supports secure toggles that are provided in their encrypted form.

```json
{
  "variable": "encrypted_toggle",
  "secure": "Hp1i12+4d2dX/68kCrS/aQL+eqSwgR/nrU7rm+aAypzWEP8aAEIgI/v3lNpKsx96+QFfnVuebZZDJ+EMinblZzxRi6o2Lf6A3cbUfxRpa6B5yf8u/rXUwhCe5NFAR1x3fVPpOhLw7+g="
}
```

`ToggleCipher` allows you to encrypt and decrypt values.

![ToggleCipher encrypt](ToggleCipher_encrypt_arguments)
![ToggleCipher decrypt](ToggleCipher_decrypt_arguments)

[ChaCha20Poly1305](https://developer.apple.com/documentation/cryptokit/chachapoly) is the cipher of choice and the only one supported at the time of writing. It requires a key, so make sure that the same key is provided to ``ToggleManager`` via ``CipherConfiguration``. 


## JustTweakMigrator

[JustTweak](https://github.com/justeat/JustTweak) is an open-source component developed at [Just Eat Takeaway](https://justeattakeaway.com) and it has solidly served the consumer app for years. The whole feature flagging stack relies on it as described in [this blog post](https://albertodebortoli.com/2019/11/26/a-smart-feature-flagging-system-for-ios/).

Toggles' design is inspired by JustTweak's. Toggles brings to the scene a new fresh and much more optimised solution.

`JustTweakMigrator` helps you migrate from `JustTweak` to `Toggles` by converting the datasource.

![JustTweakMigrator](JustTweakMigrator_arguments)


## Topics

### Ciphering

- ``CipherConfiguration``
