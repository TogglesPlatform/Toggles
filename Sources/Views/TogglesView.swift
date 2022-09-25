//  TogglesView.swift

import SwiftUI

public struct TogglesView: View {
    
    private struct ToggleRow: View {
        
        private var toggle: Toggle

        @ObservedObject var toggleObservable: ToggleObservable
        
        init(manager: ToggleManager, toggle: Toggle) {
            self.toggle = toggle
            self.toggleObservable = ToggleObservable(manager: manager, variable: toggle.variable)
        }
        
        var body: some View {
            HStack(alignment: .center) {
                Image(systemName: toggle.value.sfSymbolId)
                    .padding(.trailing, 5.0)
                VStack(alignment: .leading) {
                    Text(toggle.metadata.description)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text(toggle.variable)
                        .multilineTextAlignment(.leading)
                }
                .padding([.all], 5.0)
                Spacer()
                Text(toggleObservable.value.description)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    public let manager: ToggleManager
    public let datasourceUrl: URL
    
    @State private var searchText = ""
    @State private var groups: [Group] = []
    @State private var showingOptions = false
    @State private var presentDeleteAlert = false
    @State private var shouldShowToolbarView = false
    @State private var overriddenVariables: Set<Variable> = []

    public init(manager: ToggleManager, datasourceUrl: URL) {
        self.manager = manager
        self.datasourceUrl = datasourceUrl
        let groups = try! GroupLoader.loadGroups(datasourceUrl: datasourceUrl)
        self._groups = State(initialValue: groups)
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { group in
                    Section(header: Text(group.title)) {
                        ForEach(group.toggles) { toggle in
                            navigationLink(toggle: toggle.byUpdatingValue(manager.value(for: toggle.variable)))
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
                if shouldShowToolbarView {
                    toolbarView
                }
            }
            .searchable(text: $searchText, prompt: "Filter toggles")
        }
        .onAppear {
            shouldShowToolbarView = manager.hasOverrides
        }
    }
    
    private func navigationLink(toggle: Toggle) -> some View {
        NavigationLink {
            ToggleDetailView(manager: manager, toggle: toggle)
        } label: {
            ToggleRow(manager: manager, toggle: toggle)
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
                overriddenVariables = manager.removeOverrides()
                manager.reactToConfigurationChanges()
                presentDeleteAlert = true
            }
        }
        .alert("Cleared overrides", isPresented: $presentDeleteAlert) {
            Button("OK!", role: .cancel) {
                shouldShowToolbarView = manager.hasOverrides
            }
        } message: {
            let variables = overriddenVariables.joined(separator: "\n")
            Text("The overrides for the following variables have been deleted:\n\n\(variables)")
        }
    }
    
    private var searchResults: [Group] {
        SearchFilter(groups: groups)
            .searchResults(for: searchText)
    }
}

struct TogglesView_Previews: PreviewProvider {
    static var previews: some View {
        let datasourceUrl = Bundle.module.url(forResource: "PreviewDatasource", withExtension: "json")!
        let mutableValueProvider = PersistentValueProvider(userDefaults: .standard)
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         datasourceUrl: datasourceUrl)
        return TogglesView(manager: manager, datasourceUrl: datasourceUrl)
    }
}
