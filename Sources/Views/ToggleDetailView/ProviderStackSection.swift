//  ProviderStackSection.swift

import SwiftUI

struct ProviderStackSection: View {
    let manager: ToggleManager
    let toggle: Toggle
    
    @Binding var expandedValue: String?
    
    var body: some View {
        Section {
            ForEach(manager.stackTrace(for: toggle.variable)) { trace in
                HStack {
                    Label(trace.providerName, systemImage: "shippingbox")
                        .foregroundStyle(trace.value != nil ? .primary : .tertiary)
                    Spacer()
                    if let value = trace.value {
                        Text(value.description)
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("—")
                            .foregroundStyle(.tertiary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let value = trace.value {
                        expandedValue = value.description
                    }
                }
            }
        } header: {
            Label("Provider Stack", systemImage: "square.stack.3d.up")
        } footer: {
            Text("Values are resolved from top to bottom. First non-nil value wins.")
        }
    }
}

private struct ProviderStackSectionPreview: View {
    @State private var expandedValue: String? = nil
    
    var body: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let manager = try! ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                         valueProviders: [try! LocalValueProvider(jsonUrl: datasourceUrl)],
                                         datasourceUrl: datasourceUrl)
        let content = try! Data(contentsOf: datasourceUrl)
        let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
        List {
            ProviderStackSection(
                manager: manager,
                toggle: datasource.toggles[0],
                expandedValue: $expandedValue
            )
        }
    }
}

#Preview("ProviderStackSection") {
    ProviderStackSectionPreview()
}
