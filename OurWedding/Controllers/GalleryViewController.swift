//
//  GalleryViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import DTPhotoViewerController
import Firebase
import Nuke
import INSPhotoGallery


class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout{
	
	let reuseIdentifier = "cell"
	var images:[String] = []
	@IBOutlet weak var loader: UIActivityIndicatorView!
	var user = FIRAuth.auth()?.currentUser
	let userProfiles = FIRDatabase.database().reference().child("posts")
	var photos: [INSPhotoViewable] = []
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: "HomepageCell", bundle:nil)
		self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
		
		
		let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		collectionView.collectionViewLayout = layout
	
		_ = self.userProfiles.observeSingleEvent(of: .value, with: { (snapshot) in
			self.images.removeAll()
			if let snapshotValue = snapshot.children.allObjects as? [FIRDataSnapshot]{
				for snapDict in snapshotValue{
					let dict = snapDict.value as! Dictionary<String, AnyObject>
					let post = Post()
					post.postid = Int.init(snapDict.key)!
					post.setValuesForKeys(dict)
					self.images.append(post.postimgurl)
				}
				self.images = self.images.reversed()
				self.photos.removeAll()
				for item in self.images{
					let photo = INSPhoto(imageURL: URL(string: item), thumbnailImage: UIImage(named: "gal-25.png")!)
					self.photos.append(photo)
				}
				self.collectionView.isHidden = false
				self.loader.isHidden = true
				self.collectionView.reloadData()
			}
		})
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		_ = self.userProfiles.observeSingleEvent(of: .value, with: { (snapshot) in
			self.images.removeAll()
			if let snapshotValue = snapshot.children.allObjects as? [FIRDataSnapshot]{
				for snapDict in snapshotValue{
					let dict = snapDict.value as! Dictionary<String, AnyObject>
					let post = Post()
					post.postid = Int.init(snapDict.key)!
					post.setValuesForKeys(dict)
					self.images.append(post.postimgurl)
				}
				self.images = self.images.reversed()
				self.photos.removeAll()
				for item in self.images{
					let photo = INSPhoto(imageURL: URL(string: item), thumbnailImage: UIImage(named: "logo2.png")!)
					self.photos.append(photo)
				}
				self.collectionView.isHidden = false
				self.loader.isHidden = true
				self.collectionView.reloadData()
			}
		})
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.images.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomepageCell
		Nuke.loadImage(with: URL(string: self.images[indexPath.item])!, into: cell.img)
		
		return cell
	}
	
	// MARK: - UICollectionViewDelegate protocol
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomepageCell
		let currentPhoto = photos[indexPath.row]
		let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
		self.present(galleryPreview, animated: true, completion: nil)
	}
	
	
	
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		//device screen size
		let width = UIScreen.main.bounds.size.width
		//calculation of cell size
		return CGSize(width: ((width / 3) - 15)   , height: ((width / 3) - 15))
	}
	
	
	
}


