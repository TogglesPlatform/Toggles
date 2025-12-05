//  TextOverrideControl.swift

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct TextOverrideControl: View {
    let manager: ToggleManager
    let toggle: Toggle
    let inputValidationHelper: InputValidationHelper
    
    @Binding var textValue: String
    @Binding var isValidInput: Bool
    @Binding var valueOverridden: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: inputValidationHelper.isObjectToggle ? .top : .center) {
                // Use TextEditor for multiline content (objects, long strings)
                if inputValidationHelper.isObjectToggle {
                    TextEditor(text: $textValue)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 80, maxHeight: 120)
                        .padding(4)
#if os(iOS)
                        .background(Color(.systemGray5))
#else
                        .background(Color.gray.opacity(0.2))
#endif
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    TextField("Enter value", text: $textValue)
                        .font(.system(.body, design: .monospaced))
#if os(iOS)
                        .keyboardType(inputValidationHelper.keyboardType)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
#endif
                        .onSubmit {
                            submitOverride()
                        }
                        .submitLabel(.done)
                        .padding(12)
#if os(iOS)
                        .background(Color(.systemGray5))
#else
                        .background(Color.gray.opacity(0.2))
#endif
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    submitOverride()
                } label: {
                    Image(systemName: valueOverridden ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(valueOverridden ? .green : (isValidInput ? .blue : .gray))
                }
                .disabled(!isValidInput)
                .buttonStyle(.plain)
            }
            
            if inputValidationHelper.toggleNeedsValidation && !textValue.isEmpty {
                HStack {
                    if isValidInput {
                        Label("Valid \(toggle.value.typeDescription.lowercased())", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Label("Invalid \(toggle.value.typeDescription.lowercased())", systemImage: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func submitOverride() {
        guard isValidInput else { return }
        manager.set(inputValidationHelper.overridingValue(for: textValue), for: toggle.variable)
        showOverrideFeedback()
#if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
    
    private func showOverrideFeedback() {
        valueOverridden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            valueOverridden = false
        }
    }
}

private struct TextOverrideControlStringPreview: View {
    @State private var textValue = "Hello World"
    @State private var isValidInput = true
    @State private var valueOverridden = false
    
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
            TextOverrideControl(
                manager: manager,
                toggle: stringToggle,
                inputValidationHelper: InputValidationHelper(toggle: stringToggle),
                textValue: $textValue,
                isValidInput: $isValidInput,
                valueOverridden: $valueOverridden
            )
        }
    }
}

private struct TextOverrideControlIntegerPreview: View {
    @State private var textValue = "42"
    @State private var isValidInput = true
    @State private var valueOverridden = false
    
    var body: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let manager = try! ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                         datasourceUrl: datasourceUrl)
        let content = try! Data(contentsOf: datasourceUrl)
        let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
        let intToggle = datasource.toggles.first { toggle in
            if case .int = toggle.value { return true }
            return false
        }!
        List {
            TextOverrideControl(
                manager: manager,
                toggle: intToggle,
                inputValidationHelper: InputValidationHelper(toggle: intToggle),
                textValue: $textValue,
                isValidInput: $isValidInput,
                valueOverridden: $valueOverridden
            )
        }
    }
}

#Preview("TextOverrideControl - String") {
    TextOverrideControlStringPreview()
}

#Preview("TextOverrideControl - Integer") {
    TextOverrideControlIntegerPreview()
}
