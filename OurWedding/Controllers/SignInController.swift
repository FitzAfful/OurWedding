//
//  ViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 13/06/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleSignIn
import FirebaseDatabase
import Google
import FTIndicator
import SystemConfiguration

class SignInController: UIViewController, GIDSignInUIDelegate {
	
	@IBOutlet weak var goButton: UIButton!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
	}
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
		if let error = error {
			print(error.localizedDescription)
			let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
			alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		FTIndicator.showProgress(withMessage: "Signing In...")
		let authentication = user.authentication
		let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
		self.moveToMain(credential)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func moveToMain(_ credential: FIRAuthCredential){
		let firebaseHelper = FirebaseHelper()
		firebaseHelper.signIn(credential: credential, viewController: self)
	}
	
	func moveToNavigationController(){
		let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let slideController = myStoryboard.instantiateViewController(withIdentifier: "TabController")
		self.present(slideController, animated: true, completion: {
			//self.dismiss(animated: true, completion: nil)
		})
	}
	
	
	
	@IBAction func goLogin(_ sender: Any) {
		GIDSignIn.sharedInstance().signIn()
	}
	
}


