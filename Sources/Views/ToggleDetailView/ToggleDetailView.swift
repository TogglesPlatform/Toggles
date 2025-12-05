//  ToggleDetailView.swift

import SwiftUI

struct ToggleDetailView: View {
    
    let manager: ToggleManager
    let toggle: Toggle
    let inputValidationHelper: InputValidationHelper
    
    @State private var boolValue: Bool = false
    @State private var textValue: String = ""
    @State private var isValidInput: Bool = false
    @State private var valueOverridden: Bool = false
    @State private var showingResetConfirmation: Bool = false
    @State private var expandedValue: String? = nil
    
    @ObservedObject var toggleObservable: ToggleObservable
    
    init(manager: ToggleManager, toggle: Toggle) {
        self.manager = manager
        self.toggle = toggle
        self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
        self.inputValidationHelper = InputValidationHelper(toggle: toggle)
    }
    
    var body: some View {
        List {
            if manager.mutableValueProvider != nil {
                OverrideSection(
                    manager: manager,
                    toggle: toggle,
                    inputValidationHelper: inputValidationHelper,
                    toggleObservable: toggleObservable,
                    boolValue: $boolValue,
                    textValue: $textValue,
                    isValidInput: $isValidInput,
                    valueOverridden: $valueOverridden,
                    showingResetConfirmation: $showingResetConfirmation
                )
            }
            
            LiveValueSection(
                manager: manager,
                toggle: toggle,
                toggleObservable: toggleObservable,
                expandedValue: $expandedValue
            )
            
            ProviderStackSection(
                manager: manager,
                toggle: toggle,
                expandedValue: $expandedValue
            )
            
            MetadataSection(toggle: toggle)
        }
#if os(iOS)
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .navigationTitle(toggle.metadata.description)
        .sheet(item: $expandedValue) { value in
            ExpandedValueView(value: value)
        }
        .onAppear {
            syncValues()
        }
        .onChange(of: textValue) { newValue in
            isValidInput = inputValidationHelper.isInputValid(newValue)
        }
        .onChange(of: toggleObservable.value) { _ in
            syncValues()
        }
        .confirmationDialog(
            "Reset to Default",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                manager.delete(toggle.variable)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove the override and restore the default value.")
        }
    }
    
    private func syncValues() {
        if case .bool(let value) = manager.value(for: toggle.variable) {
            boolValue = value
        }
        textValue = manager.value(for: toggle.variable).description
    }
}

#Preview {
    let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
    let mutableValueProvider = PersistentValueProvider(userDefaults: .standard)
    let valueProviders = [try! LocalValueProvider(jsonUrl: datasourceUrl)]
    let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                     valueProviders: valueProviders,
                                     datasourceUrl: datasourceUrl)
    let content = try! Data(contentsOf: datasourceUrl)
    let datasource = try! JSONDecoder().decode(Datasource.self, from: content)
    NavigationView {
        ToggleDetailView(manager: manager, toggle: datasource.toggles[0])
    }
}
