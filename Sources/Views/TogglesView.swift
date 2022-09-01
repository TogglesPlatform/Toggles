//  TogglesView.swift

import SwiftUI

public struct TogglesView: View {
        
    private struct ToggleRow: View {
        var toggle: Toggle

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
                Text(toggle.value.description)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    private struct Group: Comparable, Identifiable {
        let title: String
        let toggles: [Toggle]
        
        public var id: String { title }
        
        static func < (lhs: TogglesView.Group, rhs: TogglesView.Group) -> Bool {
            lhs.title < rhs.title
        }
    }
    
    public let manager: ToggleManager
    public let dataSourceUrl: URL
    
    @State private var groups: [Group] = []
    @State private var refresh: Bool = false
    @State private var showingOptions = false

    public init(manager: ToggleManager, dataSourceUrl: URL) {
        self.manager = manager
        self.dataSourceUrl = dataSourceUrl
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(groups) { group in
                    Section(header: Text(group.title)) {
                        ForEach(group.toggles) { toggle in
                            navigationLink(toggle: toggle.byUpdatingValue(manager.value(for: toggle.variable)))
                        }
                    }
                    .accessibilityLabel(group.title)
                }
            }
            .listStyle(.insetGrouped)
            .accessibilityLabel("Toggles list")
            .navigationTitle("Toggles")
            .toolbar {
                toolbar
            }
            .onChange(of: refresh) { newValue in
                groups = loadGroups()
            }
        }
        .onAppear {
            groups = loadGroups()
        }
    }
    
    private func navigationLink(toggle: Toggle) -> some View {
        NavigationLink {
            ToggleDetailView(manager: manager, toggle: toggle, refreshParent: $refresh)
        } label: {
            ToggleRow(toggle: toggle.byUpdatingValue(manager.value(for: toggle.variable)))
                .accessibilityLabel(toggle.accessibilityLabel)
        }
    }
    
    private var toolbar: some View {
        Button {
            showingOptions = true
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .confirmationDialog("Select an action", isPresented: $showingOptions) {
            Button("Clear overrides & cache") {
                manager.removeOverrides()
            }
        }
    }
    
    private func loadGroups() -> [Group] {
        guard let content = try? Data(contentsOf: dataSourceUrl),
              let dataSource = try? JSONDecoder().decode(DataSource.self, from: content) else {
            return []
        }
        return Dictionary(grouping: dataSource.toggles, by: \.metadata.group)
            .map { Group(title: $0, toggles: $1.sorted(by: <)) }
            .sorted(by: <)
    }
}

struct TogglesView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSourceUrl = Bundle.module.url(forResource: "contract", withExtension: "json")!
        let mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         dataSourceUrl: dataSourceUrl)
        return TogglesView(manager: manager, dataSourceUrl: dataSourceUrl)
    }
}
