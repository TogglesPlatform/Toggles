//  ToggleDetailView.swift

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ToggleDetailView: View {
    
    let manager: ToggleManager
    let toggle: Toggle
    let inputValidationHelper: InputValidationHelper
    
    @State private var boolValue: Bool = false
    @State private var textValue: String = ""
    @State private var isValidInput: Bool = false
    @State private var refresh: Bool = false
    @State private var valueOverridden: Bool = false

    @ObservedObject var toggleObservable: ToggleObservable
    
    init(manager: ToggleManager, toggle: Toggle) {
        self.manager = manager
        self.toggle = toggle
        self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
        self.inputValidationHelper = InputValidationHelper(toggle: toggle)
    }
    
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
            isValidInput = inputValidationHelper.isInputValid(newValue)
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
                    if let value = trace.value {
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
    }
    
    private var overrideValueSection: some View {
        Section {
            HStack {
                if inputValidationHelper.isBooleanToggle {
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
                        .keyboardType(inputValidationHelper.keyboardType)
#endif
                }
                Spacer()
                overrideButtonView
            }
        } header: {
            Text("Override value")
        } footer: {
            HStack {
                if inputValidationHelper.toggleNeedsValidation {
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
            manager.set(inputValidationHelper.overridingValue(for: textValue), for: toggle.variable)
            valueOverridden = true
            refresh.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                valueOverridden = false
            }
        }
        .disabled(!isValidInput)
    }
}

struct ToggleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let mutableValueProvider = PersistentValueProvider(userDefaults: .standard)
        let valueProviders = [try! LocalValueProvider(jsonUrl: datasourceUrl)]
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         valueProviders: valueProviders,
                                         datasourceUrl: datasourceUrl)
        let content = try! Data(contentsOf: datasourceUrl)
        let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
        ToggleDetailView(manager: manager, toggle: datasource.toggles[0])
    }
}
