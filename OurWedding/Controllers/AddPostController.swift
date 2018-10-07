//
//  AddPostController.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import DTPhotoViewerController
import FTIndicator
import SystemConfiguration

class AddPostController: UIViewController, UIImagePickerControllerDelegate,UIActionSheetDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var postTextField: MyTextField!
	let picker = UIImagePickerController()
	var image1 = 0
	var user = FIRAuth.auth()?.currentUser
	let userProfiles = FIRDatabase.database().reference().child("posts")
	
	override func viewDidLoad() {
        super.viewDidLoad()

		picker.delegate = self
		self.title = "Add Post"
		let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AddPostController.show(_:)))
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(tapGestureRecognizer)
    }
	
	@IBAction func addImage(_ sender: Any) {
		details(sender as AnyObject)
	}
	
	@IBAction func postImage(_ sender: Any) {
		if(postTextField.text?.isEmpty)!{
			FTIndicator.showToastMessage("Kindly enter text")
		}else if(image1 == 1){
			if(isConnectedToNetwork()){
				FTIndicator.setIndicatorStyle(UIBlurEffectStyle.dark)
				FTIndicator.showProgress(withMessage: "Uploading Image")
				//CHOOSE BETWEEN CLOUDINARY UPLOAD / FIREBASE UPLOAD
				//self.cloudinaryUpload()
				self.firebaseStorageUpload()
			}else{
				FTIndicator.showToastMessage("No Internet Connection. Please check and try again.")
			}
		}else{
			FTIndicator.showToastMessage("Kindly attach an image")
		}
	}
	
	func cloudinaryUpload(){
		let cloudinaryService = CloudinaryService(configUrl: "cloudinary://254856234963126:K4J4-SqINaM9K3Iuwt2dQRF7VCY@dpsqzxx6l")
		
		cloudinaryService.upload(image: imageView.image!, progressCallback: { (progress) in
			//handle progress
		}, completionCallback: { (uploadResponse) in
			print(uploadResponse)
			if(uploadResponse.success == true){
				self.doneUploading(url: uploadResponse.url!)
			}else{
				FTIndicator.dismissProgress()
				FTIndicator.showToastMessage("Unable to upload image. Please try again")
			}
		})
	}
	
	func firebaseStorageUpload(){
		let storageRef = FIRStorage().reference().child("images")
		let data = UIImageJPEGRepresentation(self.imageView.image!, 0.9)!
		let metadata1 = FIRStorageMetadata()
		metadata1.contentType = "image/jpeg"
		let riversRef = storageRef.child("\(randomString(length: 15)).jpg")
		_ = riversRef.put(data, metadata: metadata1) { (metadata, error) in
			guard metadata != nil else {
				print("First Error")
				print(error!)
				FTIndicator.dismissProgress()
				FTIndicator.showToastMessage("Unable to upload image. Please try again")
				return
			}
			riversRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					print("Second Error")
					FTIndicator.dismissProgress()
					FTIndicator.showToastMessage("Unable to upload image. Please try again")
					return
				}
				self.doneUploading(url: downloadURL.absoluteString)
			}
		}
	}
	
	@objc func show(_ sender:AnyObject) {
		if(imageView.image != nil){
			if let viewController = DTPhotoViewerController(referencedView: imageView, image: imageView.image) {
				self.present(viewController, animated: true, completion: nil)
			}
		}else{
			details(sender)
		}
	}
	
	
	func encodeImage(_ dataImage:UIImage) -> String{
		let imageData = UIImagePNGRepresentation(dataImage)
		return imageData!.base64EncodedString(options: [])
	}
	
	func details(_ sender:AnyObject) {
		
		let actionSheet:UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Take Picture","Choose Existing Photo")
		actionSheet.delegate = self
		actionSheet.tag = 2
		actionSheet.show(in: self.view)
	}
	
	func actionSheet( _ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
		
		if( buttonIndex == 1){
			self.shootPhoto()
		} else if(buttonIndex == 2){
			self.photoFromLibrary()
		} else {
			actionSheet.dismiss(withClickedButtonIndex: 3, animated: true)
		}
	}
	
	func doneUploading(url:String){
		print(url)
		let nr = (100 ... 200).randomInt
		let currentTimeStamp = Int(Date().toMillis()) + nr
		
		let user_profile = self.userProfiles.child("\(currentTimeStamp)")
		user_profile.observeSingleEvent(of: .value, with: { (snapshot) in
			let snapshot = snapshot.value as? NSDictionary
			if(snapshot == nil)
			{
				user_profile.child("message").setValue(self.postTextField.text!)
				user_profile.child("photourl").setValue(self.user?.photoURL!.absoluteString)
				user_profile.child("postimgurl").setValue(url)
				user_profile.child("username").setValue(self.user?.displayName!)
			}
			
			FTIndicator.dismissProgress()
			self.navigationController?.popToRootViewController(animated: true)
		})
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		imageView.image = image
		image1 = 1
		picker.dismiss(animated: true, completion: nil)
	}
	
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func noCamera(){
		let alertVC = UIAlertController(title: "No Camera", message:"Sorry, this device has no camera", preferredStyle: .alert)
		let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"OK"), style:.default, handler: nil)
		alertVC.addAction(okAction)
		present(alertVC, animated: true, completion: nil)
		
		
	}
	
	func photoFromLibrary() {
		picker.allowsEditing = true
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	func shootPhoto() {
		if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
			picker.allowsEditing = true
			picker.sourceType = UIImagePickerControllerSourceType.camera
			picker.cameraCaptureMode = .photo
			present(picker, animated: true, completion: nil)
		} else {
			noCamera()
		}
	}
}


