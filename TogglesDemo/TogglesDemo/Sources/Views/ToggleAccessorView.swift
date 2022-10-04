//  ToggleAccessorView.swift

import SwiftUI
import Toggles

struct ToggleAccessorView: View {
    
    var accessor: ToggleAccessor
    
    let message = """
The values shown below are taken via a ToggleAccessor.
This view will not show the values updating when overrides or new configurations are loaded.
"""
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "snowflake")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text("ToggleAccessor showcase")
                .font(.title)
                .padding()
            Text(message)
                .padding()
            HStack {
                VStack(alignment: .trailing) {
                    HStack {
                        Text(Constant.booleanToggle)
                    }
                    HStack {
                        Text(Constant.integerToggle)
                    }
                    HStack {
                        Text(Constant.numericToggle)
                    }
                    HStack {
                        Text(Constant.stringToggle)
                    }
                    HStack {
                        Text(Constant.encryptedToggle)
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(String(accessor.booleanToggle))
                    }
                    HStack {
                        Text(String(accessor.integerToggle))
                    }
                    HStack {
                        Text(String(accessor.numericToggle))
                    }
                    HStack {
                        Text(accessor.stringToggle)
                    }
                    HStack {
                        Text(accessor.encryptedToggle)
                    }
                }
            }
        }
    }
}

struct ToggleAccessorView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let cipherConfiguration = CipherConfiguration.chaChaPoly
        let manager = try! ToggleManager(datasourceUrl: url,
                                         cipherConfiguration: cipherConfiguration)
        let accessor = ToggleAccessor(manager: manager)
        return ToggleAccessorView(accessor: accessor)
    }
}
