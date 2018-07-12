<<<<<<< HEAD
=======

>>>>>>> 22313d7f50d0fcb5bf596903a126ae5a2aa21453

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
