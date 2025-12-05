//  LiveValueSection.swift

import SwiftUI

struct LiveValueSection: View {
    let manager: ToggleManager
    let toggle: Toggle
    
    @ObservedObject var toggleObservable: ToggleObservable
    @Binding var expandedValue: String?
    
    var body: some View {
        Section {
            HStack {
                Label("Via getter", systemImage: "arrow.right.circle")
                Spacer()
                Text(manager.value(for: toggle.variable).description)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                expandedValue = manager.value(for: toggle.variable).description
            }
            
            HStack {
                Label("Via publisher", systemImage: "antenna.radiowaves.left.and.right")
                Spacer()
                Text(toggleObservable.value.description)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                expandedValue = toggleObservable.value.description
            }
        } header: {
            Label("Live Value", systemImage: "bolt.fill")
        }
    }
}

private struct LiveValueSectionPreview: View {
    @State private var expandedValue: String? = nil
    
    var body: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let manager = try! ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                         datasourceUrl: datasourceUrl)
        let content = try! Data(contentsOf: datasourceUrl)
        let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
        List {
            LiveValueSection(
                manager: manager,
                toggle: datasource.toggles[0],
                toggleObservable: ToggleObservable(manager: manager, variable: datasource.toggles[0].variable),
                expandedValue: $expandedValue
            )
        }
    }
}

#Preview("LiveValueSection") {
    LiveValueSectionPreview()
}
