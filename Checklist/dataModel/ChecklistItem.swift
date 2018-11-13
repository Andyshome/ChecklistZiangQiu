

import Foundation

class ChecklistItem: NSObject ,Codable{
    
    var text = ""
    var checked = false
    var date : Date = Date.init()
    var remindMode = false
    func toggleChecked() {
        checked = !checked
    }
}
