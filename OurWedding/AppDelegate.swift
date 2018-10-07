//
//  AppDelegate.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//
import UIKit
import GoogleSignIn
import Google
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging
import FTIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?
	var databaseRef: FIRDatabaseReference!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FIRApp.configure()
		checkIfUserIsLoggedIn()
	
		var configureError: NSError?
		GGLContext.sharedInstance().configureWithError(&configureError)
		assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
		GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self
		
		
		return true
	}

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			print(error.localizedDescription)
			return
		}
		let authentication = user.authentication
		let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
		
		FIRAuth.auth()?.signIn(with: credential) { (user, error) in
			print("User has been signed into Firebase")
			self.databaseRef = FIRDatabase.database().reference()
			
			let user_profile = FIRDatabase.database().reference().child("user_profiles").child(user!.uid)
			user_profile.observeSingleEvent(of: .value, with: { (snapshot) in
				let snapshot = snapshot.value as? NSDictionary
				if(snapshot == nil)
				{
					user_profile.child("name").setValue(user?.displayName)
					user_profile.child("email").setValue(user?.providerData[0].email)
					user_profile.child("photourl").setValue(user?.photoURL)
				}
			
				FTIndicator.dismissProgress()
				self.window!.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController")
			})
		}
		
	}
	
	func checkIfUserIsLoggedIn() {
		if FIRAuth.auth()?.currentUser?.uid != nil {
			let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let tabController = myStoryboard.instantiateViewController(withIdentifier: "TabController")
			self.window!.rootViewController = tabController
			
		}
		
		
	}
	
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		//Did disconnect
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		let checkGoogle =  GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
		return checkGoogle
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

