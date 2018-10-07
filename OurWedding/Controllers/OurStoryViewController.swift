//
//  OurStoryViewController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit

class OurStoryViewController: UIViewController {

	@IBOutlet weak var carouselView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.carouselView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 250)
		self.carousel.frame = carouselView.frame
		self.carouselView.backgroundColor = UIColor.red
		self.carousel.backgroundColor = UIColor.blue
		self.carouselView.addSubview(carousel)
		
		print(carousel.frame)
		print(carouselView.frame)
		print(carousel.collectionView.frame)
    }
	
	let carousel : ZKCarousel = {
		let carousel = ZKCarousel()
		
		// Create as many slides as you'd like to show in the carousel
		let slide = ZKCarouselSlide(image: UIImage(named:"a3.jpg")!, title: "", description: "Our Love Story")
		let slide1 = ZKCarouselSlide(image: UIImage(named:"a1.jpg")!, title: "", description: "Together")
		let slide2 = ZKCarouselSlide(image: UIImage(named:"a4.jpg")!, title: "", description: "Our Love Journey")
		let slide3 = ZKCarouselSlide(image: UIImage(named:"a5.jpg")!, title: "", description: "Forever")
		
		// Add the slides to the carousel
		carousel.slides = [slide, slide1, slide2, slide3]
		
		return carousel
	}()

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
