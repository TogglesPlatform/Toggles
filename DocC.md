# DocC

Documentation for Toggles is provided using [DocC](https://developer.apple.com/documentation/docc) and is made available via GitHub Pages at the following address:

[https://albertodebortoli.github.io/Toggles/documentation/toggles/](https://albertodebortoli.github.io/Toggles/documentation/toggles/)

Generation is done using the [Swift-DocC plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin) by running the following command that will regenerate the content of the `docs` folder:

```sh
swift package --allow-writing-to-directory docs \
    generate-documentation --target Toggles \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path Toggles \
    --output-path docs
```

The branch used for GitHub Pages is [DocC](https://github.com/albertodebortoli/Toggles/tree/DocC) that should be kept up-to-date with [master](https://github.com/albertodebortoli/Toggles/tree/master).

Since DocC doesn't allow versioning the documentation, it's ok to:

1. rebase on top of master
2. regenerate the documentation
3. force push the changes
