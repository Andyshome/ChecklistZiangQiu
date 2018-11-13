import UIKit
import AZExpandable

class DelegateController: UITableViewController {
    
    private var expandableTable: ExpandableTable!
    private var expandedCell: ExpandedCellInfo?
    var myDelegate : delegate?
    @IBOutlet var myTableView: UITableView!
    var indexOfCell : Int?
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        myDelegate?.readData()
        myTableView.reloadData()
        navigationItem.leftBarButtonItem = editButtonItem
        
        CellFactory.registerCells(for: myTableView)
        expandableTable = ExpandableTable(with: tableView, infoProvider: self)
    }
    private func toggleItem(at indexPath: IndexPath) {
        guard expandedCell?.indexPath != indexPath else {
            expandableTable.unexpandCell()
            expandedCell = nil
            navigationItem.leftBarButtonItem?.isEnabled = true
            return
            
        } // Construct your cell here
        let cellType: ExpandedCellInfo.CellType = .custom { [weak self] indexPath -> (UITableViewCell) in
            let centeredCell = self?.tableView.dequeueReusableCell(withIdentifier: "CenteredLabelCell",for: indexPath) as! CenteredLabelCell
            centeredCell.configure(with: "\(delegate.delegateList[indexPath.row-1].checkNumberOfReminds()) reminds in this delegate")
            centeredCell.backgroundColor = .lightGray
            return centeredCell
        }
        navigationItem.leftBarButtonItem?.isEnabled = false
        let cell = ExpandedCellInfo(for: indexPath, cellType: cellType)
        expandedCell = cell
        expandableTable.expandCell(cell)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toggleItem(at: indexPath)
    }

    // MARK: - Table view data source
    required init?(coder aDecoder: NSCoder) {
        myDelegate = delegate()
        super.init(coder: aDecoder)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate.delegateList[indexPath.row].removeAllNotification()
        delegate.delegateList.remove(at: indexPath.row)
        myTableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return delegate.delegateList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customDetailDisclosureButton = UIButton.init(type: .infoLight)
        customDetailDisclosureButton.addTarget(self, action: #selector(DelegateController.accessoryButtonTapped(sender:)), for: .touchUpInside)

        let cell = tableView.dequeueReusableCell(withIdentifier: "CenteredLabelCell", for: indexPath) as! CenteredLabelCell
        cell.configure(with: delegate.delegateList[indexPath.row].checkListTitle)
        customDetailDisclosureButton.tag = indexPath.row
        cell.accessoryView = customDetailDisclosureButton
        
        
        return cell
    }
   @objc func accessoryButtonTapped(sender : UIButton) {
        indexOfCell = sender.tag
        performSegue(withIdentifier: "CheckDetail", sender: sender)
    
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveTodolist = delegate.delegateList.remove(at: sourceIndexPath.row)
        delegate.delegateList.insert(moveTodolist, at: destinationIndexPath.row)
        myTableView.reloadData()
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddDelegate" {
            if let myAddDelegateViewController = segue.destination as? AddDelegateViewController {
                myAddDelegateViewController.myDelegateClass = myDelegate
                myAddDelegateViewController.customDelegate = self
            }
        }else if segue.identifier == "CheckDetail" {
                if let detailViewController = segue.destination as? ChecklistViewController {
                    if let indexPath = indexOfCell{
                        let todoList = delegate.delegateList[indexPath]
                        detailViewController.todoList = todoList
                        detailViewController.delegate = self
                    }
                }
            }
            
        }

    }

extension DelegateController : AddDelegateViewControllerDelegate,ChecklistViewControllerDelegate {
    func returnMainList(_ controller: ChecklistViewController) {
        navigationController?.popViewController(animated: true)
    }
   
    
    func AddDelegateViewController(_ controller: AddDelegateViewController, didFinishAdding item: TodoList) {
        navigationController?.popViewController(animated: true)
        myTableView.reloadData()

    }
    
    func cancleAddDelegate(_ controller: AddDelegateViewController) {
        navigationController?.popViewController(animated: true)
    }
    

    
}
