//  MetadataSection.swift

import SwiftUI

struct MetadataSection: View {
    let toggle: Toggle
    
    var body: some View {
        Section {
            HStack {
                Label("Variable", systemImage: "tag")
                Spacer()
                Text(toggle.variable)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label("Type", systemImage: toggle.value.sfSymbolId)
                Spacer()
                Text(toggle.value.typeDescription)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label("Group", systemImage: "folder")
                Spacer()
                Text(toggle.metadata.group)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Label("Metadata", systemImage: "info.circle")
        }
    }
}

#Preview("MetadataSection") {
    let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
    let content = try! Data(contentsOf: datasourceUrl)
    let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
    List {
        MetadataSection(toggle: datasource.toggles[0])
    }
}
