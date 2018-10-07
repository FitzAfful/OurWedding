//
//  GalleryViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2017 oasiswebsoft. All rights reserved.
//

import UIKit
import DTPhotoViewerController

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout{
	
	let reuseIdentifier = "cell"
	var images = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jgp","7.jgp","8.jgp","9.jgp","10.jgp","11.jgp","12.jgp","13.jgp","a1.jpg","a2.jpg","a3.jpg","a4.jpg","a5.jpg"]
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: "HomepageCell", bundle:nil)
		self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
		
		
		let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		collectionView.collectionViewLayout = layout
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.images.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomepageCell
		cell.img.image = UIImage(named: self.images[indexPath.item])
		
		
		return cell
	}
	
	// MARK: - UICollectionViewDelegate protocol
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// handle tap events
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomepageCell
		if let viewController = DTPhotoViewerController(referencedView: cell.img, image: UIImage(named: self.images[indexPath.item])) {
			self.present(viewController, animated: true, completion: nil)
		}
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


