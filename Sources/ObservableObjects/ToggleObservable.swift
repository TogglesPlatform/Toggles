//  ToggleObservable.swift

import Combine
import Foundation

class ToggleObservable: ObservableObject {
    
    var manager: ToggleManager
    var cancellables: Set<AnyCancellable> = []
    
    @Published
    var value: Value = .none
    
    init(manager: ToggleManager, variable: Variable) {
        self.manager = manager
        subscribe(on: variable)
    }
    
    private func subscribe(on variable: Variable) {
        manager.publisher(for: variable)
            .sink { value in
                self.value = value
            }
            .store(in: &cancellables)
    }
}
