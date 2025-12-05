//  OverrideSection.swift

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct OverrideSection: View {
    let manager: ToggleManager
    let toggle: Toggle
    let inputValidationHelper: InputValidationHelper
    
    @ObservedObject var toggleObservable: ToggleObservable
    
    @Binding var boolValue: Bool
    @Binding var textValue: String
    @Binding var isValidInput: Bool
    @Binding var valueOverridden: Bool
    @Binding var showingResetConfirmation: Bool
    
    private var isOverridden: Bool {
        manager.isOverridden(toggle.variable)
    }
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                // Current value display
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Value")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(toggleObservable.value.description)
                            .font(.system(.title2, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundStyle(isOverridden ? .orange : .primary)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
                
                Divider()
                
                // Override control
                if inputValidationHelper.isBooleanToggle {
                    BooleanOverrideControl(
                        manager: manager,
                        toggle: toggle,
                        boolValue: $boolValue,
                        valueOverridden: $valueOverridden
                    )
                } else {
                    TextOverrideControl(
                        manager: manager,
                        toggle: toggle,
                        inputValidationHelper: inputValidationHelper,
                        textValue: $textValue,
                        isValidInput: $isValidInput,
                        valueOverridden: $valueOverridden
                    )
                }
            }
            .padding(.vertical, 8)
            
            // Reset button as a proper list row
            if isOverridden {
                Button(role: .destructive) {
                    showingResetConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.red)
                        Text("Reset to Default")
                    }
                }
            }
        } header: {
            HStack {
                Label("Override", systemImage: "slider.horizontal.3")
                if isOverridden {
                    Spacer()
                    Text("Active")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.orange.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

private struct OverrideSectionBooleanPreview: View {
    @State private var boolValue = true
    @State private var textValue = "true"
    @State private var isValidInput = true
    @State private var valueOverridden = false
    @State private var showingResetConfirmation = false
    
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
            OverrideSection(
                manager: manager,
                toggle: boolToggle,
                inputValidationHelper: InputValidationHelper(toggle: boolToggle),
                toggleObservable: ToggleObservable(manager: manager, variable: boolToggle.variable),
                boolValue: $boolValue,
                textValue: $textValue,
                isValidInput: $isValidInput,
                valueOverridden: $valueOverridden,
                showingResetConfirmation: $showingResetConfirmation
            )
        }
    }
}

private struct OverrideSectionStringPreview: View {
    @State private var boolValue = false
    @State private var textValue = "Hello World"
    @State private var isValidInput = true
    @State private var valueOverridden = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
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
            OverrideSection(
                manager: manager,
                toggle: stringToggle,
                inputValidationHelper: InputValidationHelper(toggle: stringToggle),
                toggleObservable: ToggleObservable(manager: manager, variable: stringToggle.variable),
                boolValue: $boolValue,
                textValue: $textValue,
                isValidInput: $isValidInput,
                valueOverridden: $valueOverridden,
                showingResetConfirmation: $showingResetConfirmation
            )
        }
    }
}

#Preview("OverrideSection - Boolean") {
    OverrideSectionBooleanPreview()
}

#Preview("OverrideSection - String") {
    OverrideSectionStringPreview()
}
