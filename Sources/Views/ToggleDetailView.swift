//  ToggleDetailView.swift

import SwiftUI

struct ToggleDetailView: View {
    
    let manager: ToggleManager
    let toggle: Toggle
    
    @State private var boolValue: Bool = false
    @State private var textValue: String = ""
    @State private var isValidInput: Bool = false
    @State private var refresh: Bool = false
    @State private var valueOverridden: Bool = false

    @Binding var refreshParent: Bool
    
    var body: some View {
        listView
    }
    
    private var listView: some View {
        List {
            toggleInformationSection
            providersSection
            currentValueSection
            overrideValueSection
        }
        .navigationTitle(toggle.metadata.description)
        .onAppear {
            if case .bool(let value) = manager.value(for: toggle.variable) {
                boolValue = value
            }
            textValue = manager.value(for: toggle.variable).description
        }
        .onChange(of: textValue) { newValue in
            isValidInput = isInputValid(newValue)
        }
        .onChange(of: refresh) { _ in }
    }
    
    private var toggleInformationSection: some View {
        Section(header: Text("Information")) {
            HStack {
                Text("Variable")
                Spacer()
                Text(toggle.variable)
            }
            HStack {
                Text("Value type")
                Spacer()
                Text(toggle.value.typeDescription)
            }
            HStack {
                Text("Group")
                Spacer()
                Text(toggle.metadata.group)
            }
        }
    }
    
    private var providersSection: some View {
        Section(header: Text("Providers"),
                footer: Text("The providers are listed in priority order.")) {
            ForEach(manager.stackTrace(for: toggle.variable), id: \.0) { trace in
                HStack {
                    Text(trace.0)
                    Spacer()
                    Text(trace.1?.description ?? "nil")
                }
            }
        }
    }
    
    private var currentValueSection: some View {
        Section(header: Text("Current returned value"))  {
            Text(manager.value(for: toggle.variable).description)
        }
    }
    
    private var overrideValueSection: some View {
        Section {
            HStack {
                if isBooleanToggle {
                    SwiftUI.Toggle(isOn: $boolValue) {
                        EmptyView()
                    }
                    .frame(width: 1, height: 1, alignment: .leading)
                    .onChange(of: boolValue) { newValue in
                        textValue = newValue ? "t" : "f"
                    }
                }
                else {
                    TextField("Override value", text: $textValue)
                        .keyboardType(keyboardType)
                }
                Spacer()
                overrideButtonView
            }
        } header: {
            Text("Override value")
        } footer: {
            HStack {
                if toggleNeedsValidation {
                    if isValidInput {
                        Label("Valid input", systemImage: "checkmark.diamond")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    else {
                        Label("Invalid input", systemImage: "multiply.circle")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                if valueOverridden {
                    Spacer()
                    Label("Value overridden", systemImage: "checkmark")
                        .font(.caption)
                }
            }
        }
    }
    
    private var overrideButtonView: some View {
        Button("Override") {
            manager.set(overridingValue(for: textValue), for: toggle.variable)
            valueOverridden = true
            refresh.toggle()
            refreshParent.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                valueOverridden = false
            }
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
    
    private var keyboardType: UIKeyboardType {
        switch toggle.value {
        case .bool:
            return .default
        case .int:
            return .numberPad
        case .number:
            return .decimalPad
        case .string:
            return .default
        }
    }
    
    private var isBooleanToggle: Bool {
        if case .bool = toggle.value {
            return true
        }
        return false
    }
    
    private var toggleNeedsValidation: Bool {
        if case .bool = toggle.value { return false }
        if case .string = toggle.value { return false }
        return true
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
        ToggleDetailView(manager: manager, toggle: dataSource.toggles[0], refreshParent: .constant(true))
    }
}
