

import UIKit
import Firebase


class TaskListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties
  var items: [TaskItem] = []
  var user: User!
//  var userCountBarButtonItem: UIBarButtonItem!
  
  
  let currUser = Auth.auth().currentUser!
  let ref = Database.database().reference(withPath: "task-items")
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    let usersRef = Database.database().reference().child("task-items").child(currUser.uid)
    
//    userCountBarButtonItem.tintColor = UIColor.white
//    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    
    usersRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
      var newItems: [TaskItem] = []
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
          let taskItem = TaskItem(snapshot: snapshot) {
          newItems.append(taskItem)
        }
      }
      
      self.items = newItems
      self.tableView.reloadData()
    })
    
   /* Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = User(authData: user)
      
      let currentUserRef = self.usersRef.child(self.user.uid)
      currentUserRef.setValue(self.user.email)
      currentUserRef.onDisconnectRemoveValue()
    } */
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    
//    navigationController?.navigationBar.prefersLargeTitles = true
    }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! RoundTaskTableViewCell
    let taskItem = items[indexPath.row]
    
    cell.titleLabel.text = taskItem.name
    cell.descLabel.text = "Due: \(taskItem.dueDate) \n\(taskItem.description)"
    
    cell.roundView.layer.cornerRadius = 8
    cell.roundView.layer.masksToBounds = true
    
    
    toggleCellCheckbox(cell, isCompleted: taskItem.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let taskItem = items[indexPath.row]
      taskItem.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let taskItem = items[indexPath.row]
    let toggledCompletion = !taskItem.completed
    toggleCellCheckbox(cell as! RoundTaskTableViewCell, isCompleted: toggledCompletion)
    taskItem.ref?.updateChildValues([
      "completed": toggledCompletion
      ])
  }
  
  func toggleCellCheckbox(_ cell: RoundTaskTableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.titleLabel.textColor = UIColor(red: 39/255, green: 164/255, blue: 238/255, alpha: 1.0)
      cell.descLabel.textColor = UIColor(red: 132/255, green: 130/255, blue: 144/255, alpha: 1.0)
    } else {
      cell.accessoryType = .checkmark
      cell.titleLabel.textColor = .gray
      cell.descLabel.textColor = .gray
    }
  }
    

  
  // MARK: Add Item  
  @IBAction func unwindfromComposeVC(_ sender: UIStoryboardSegue) {
    if sender.source is ComposeViewController{
        if let senderVC = sender.source as? ComposeViewController{
            
            let text = senderVC.newTaskName!
            let taskItem = TaskItem(name: senderVC.newTaskName,
                                    completed: false,
                                    description: senderVC.descText,
                                    dueDate: senderVC.dueDate)
            //                                   addedByUser: self.user.email,
            
            let taskItemRef = self.ref.child(currUser.uid).child(text.lowercased())
            
            taskItemRef.setValue(taskItem.toAnyObject())
        }
    }
    
  }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            presentingViewController?.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
    }
    

}
