//  TogglesView.swift

public import SwiftUI

/// A view showcasing all toggles from a provided datasource.
public struct TogglesView: View {
    
    @ObservedObject public var manager: ToggleManager
    public let datasourceUrl: URL
    
    @State private var searchText = ""
    @State private var groups: [Group] = []
    @State private var showingOptions = false
    @State private var presentDeleteAlert = false
    @State private var overriddenVariables: Set<Variable> = []
    
    private var canOverride: Bool {
        manager.mutableValueProvider != nil
    }
    
    /// The default initializer for the view.
    ///
    /// - Parameters:
    ///   - manager: The manager used to retrieve and update the toggles. The manager should be setup using the same datasource provded to this view.
    ///   - datasourceUul: The url to the datasource.
    public init(manager: ToggleManager, datasourceUrl: URL) {
        self.manager = manager
        self.datasourceUrl = datasourceUrl
        let groups = try! GroupLoader.loadGroups(datasourceUrl: datasourceUrl)
        self._groups = State(initialValue: groups)
    }
    
    public var body: some View {
        List {
            ForEach(searchResults) { group in
                Section(header: Text(group.title)) {
                    ForEach(group.toggles) { toggle in
                        toggleRowView(for: toggle)
                    }
                }
                .accessibilityLabel(group.accessibilityLabel)
            }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
#endif
        .accessibilityLabel("Toggles list")
        .navigationTitle("Toggles")
        .toolbar {
            if manager.hasOverrides {
                toolbarView
            }
        }
        .searchable(text: $searchText, prompt: "Filter toggles")
#if os(iOS)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
#endif
        .alert("Cleared overrides", isPresented: $presentDeleteAlert) {
            Button("OK!", role: .cancel) {}
        } message: {
            let variables = overriddenVariables.joined(separator: "\n")
            Text("The overrides for the following variables have been deleted:\n\n\(variables)")
        }
    }
    
    private func toggleRowView(for toggle: Toggle) -> some View {
        NavigationLink {
            ToggleDetailView(manager: manager, toggle: toggle)
        } label: {
            ToggleRow(manager: manager, toggle: toggle, canOverride: canOverride)
        }
        .accessibilityLabel(toggle.accessibilityLabel)
    }
    
    private var toolbarView: some View {
        Button {
            showingOptions = true
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .confirmationDialog("Select an action", isPresented: $showingOptions) {
            Button("Clear overrides") {
                Task {
                    await MainActor.run {
                        overriddenVariables = manager.removeOverrides()
                        presentDeleteAlert = true
                    }
                }
            }
        }
    }
    
    private var searchResults: [Group] {
        SearchFilter(groups: groups)
            .searchResults(for: searchText)
    }
}

#Preview {
    let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
    let mutableValueProvider = PersistentValueProvider(userDefaults: .standard)
    let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                     datasourceUrl: datasourceUrl)
    NavigationView {
        TogglesView(manager: manager, datasourceUrl: datasourceUrl)
    }
}
