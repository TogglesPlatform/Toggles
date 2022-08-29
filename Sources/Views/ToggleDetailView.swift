//  ToggleDetailView.swift

import SwiftUI

struct ToggleDetailView: View {
    
    let manager: ToggleManager
    let toggle: Toggle
    
    @State private var textValue: String = ""
    @State private var isValidInput: Bool = false
    @State private var valueSaved: Bool = false

    init(manager: ToggleManager, toggle: Toggle) {
        self.manager = manager
        self.toggle = toggle
    }
    
    var body: some View {
        listView
    }
    
    var listView: some View {
        List {
            providersSection
            currentValueSection
            overrideValueSection
        }
    }
    
    var providersSection: some View {
        Section(header: Text("Providers")) {
            ForEach(manager.stackTrace(for: toggle.variable), id: \.0) { trace in
                HStack {
                    Text(trace.0)
                    Spacer()
                    Text(trace.1?.description ?? "nil")
                }
            }
        }
    }
    
    var currentValueSection: some View {
        Section(header: Text("Current returned value"))  {
            Text(manager.value(for: toggle.variable).description)
        }
    }
    
    var overrideValueSection: some View {
        Section {
            HStack {
                TextField("Override value", text: $textValue)
                    .onAppear {
                        textValue = manager.value(for: toggle.variable).description
                    }
                    .onChange(of: textValue) {  newValue in
                        isValidInput = isInputValid(newValue)
                    }
                Spacer()
                saveButtonView
            }
        } header: {
            Text("Override value")
        } footer: {
            HStack {
                if isValidInput {
                    Label("Valid value", systemImage: "checkmark.diamond")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                else {
                    Label("Invalid value", systemImage: "multiply.circle")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                if valueSaved {
                    Spacer()
                    Label("Value overridden", systemImage: "checkmark")
                }
            }
        }
    }
    
    var saveButtonView: some View {
        Button("Save") {
            if textValue.isEmpty {
                manager.delete(toggle.variable)
            } else {
                manager.set(overridingValue(for: textValue), for: toggle.variable)
            }
            valueSaved = true
        }
        .disabled(!isValidInput)
    }
    
    private func isInputValid(_ input: String) -> Bool {
        guard !input.isEmpty else { return true }
        switch toggle.value {
        case .bool:
            return input.boolValue != nil
        case .int:
            return Int(input) != nil
        case .number:
            return Double(input) != nil
        case .string:
            return true
        }
    }
    
    private func overridingValue(for input: String) -> Value {
        switch toggle.value {
        case .bool:
            return .bool(input.boolValue ?? false)
        case .int:
            return .int(Int(input) ?? 0)
        case .number:
            return .number(Double(input) ?? 0.0)
        case .string:
            return .string(input)
        }
    }
}

struct ToggleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSourceUrl = Bundle.module.url(forResource: "contract", withExtension: "json")!
        
        let mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        let optionalValueProviders = [try! OptionalLocalValueProvider(jsonURL: dataSourceUrl)]
        
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         optionalValueProviders: optionalValueProviders,
                                         dataSourceUrl: dataSourceUrl)
        let content = try! Data(contentsOf: dataSourceUrl)
        let dataSource = try! JSONDecoder().decode(DataSource.self, from: content)
        ToggleDetailView(manager: manager, toggle: dataSource.toggles[0])
    }
}