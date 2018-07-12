
import Foundation
import Firebase

struct TaskItem {
  
  let ref: DatabaseReference?
  let key: String
  let name: String
//let addedByUser: String
  var completed: Bool
  let description: String
    let dueDate: String
//var date: Date
  
    init(name: String, completed: Bool, key: String = "", description: String, dueDate: String) {
    self.ref = nil
    self.key = key
    self.name = name
//    self.addedByUser = addedByUser
    self.completed = completed
    self.description = description
    self.dueDate = dueDate
        
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      
      let name = value["name"] as? String,
//      let addedByUser = value["addedByUser"] as? String,
      let description = value["description"] as? String,
      let dueDate = value["dueDate"] as? String,
      let completed = value["completed"] as? Bool else {
      return nil
    }
    
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
//    self.addedByUser = addedByUser
    self.completed = completed
    self.description = description
    self.dueDate = dueDate
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
//      "addedByUser": addedByUser,
      "completed": completed,
      "description": description,
      "dueDate": dueDate
    ]
  }
}
