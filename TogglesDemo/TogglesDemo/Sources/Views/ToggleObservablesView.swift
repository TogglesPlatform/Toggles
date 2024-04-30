//  ToggleObservablesView.swift

import SwiftUI
import Toggles

@MainActor
struct ToggleObservablesView: View {
    
    let message = """
The values shown below are taken via ToggleObservables.
The view will show the values updating when overrides or new configurations are loaded.
"""
    
    @ObservedObject var booleanObservable: ToggleObservable
    @ObservedObject var intObservable: ToggleObservable
    @ObservedObject var numericObservable: ToggleObservable
    @ObservedObject var stringObservable: ToggleObservable
    @ObservedObject var secureObservable: ToggleObservable
    @ObservedObject var objectObservable: ToggleObservable

    init(manager: ToggleManager) {
        self.booleanObservable = ToggleObservable(manager: manager, variable: ToggleVariables.booleanToggle)
        self.intObservable = ToggleObservable(manager: manager, variable: ToggleVariables.integerToggle)
        self.numericObservable = ToggleObservable(manager: manager, variable: ToggleVariables.numericToggle)
        self.stringObservable = ToggleObservable(manager: manager, variable: ToggleVariables.stringToggle)
        self.secureObservable = ToggleObservable(manager: manager, variable: ToggleVariables.encryptedToggle)
        self.objectObservable = ToggleObservable(manager: manager, variable: ToggleVariables.objectToggle)
    }
        
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "slowmo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text("ToggleObservables showcase")
                .font(.title)
                .padding()
            Text(message)
                .padding()
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(ToggleVariables.booleanToggle):")
                    Text(String(booleanObservable.boolValue!))
                }
                HStack {
                    Text("\(ToggleVariables.integerToggle):")
                    Text(String(intObservable.intValue!))
                }
                HStack {
                    Text("\(ToggleVariables.numericToggle):")
                    Text(String(numericObservable.numberValue!))
                }
                HStack {
                    Text("\(ToggleVariables.stringToggle):")
                    Text(stringObservable.stringValue!)
                }
                HStack {
                    Text("\(ToggleVariables.encryptedToggle):")
                    Text(secureObservable.secureValue!)
                }
                HStack {
                    Text("\(ToggleVariables.objectToggle):")
                    Text(objectObservable.objectValue?.description ?? "unknown")
                }
            }.padding(.horizontal, 24)
        }
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
