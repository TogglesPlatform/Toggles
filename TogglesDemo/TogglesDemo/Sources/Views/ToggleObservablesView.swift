//  ToggleObservablesView.swift

import SwiftUI
import Toggles

struct ToggleObservablesView: View {
    
    let message = """
The values shown below are taken via ToggleObservables.
The view will show the values updating when overrides or new configurations are loaded.
"""
    
    @ObservedObject var booleanObservable: ToggleObservable
    @ObservedObject var intObservable: ToggleObservable
    @ObservedObject var numericalObservable: ToggleObservable
    @ObservedObject var stringObservable: ToggleObservable
    @ObservedObject var secureObservable: ToggleObservable

    init(manager: ToggleManager) {
        self.booleanObservable = ToggleObservable(manager: manager, variable: Constant.booleanToggle)
        self.intObservable = ToggleObservable(manager: manager, variable: Constant.integerToggle)
        self.numericalObservable = ToggleObservable(manager: manager, variable: Constant.numericalToggle)
        self.stringObservable = ToggleObservable(manager: manager, variable: Constant.stringToggle)
        self.secureObservable = ToggleObservable(manager: manager, variable: Constant.encryptedToggle)
    }
        
    var body: some View {
        VStack(spacing: 10) {
            Text("ToggleObservables showcase")
                .font(.title)
                .padding()
            Text(message)
                .padding()
            HStack {
                Text("Bool")
                Text(String(booleanObservable.boolValue))
            }
            HStack {
                Text("Int")
                Text(String(intObservable.intValue))
            }
            HStack {
                Text("Double")
                Text(String(numericalObservable.numberValue))
            }
            HStack {
                Text("String")
                Text(stringObservable.stringValue)
            }
            HStack {
                Text("Secure")
                Text(secureObservable.secureValue)
            }
        }
    }
}

struct ToggleObservablesView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let cypherConfiguration = CypherConfiguration.chaChaPoly
        let manager = try! ToggleManager(datasourceUrl: url,
                                         cypherConfiguration: cypherConfiguration)
        return ToggleObservablesView(manager: manager)
    }
}
