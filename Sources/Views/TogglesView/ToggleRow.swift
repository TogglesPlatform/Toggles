//  ToggleRow.swift

import SwiftUI

struct ToggleRow: View {
    let manager: ToggleManager
    let toggle: Toggle
    let canOverride: Bool
    
    @ObservedObject var toggleObservable: ToggleObservable
    
    private var isOverridden: Bool {
        manager.isOverridden(toggle.variable)
    }
    
    private var isBooleanToggle: Bool {
        if case .bool = toggle.value { return true }
        return false
    }
    
    init(manager: ToggleManager, toggle: Toggle, canOverride: Bool) {
        self.manager = manager
        self.toggle = toggle
        self.canOverride = canOverride
        self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Type icon
            Image(systemName: toggle.value.sfSymbolId)
                .font(.title3)
                .foregroundStyle(isOverridden ? .orange : .secondary)
                .frame(width: 28)
            
            // Toggle info
            VStack(alignment: .leading, spacing: 2) {
                Text(toggle.metadata.description)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Text(toggle.variable)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    if isOverridden {
                        Image(systemName: "pencil.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
            }
            
            Spacer()
            
            // Value display / control
            if isBooleanToggle && canOverride {
                SwiftUI.Toggle("", isOn: Binding(
                    get: { toggleObservable.boolValue ?? false },
                    set: { manager.set(.bool($0), for: toggle.variable) }
                ))
                .labelsHidden()
                .tint(.green)
            } else {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(toggleObservable.value.description)
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(isOverridden ? .orange : .primary)
                    
                    if isOverridden && !isBooleanToggle {
                        Text("overridden")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("ToggleRow - Boolean") {
    let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
    let manager = try! ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                     datasourceUrl: datasourceUrl)
    let content = try! Data(contentsOf: datasourceUrl)
    let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
    let boolToggle = datasource.toggles.first { toggle in
        if case .bool = toggle.value { return true }
        return false
    }!
    List {
        ToggleRow(manager: manager, toggle: boolToggle, canOverride: true)
    }
}

#Preview("ToggleRow - String") {
    let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
    let manager = try! ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                     datasourceUrl: datasourceUrl)
    let content = try! Data(contentsOf: datasourceUrl)
    let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
    let stringToggle = datasource.toggles.first { toggle in
        if case .string = toggle.value { return true }
        return false
    }!
    List {
        ToggleRow(manager: manager, toggle: stringToggle, canOverride: true)
    }
}
