//  JustTweakMigrator.swift

import ArgumentParser
import Foundation

@main
struct JustTweakMigrator: ParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "",
        subcommands: [
            ConvertDatasource.self
        ]
    )
}
