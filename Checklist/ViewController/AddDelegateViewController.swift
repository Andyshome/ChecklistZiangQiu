
import UIKit

protocol AddDelegateViewControllerDelegate : class {
    func cancleAddDelegate(_ controller: AddDelegateViewController)
    func AddDelegateViewController(_ controller: AddDelegateViewController, didFinishAdding item: TodoList)
}


class AddDelegateViewController: UITableViewController,UITextFieldDelegate {

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    weak var customDelegate : AddDelegateViewControllerDelegate?
    weak var myDelegateClass : delegate?
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    @IBAction func cancel(_ sender: Any) {
        print("exiting!")
        customDelegate?.cancleAddDelegate(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = myDelegateClass?.newDelegate() {
            if let text = textField.text {
                item.checkListTitle = text
            }
            print("exiting!")
            customDelegate?.AddDelegateViewController(self, didFinishAdding: item)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        return true
    }
    
    
    
}
