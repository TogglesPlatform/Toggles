//  ToggleDetailView.swift

import Combine
import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ToggleDetailView: View {
    
    let manager: ToggleManager
    let toggle: Toggle
    
    @State private var boolValue: Bool = false
    @State private var textValue: String = ""
    @State private var isValidInput: Bool = false
    @State private var refresh: Bool = false
    @State private var valueOverridden: Bool = false

    @Binding var refreshParent: Bool
    
    @ObservedObject var toggleObservable: ToggleObservable
    
    init(manager: ToggleManager, toggle: Toggle, refreshParent: Binding<Bool>) {
        self.manager = manager
        self.toggle = toggle
        self._refreshParent = refreshParent
        self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        listView
    }
    
    private var listView: some View {
        List {
            toggleInformationSection
            currentValueSection
            // cacheSection
            providersSection
            if manager.mutableValueProvider != nil {
                overrideValueSection
            }
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
    
    private var currentValueSection: some View {
        Section(header: Text("Current returned value")) {
            HStack {
                Text("Via the getter")
                Spacer()
                Text(manager.value(for: toggle.variable).description)
            }
            HStack {
                Text("Via the publisher")
                Spacer()
                Text(toggleObservable.value.description)
            }
        }
    }
    
    private var cacheSection: some View {
        Section(header: Text("Cached value")) {
            HStack {
                Text("Cache")
                Spacer()
                if let value = manager.getCachedValue(for: toggle.variable) {
                    Text(value.description)
                        .font(.body)
                } else {
                    Text("nil")
                        .font(.body)
                        .italic()
                }
            }
        }
    }
    
    private var providersSection: some View {
        Section(header: Text("Providers"),
                footer: Text("The providers are listed in priority order.")) {
            ForEach(manager.stackTrace(for: toggle.variable)) { trace in
                HStack {
                    Text(trace.providerName)
                    Spacer()
                    if case .none = trace.value {
                        Text(trace.value.description)
                            .font(.body)
                            .italic()
                    } else {
                        Text(trace.value.description)
                            .font(.body)
                    }
                }
            }
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
#if os(iOS)
                        .keyboardType(keyboardType)
#endif
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
            manager.reactToConfigurationChanges()
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
        case .none:
            return false
        case .bool:
            return input.boolValue != nil
        case .int:
            return Int(input) != nil
        case .number:
            return Double(input) != nil
        case .string:
            return true
        case .secure:
            return true
        }
    }
    
    private func overridingValue(for input: String) -> Value {
        switch toggle.value {
        case .none:
            return .none
        case .bool:
            return .bool(input.boolValue ?? false)
        case .int:
            return .int(Int(input) ?? 0)
        case .number:
            return .number(Double(input) ?? 0.0)
        case .string:
            return .string(input)
        case .secure:
            return .secure(input)
        }
    }
    
#if os(iOS)
    private var keyboardType: UIKeyboardType {
        switch toggle.value {
        case .none:
            return .default
        case .bool:
            return .default
        case .int:
            return .numberPad
        case .number:
            return .decimalPad
        case .string:
            return .default
        case .secure:
            return .default
        }
    }
#endif
    
    private var isBooleanToggle: Bool {
        if case .bool = toggle.value {
            return true
        }
        return false
    }
    
    private var toggleNeedsValidation: Bool {
        if case .bool = toggle.value { return false }
        if case .string = toggle.value { return false }
        if case .secure = toggle.value { return false }
        return true
    }
}

struct ToggleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        let valueProviders = [try! LocalValueProvider(jsonURL: datasourceUrl)]
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         valueProviders: valueProviders,
                                         datasourceUrl: datasourceUrl)
        let content = try! Data(contentsOf: datasourceUrl)
        let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
        ToggleDetailView(manager: manager, toggle: datasource.toggles[0], refreshParent: .constant(true))
    }
}
