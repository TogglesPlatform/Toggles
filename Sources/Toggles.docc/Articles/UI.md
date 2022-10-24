# UI

Toggles provides a view to list and modify toggles.

## TogglesView

``TogglesView`` is made available and intended to be used in debug builds. It provides information on the loaded toggles and permits override operations.

Here is a screenshot showing the view in the provided demo app. 

![Toggles view in Demo app](DemoApp_iPad)

The demo app showcases all the functionalities of the framework. The ``TogglesView`` shows the list of all toggles present in the datasource also allowing filtering.

For each toggle, it shows:

- basic information
- the value returned by the getter
- the value received by the publisher
- the value each provider has

It's possible to override the value and subsequently clear all overrides.

In order to show its content, ``TogglesView`` requires that toggles in the datasource have 2 metadata properties: `group` and `description`.

```json
{
  "toggles": [
    {
      "variable": "enable_feature",
      "bool": true,
      "metadata": {
        "group": "Feature toggles",
        "description": "Enable feature"
      }
    },
    {
      "variable": "retry_count",
      "int": 42,
      "metadata": {
        "group": "Feature toggles",
        "description": "Number of retries"
      }
    },
    {
      "variable": "pi_value",
      "number": 3.1416,
      "metadata": {
        "group": "Feature toggles",
        "description": "Pi value"
      }
    },
    ...
}
```

If you want to be able to override values via the `TogglesView`, you have to provide a `MutableValueProvider` to the `ToggleManager` instance.

## Topics

### UI

- ``TogglesView``
