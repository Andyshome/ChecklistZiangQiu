

import Foundation
class delegate : NSObject,Codable {
    static var delegateList = [TodoList]()
    
    func saveData(){
        let dataToSave = delegate.delegateList
        print(dataToSave)
        print("Data is saving")
        let documentDictonary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDictonary.appendingPathComponent("Todolist").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodeList = try? propertyListEncoder.encode(dataToSave)
        try? encodeList?.write(to: archiveURL,options:.noFileProtection)
    }
    
    
    func readData() {
        let documentDictonary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDictonary.appendingPathComponent("Todolist").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        print("readingData")
        if let retrievedListData = try? Data(contentsOf: archiveURL),
            let decodedList = try?
                propertyListDecoder.decode(Array<TodoList>.self, from: retrievedListData){
            guard decodedList != [] else { return }
            delegate.delegateList = decodedList
            print("finish reading data")
            
        }
        
    }
    
    func newDelegate() -> TodoList {
        let newList = TodoList()
        newList.checkListTitle = ""
        delegate.delegateList.append(newList)
        return newList
    }

}
