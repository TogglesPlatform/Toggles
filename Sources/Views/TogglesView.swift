//  TogglesView.swift

import SwiftUI

typealias SFSymbolId = String

extension Value {
    
    var description: String {
        switch self {
        case .bool(let value):
            return String(value)
        case .int(let value):
            return String(value)
        case .number(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
    
    var typeDescription: String {
        switch self {
        case .bool:
            return "Bool"
        case .int:
            return "Int"
        case .number:
            return "Double"
        case .string:
            return "String"
        }
    }
    
    var sfSymbolId: SFSymbolId {
        switch self {
        case .bool:
            return "switch.2"
        case .int:
            return "number.square"
        case .number:
            return "number.square.fill"
        case .string:
            return "textformat"
        }
    }
}

struct ToggleRow: View {
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

extension Toggle: Comparable {
    public static func < (lhs: Toggle, rhs: Toggle) -> Bool {
        lhs.variable < rhs.variable
    }
}

extension Toggle: Identifiable {
    public var id: String { variable }
}

extension Toggle {
    var accessibilityLabel: String {
        metadata.description + "has value" + value.description
    }
}

public struct TogglesView: View {
        
    struct Group: Comparable, Identifiable {
        let title: String
        let toggles: [Toggle]
        
        public var id: String { title }
        
        static func < (lhs: TogglesView.Group, rhs: TogglesView.Group) -> Bool {
            lhs.title < rhs.title
        }
    }
    
    let manager: ToggleManager
    let groups: [Group]

    public init(manager: ToggleManager, dataSourceUrl: URL) throws {
        self.manager = manager
        let content = try Data(contentsOf: dataSourceUrl)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        groups = Dictionary(grouping: dataSource.toggles, by: \.metadata.group)
            .map { Group(title: $0, toggles: $1.sorted(by: <)) }
            .sorted(by: <)
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(groups) { group in
                    Section(header: Text(group.title)) {
                        ForEach(group.toggles) { toggle in
                            NavigationLink {
                                ToggleDetailView(manager: manager, toggle: toggle)
                            } label: {
                                ToggleRow(toggle: toggle)
                                    .accessibilityLabel(toggle.accessibilityLabel)
                            }
                        }
                    }
                    .accessibilityLabel(group.title)
                }
            }
            .listStyle(.insetGrouped)
            .accessibilityLabel("Toggles list")
            .navigationTitle("Toggles")
        }
    }
}

struct TogglesView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSourceUrl = Bundle.module.url(forResource: "contract", withExtension: "json")!
        let mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        let manager = try! ToggleManager(mutableValueProvider: mutableValueProvider,
                                         dataSourceUrl: dataSourceUrl)
        return try! TogglesView(manager: manager, dataSourceUrl: dataSourceUrl)
    }
}
