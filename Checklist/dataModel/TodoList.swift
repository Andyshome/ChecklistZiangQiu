
import Foundation
import UIKit
import UserNotifications

class TodoList : NSObject, Codable {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    var checkListTitle: String = ""
    var highJob: [ChecklistItem] = []
    var mediumJob: [ChecklistItem] = []
    var lowJob: [ChecklistItem] = []
    var noimportantJob: [ChecklistItem] = []
    
    
    func addTodo(_ item: ChecklistItem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highJob.append(item)
            } else {
                highJob.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumJob.append(item)
            } else {
                mediumJob.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowJob.append(item)
            } else {
                lowJob.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noimportantJob.append(item)
            } else {
                noimportantJob.insert(item, at: index)
            }
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
            return highJob
        case .medium:
            return mediumJob
        case .low:
            return lowJob
        case .no:
            return noimportantJob
        }
    }
    
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.text = ""
        item.checked = true
        mediumJob.append(item)
        return item
    }
    
    func checkNumberOfReminds() -> Int {
        var i = 0
        for _ in highJob {
            i += 1
        }
        for _ in mediumJob {
            i += 1
        }
        for _ in lowJob {
            i += 1
        }
        for _ in noimportantJob {
            i += 1
        }
        
        return i
    }
    
    
    func removeAllNotification() {
        for item in highJob {
            removeNotification(text: item.text)
        }
        for item in mediumJob {
            removeNotification(text: item.text)
        }
        for item in lowJob {
            removeNotification(text: item.text)
        }
        for item in noimportantJob {
            removeNotification(text: item.text)
        }
    }
    
    func removeNotification(text:String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(text)"])
    }
    
    
    func move(item: ChecklistItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highJob.remove(at: index)
        case .medium:
            mediumJob.remove(at: index)
        case .low:
            lowJob.remove(at: index)
        case .no:
            noimportantJob.remove(at: index)
        }

    }
    
}
