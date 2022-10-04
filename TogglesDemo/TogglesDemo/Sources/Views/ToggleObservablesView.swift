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
    @ObservedObject var numericObservable: ToggleObservable
    @ObservedObject var stringObservable: ToggleObservable
    @ObservedObject var secureObservable: ToggleObservable

    init(manager: ToggleManager) {
        self.booleanObservable = ToggleObservable(manager: manager, variable: Constants.booleanToggle)
        self.intObservable = ToggleObservable(manager: manager, variable: Constants.integerToggle)
        self.numericObservable = ToggleObservable(manager: manager, variable: Constants.numericToggle)
        self.stringObservable = ToggleObservable(manager: manager, variable: Constants.stringToggle)
        self.secureObservable = ToggleObservable(manager: manager, variable: Constants.encryptedToggle)
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
            HStack {
                VStack(alignment: .trailing) {
                    HStack {
                        Text(Constants.booleanToggle)
                    }
                    HStack {
                        Text(Constants.integerToggle)
                    }
                    HStack {
                        Text(Constants.numericToggle)
                    }
                    HStack {
                        Text(Constants.stringToggle)
                    }
                    HStack {
                        Text(Constants.encryptedToggle)
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(String(booleanObservable.boolValue!))
                    }
                    HStack {
                        Text(String(intObservable.intValue!))
                    }
                    HStack {
                        Text(String(numericObservable.numberValue!))
                    }
                    HStack {
                        Text(stringObservable.stringValue!)
                    }
                    HStack {
                        Text(secureObservable.secureValue!)
                    }
                }
            }
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
