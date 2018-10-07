//
//  TabController.swift
//  Testimonies
//
//  Created by Fitzgerald Afful on 08/01/2017.
//  Copyright © 2017 Glivion. All rights reserved.
//

import UIKit

class TabController: UIViewController {
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet var buttons: [UIButton]!
	
	var postController: UINavigationController!
	var programController: UINavigationController!
	var galleryController: UINavigationController!
	var storyController: UINavigationController!
	
	var viewControllers: [UINavigationController]!
	var selectedIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		postController = storyboard.instantiateViewController(withIdentifier: "posts") as! UINavigationController
		programController = storyboard.instantiateViewController(withIdentifier: "program") as! UINavigationController
		galleryController = storyboard.instantiateViewController(withIdentifier: "gallery") as! UINavigationController
		storyController = storyboard.instantiateViewController(withIdentifier: "ourstory") as! UINavigationController
		
		viewControllers = [postController, programController, galleryController,storyController]
		
		buttons[selectedIndex].isSelected = true
		didPressTab(buttons[selectedIndex])
	}
	
	@IBAction func didPressTab(_ sender: UIButton) {
		let previousIndex = selectedIndex
		selectedIndex = sender.tag
		
		buttons[previousIndex].isSelected = false
		print("Prev: \(previousIndex)")
		print(sender.tag)
		print("shit-2")
		let previousVC = viewControllers[previousIndex]
		print("shit-1")
		previousVC.willMove(toParentViewController: nil)
		print("shit")
		previousVC.view.removeFromSuperview()
		print("shit1")
		previousVC.removeFromParentViewController()
		print("shit2")
		
		sender.isSelected = true
		print("shit3")
		let vc = viewControllers[selectedIndex]
		print("shit4")
		vc.view.frame = contentView.bounds
		print("shit5")
		contentView.addSubview(vc.view)
		print("shit6")
		vc.didMove(toParentViewController: self)
		print("shit7")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

