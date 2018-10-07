//
//  PostsViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Nuke
import FTIndicator
import DTPhotoViewerController

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var tableView: UITableView!
	var user = FIRAuth.auth()?.currentUser
	let userProfiles = FIRDatabase.database().reference().child("posts")
	var posts = [Post]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.isHidden = true
		self.loader.isHidden = false
		self.tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
        _ = self.userProfiles.observeSingleEvent(of: .value, with: { (snapshot) in
			self.posts.removeAll()
			if let snapshotValue = snapshot.children.allObjects as? [FIRDataSnapshot]{
				for snapDict in snapshotValue{
					let dict = snapDict.value as! Dictionary<String, AnyObject>
					let post = Post()
					post.postid = Int.init(snapDict.key)!
					post.setValuesForKeys(dict)
					self.posts.append(post)
					
				}
				self.posts = self.posts.reversed()
				self.tableView.isHidden = false
				self.loader.isHidden = true
				self.tableView.reloadData()
			}
		})
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		_ = self.userProfiles.observeSingleEvent(of: .value, with: { (snapshot) in
			self.posts.removeAll()
			if let snapshotValue = snapshot.children.allObjects as? [FIRDataSnapshot]{
				for snapDict in snapshotValue{
					let dict = snapDict.value as! Dictionary<String, AnyObject>
					let post = Post()
					post.postid = Int.init(snapDict.key)!
					post.setValuesForKeys(dict)
					self.posts.append(post)
					
				}
				self.posts = self.posts.reversed()
				self.tableView.isHidden = false
				self.loader.isHidden = true
				self.tableView.reloadData()
			}
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func logOut(_ sender: Any) {
		do {
			try FIRAuth.auth()?.signOut()
			let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let slideController = myStoryboard.instantiateViewController(withIdentifier: "SignInController")
			self.present(slideController, animated: true, completion: {
				//self.dismiss(animated: true, completion: nil)
			})
		}catch {
			
		}
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : HomeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
		
		let contact : Post = posts[indexPath.row]
		cell.postLabel.text = contact.message
		cell.userLabel.text = contact.username
		
		cell.userImageView.image = nil
		cell.postImageView.image = nil
		print(contact.postimgurl)
		Nuke.loadImage(with: (URL(string: contact.photourl)!), into: cell.userImageView)
		makingRoundedImageProfileWithRoundedBorder(imageView: cell.userImageView)
		Nuke.loadImage(with: (URL(string: contact.postimgurl)!), into: cell.postImageView)
		
		cell.selectionStyle = .none
		return cell
	}
	
	
	fileprivate func makingRoundedImageProfileWithRoundedBorder(imageView: UIImageView) {
		imageView.layer.cornerRadius = imageView.frame.height / 2
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 0
		imageView.layer.borderColor = UIColor.white.cgColor
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 307.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell: HomeCell = tableView.cellForRow(at: indexPath) as! HomeCell
		let contact : Post = posts[indexPath.row]
		if let viewController = DTPhotoViewerController(referencedView: cell.postImageView, image: cell.postImageView.image) {
			self.present(viewController, animated: true, completion: {
				FTIndicator.showToastMessage(contact.message)
			})
		}
	}
	
	class Post: NSObject {
		var postid: Int = 0
		var postimgurl: String = ""
		var message: String = ""
		var photourl: String = ""
		var username: String = ""
	}

}
