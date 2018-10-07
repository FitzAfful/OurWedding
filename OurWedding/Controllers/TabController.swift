//
//  TabController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 08/01/2017.
//  Copyright © 2017 Glivion. All rights reserved.
//

import UIKit

class TabController: UIViewController {
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet var buttons: [UIButton]!
	
	var postController: UINavigationController!
	var galleryController: UINavigationController!
	var storyController: UINavigationController!
	
	var viewControllers: [UINavigationController]!
	var selectedIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		postController = storyboard.instantiateViewController(withIdentifier: "posts") as! UINavigationController
		galleryController = storyboard.instantiateViewController(withIdentifier: "gallery") as! UINavigationController
		storyController = storyboard.instantiateViewController(withIdentifier: "ourstory") as! UINavigationController
		
		viewControllers = [postController, galleryController,storyController]
		
		buttons[selectedIndex].isSelected = true
		didPressTab(buttons[selectedIndex])
	}
	
	@IBAction func didPressTab(_ sender: UIButton) {
		let previousIndex = selectedIndex
		selectedIndex = sender.tag
		
		buttons[previousIndex].isSelected = false
		let previousVC = viewControllers[previousIndex]
		previousVC.willMove(toParentViewController: nil)
		previousVC.view.removeFromSuperview()
		previousVC.removeFromParentViewController()
		
		sender.isSelected = true
		let vc = viewControllers[selectedIndex]
		vc.view.frame = contentView.bounds
		contentView.addSubview(vc.view)
		vc.didMove(toParentViewController: self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}

