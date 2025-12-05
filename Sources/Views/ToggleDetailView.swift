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
    @State private var valueOverridden: Bool = false
    @State private var showingResetConfirmation: Bool = false
    @State private var expandedValue: String? = nil
    
    @ObservedObject var toggleObservable: ToggleObservable
    
    private var isOverridden: Bool {
        manager.isOverridden(toggle.variable)
    }
    
    init(manager: ToggleManager, toggle: Toggle) {
        self.manager = manager
        self.toggle = toggle
        self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
        self.inputValidationHelper = InputValidationHelper(toggle: toggle)
    }
    
    var body: some View {
        List {
            if manager.mutableValueProvider != nil {
                overrideSection
            }
            currentValueSection
            providersSection
            metadataSection
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
    
    // MARK: - Override Section (Top Priority)
    
    private var overrideSection: some View {
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
                    booleanOverrideControl
                } else {
                    textOverrideControl
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
    
    private var booleanOverrideControl: some View {
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
    
    private var textOverrideControl: some View {
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
    
    // MARK: - Current Value Section
    
    private var currentValueSection: some View {
        Section {
            HStack {
                Label("Via getter", systemImage: "arrow.right.circle")
                Spacer()
                Text(manager.value(for: toggle.variable).description)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                expandedValue = manager.value(for: toggle.variable).description
            }
            
            HStack {
                Label("Via publisher", systemImage: "antenna.radiowaves.left.and.right")
                Spacer()
                Text(toggleObservable.value.description)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                expandedValue = toggleObservable.value.description
            }
        } header: {
            Label("Live Value", systemImage: "bolt.fill")
        }
    }
    
    // MARK: - Providers Section
    
    private var providersSection: some View {
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
    
    // MARK: - Metadata Section
    
    private var metadataSection: some View {
        Section {
            HStack {
                Label("Variable", systemImage: "tag")
                Spacer()
                Text(toggle.variable)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label("Type", systemImage: toggle.value.sfSymbolId)
                Spacer()
                Text(toggle.value.typeDescription)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label("Group", systemImage: "folder")
                Spacer()
                Text(toggle.metadata.group)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Label("Metadata", systemImage: "info.circle")
        }
    }
}

// MARK: - Expanded Value View

extension String: @retroactive Identifiable {
    public var id: String { self }
}

private struct ExpandedValueView: View {
    let value: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(value)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle("Value")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        UIPasteboard.general.string = value
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
            }
#else
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
#endif
        }
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
        NavigationView {
            ToggleDetailView(manager: manager, toggle: datasource.toggles[0])
        }
    }
}
