//
//  FirebaseHelper.swift
//  DriveHer
//
//  Created by Fitzgerald Afful on 04/11/2017.
//  Copyright © 2017 OasisWebsoft. All rights reserved.
//

import Foundation
import Alamofire
import Google
import Firebase
import FirebaseDatabase
import FTIndicator

class FirebaseHelper: NSObject {
	
	var user = FIRAuth.auth()?.currentUser
	let userProfiles = FIRDatabase.database().reference().child("user_profiles")
	
	func signIn(credential: FIRAuthCredential, viewController: SignInController){
		FIRAuth.auth()?.signIn(with: credential) { (user, error) in
			
			print(error.debugDescription)
			print("User Signed Into Firebase")
			
			if(error != nil){
				let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .actionSheet)
				alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
				viewController.present(alert, animated: true, completion: nil)
				
			}else{
				
				let user_profile = self.userProfiles.child(user!.uid)
				user_profile.observeSingleEvent(of: .value, with: { (snapshot) in
					let snapshot = snapshot.value as? NSDictionary
					if(snapshot == nil)
					{
						user_profile.child("name").setValue(user?.displayName)
						user_profile.child("email").setValue(user?.providerData[0].email)
						user_profile.child("photourl").setValue(user?.photoURL!.absoluteString)
						
						UserDefaults.standard.set(user?.displayName!, forKey: "username")
						UserDefaults.standard.set(user?.providerData[0].email!, forKey: "email")
						UserDefaults.standard.set(user?.photoURL!.absoluteString, forKey: "url")
					}
					
									print("Navigation Controller")
									FTIndicator.dismissProgress()
									viewController.moveToNavigationController()
				})
			}
		}
	}
	
	
}

