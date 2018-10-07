//
//  OurStoryViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit

class OurStoryViewController: UITableViewController {

	@IBOutlet weak var carouselView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.carouselView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 250)
		self.carousel.frame = carouselView.frame
		self.carouselView.backgroundColor = UIColor.red
		self.carousel.backgroundColor = UIColor.blue
		self.carouselView.addSubview(carousel)
    }
	
	
	let carousel : ZKCarousel = {
		let carousel = ZKCarousel()
		
		let slide = ZKCarouselSlide(image: UIImage(named:"a3.jpg")!, title: "", description: "Our Love Story")
		let slide1 = ZKCarouselSlide(image: UIImage(named:"a1.jpg")!, title: "", description: "Together")
		let slide2 = ZKCarouselSlide(image: UIImage(named:"a4.jpg")!, title: "", description: "Our Love Journey")
		let slide3 = ZKCarouselSlide(image: UIImage(named:"a5.jpg")!, title: "", description: "Forever")
		
		carousel.slides = [slide, slide1, slide2, slide3]
		return carousel
	}()

}
