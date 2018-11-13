

import UIKit
import UserNotifications
protocol ItemDetailViewControllerDelegate: class {
    
    func cancelEditingItems(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)

}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    
    
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    var dueTime : Date = Date.init() {
        didSet {
            updateTimeLable()
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var dateTextFeild: UILabel!
    @IBOutlet weak var remindSwitch: UISwitch!
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.cancelEditingItems(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textfield.text {
            item.text = text
            item.date = datePicker.date
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            if remindSwitch.isOn == true {
                registNotification()
                item.remindMode = true
            }
        } else {
            if let item = todoList?.newTodo() {
                if let textFieldText = textfield.text {
                    item.text = textFieldText
                }
                if remindSwitch.isOn == true {
                    registNotification()
                    item.remindMode = true
                }
                item.checked = false
                item.date = datePicker.date
                delegate?.itemDetailViewController(self, didFinishAdding: item)
            }
        }
        
    }
    
    
    @IBAction func upDateTimePicker(_ sender: Any) {
        dueTime = datePicker.date
    }
    
    func updateTimeLable() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateTextFeild.text = formatter.string(from: datePicker.date)
    }
    
    
    func registNotification() {
        
        guard textfield.text != "" else {
            return
        }
        
        guard dueTime > Date.init() else {
            return
        }
        
        let notification = UNMutableNotificationContent()
        notification.title = "Remind:"
        notification.body = textfield.text!
        notification.sound = UNNotificationSound.default
        
        let calender = Calendar(identifier: .gregorian)
        let componets = calender.dateComponents([.month,.day,.hour,.minute], from: dueTime)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: componets, repeats: false)
        let request = UNNotificationRequest.init(identifier: "\(textfield.text!)", content: notification, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    
    func removeNotification(text:String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(text)"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueTime = Date.init()
        if let item = itemToEdit {
            title = "Edit Item"
            textfield.text = item.text
            removeNotification(text: item.text)
            if item.remindMode == true {
                remindSwitch.isOn = true
            }
            addBarButton.isEnabled = true
            datePicker.date = item.date
            updateTimeLable()
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textfield.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
        return true
    }
}
    




