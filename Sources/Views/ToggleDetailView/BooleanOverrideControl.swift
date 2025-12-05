//  BooleanOverrideControl.swift

import SwiftUI

struct BooleanOverrideControl: View {
    let manager: ToggleManager
    let toggle: Toggle
    
    @Binding var boolValue: Bool
    @Binding var valueOverridden: Bool
    
    private var isOverridden: Bool {
        manager.isOverridden(toggle.variable)
    }
    
    var body: some View {
        HStack {
            Text("Override to")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    manager.set(.bool(false), for: toggle.variable)
                    boolValue = false
                    showOverrideFeedback()
                } label: {
                    Text("false")
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(!boolValue && isOverridden ? .white : .red)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(!boolValue && isOverridden ? Color.red : Color.red.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                
                Button {
                    manager.set(.bool(true), for: toggle.variable)
                    boolValue = true
                    showOverrideFeedback()
                } label: {
                    Text("true")
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(boolValue && isOverridden ? .white : .green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(boolValue && isOverridden ? Color.green : Color.green.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func showOverrideFeedback() {
        valueOverridden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            valueOverridden = false
        }
    }
}

private struct BooleanOverrideControlPreview: View {
    @State private var boolValue = true
    @State private var valueOverridden = false
    
    var body: some View {
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
            BooleanOverrideControl(
                manager: manager,
                toggle: boolToggle,
                boolValue: $boolValue,
                valueOverridden: $valueOverridden
            )
        }
    }
}

#Preview("BooleanOverrideControl") {
    BooleanOverrideControlPreview()
}
