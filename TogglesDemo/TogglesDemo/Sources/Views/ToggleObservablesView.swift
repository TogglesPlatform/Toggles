//  ToggleObservablesView.swift

import SwiftUI
import Toggles

@MainActor
struct ToggleObservablesView: View {
    
    let manager: ToggleManager
    
    @ObservedObject var booleanObservable: ToggleObservable
    @ObservedObject var intObservable: ToggleObservable
    @ObservedObject var numericObservable: ToggleObservable
    @ObservedObject var stringObservable: ToggleObservable
    @ObservedObject var secureObservable: ToggleObservable
    @ObservedObject var objectObservable: ToggleObservable
    
    @State private var stringValue: String = ""
    @FocusState private var isStringFieldFocused: Bool

    init(manager: ToggleManager) {
        self.manager = manager
        self.booleanObservable = ToggleObservable(manager: manager, variable: ToggleVariables.booleanToggle)
        self.intObservable = ToggleObservable(manager: manager, variable: ToggleVariables.integerToggle)
        self.numericObservable = ToggleObservable(manager: manager, variable: ToggleVariables.numericToggle)
        self.stringObservable = ToggleObservable(manager: manager, variable: ToggleVariables.stringToggle)
        self.secureObservable = ToggleObservable(manager: manager, variable: ToggleVariables.encryptedToggle)
        self.objectObservable = ToggleObservable(manager: manager, variable: ToggleVariables.objectToggle)
    }
    
    var body: some View {
        List {
            // Header section
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                    Text("Live Reactive Updates")
                        .font(.headline)
                    Text("Values update automatically when overrides or configurations change.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            // Boolean Toggle
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "switch.2")
                        .font(.title3)
                        .foregroundStyle(.green)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ToggleVariables.booleanToggle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(String(booleanObservable.boolValue ?? false))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    SwiftUI.Toggle("", isOn: Binding(
                        get: { booleanObservable.boolValue ?? false },
                        set: { manager.set(.bool($0), for: ToggleVariables.booleanToggle) }
                    ))
                    .labelsHidden()
                    .tint(.green)
                }
                .padding(.vertical, 4)
            }
            
            // Integer Toggle with Stepper
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "number")
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ToggleVariables.integerToggle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(String(intObservable.intValue ?? 0))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Stepper("", value: Binding(
                        get: { intObservable.intValue ?? 0 },
                        set: { manager.set(.int($0), for: ToggleVariables.integerToggle) }
                    ))
                    .labelsHidden()
                }
                .padding(.vertical, 4)
            }
            
            // Numeric Toggle with Stepper
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "function")
                        .font(.title3)
                        .foregroundStyle(.purple)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ToggleVariables.numericToggle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(String(format: "%.2f", numericObservable.numberValue ?? 0.0))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Stepper("", value: Binding(
                        get: { numericObservable.numberValue ?? 0.0 },
                        set: { manager.set(.number($0), for: ToggleVariables.numericToggle) }
                    ), step: 0.5)
                    .labelsHidden()
                }
                .padding(.vertical, 4)
            }
            
            // String Toggle with TextField
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "textformat")
                            .font(.title3)
                            .foregroundStyle(.orange)
                            .frame(width: 28)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ToggleVariables.stringToggle)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(stringObservable.stringValue ?? "")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        TextField("Enter value", text: $stringValue)
                            .font(.system(.body, design: .monospaced))
                            .textFieldStyle(.roundedBorder)
                            .focused($isStringFieldFocused)
                            .onSubmit {
                                manager.set(.string(stringValue), for: ToggleVariables.stringToggle)
                            }
#if os(iOS)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
#endif
                        
                        Button {
                            manager.set(.string(stringValue), for: ToggleVariables.stringToggle)
                            isStringFieldFocused = false
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .onAppear {
                    stringValue = stringObservable.stringValue ?? ""
                }
                .onChange(of: stringObservable.stringValue) { _, newValue in
                    if !isStringFieldFocused {
                        stringValue = newValue ?? ""
                    }
                }
            }
            
            // Read-only toggles
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ToggleVariables.encryptedToggle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(secureObservable.secureValue ?? "")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                
                HStack(spacing: 12) {
                    Image(systemName: "curlybraces")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ToggleVariables.objectToggle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(objectObservable.objectValue?.description ?? "unknown")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            } header: {
                Text("Read-only")
            }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
#endif
        .navigationTitle("Observables")
    }
}

struct ToggleObservablesView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let cipherConfiguration = CipherConfiguration.chaChaPoly
        let manager = try! ToggleManager(datasourceUrl: url,
                                         cipherConfiguration: cipherConfiguration)
        return ToggleObservablesView(manager: manager)
    }
}
