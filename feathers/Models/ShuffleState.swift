import SwiftUI

class ShuffleState: ObservableObject {
    @Published var spiritsTrigger = false
    @Published var feathersTrigger = false
    @Published var arrangementsTrigger = false
    
    func shuffleCurrent(tab: Int) {
        switch tab {
        case 0:
            spiritsTrigger.toggle()
        case 1:
            feathersTrigger.toggle()
        case 2:
            arrangementsTrigger.toggle()
        default:
            break
        }
    }
} 