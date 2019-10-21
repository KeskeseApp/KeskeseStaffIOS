//
//  ProfileVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/16/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class ProfileVC: UIViewController, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var workPlaceLbl: UILabel!
    @IBOutlet weak var statysLbl: UILabel!
    
    var imagePicker = UIImagePickerController()
    var pickImageCallback : ((UIImage) -> ())?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        var avatar_url: URL

        if staff.img != nil && staff.img != ""{
            avatar_url = URL(string: staff.img!)!
            profileImage.kf.setImage(with: avatar_url)
        } else {
            profileImage.image = nil
        }
        
        userData()
        switch staff.spot_status! {
        case "\(SPOT_STATUSES.ON_SHEDULE)":
//            self.onShiftSwitch.isOn = true
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = true
                tabArray[1].isEnabled = true
            }
        case "\(SPOT_STATUSES.NOT_ON_SHEDULE)":
//            self.onShiftSwitch.isOn = false
            
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = false
                tabArray[1].isEnabled = false
                
            }
            
        default:
            print("Star")
        }
        
    }
    @IBAction func profileImageBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            profileImage.image = image
            let url = "\(ALL_STAFF)\(staff.id!)/"
            let imgData = image.jpegData(compressionQuality: 0.9)

//            let parameters = ["img" : imgData!] //Optional for extra parameter

            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData!, withName: "img", fileName: "file.jpg", mimeType: "image/jpg")
//                for (key, value) in parameters {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                } //Optional for extra parameters
            },
                             to: url, method: .patch, headers: header)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        print(response.result.value)
                    }

                case .failure(let encodingError):
                    print(encodingError)
                }
            }
            
        self.dismiss(animated: true, completion: nil)
        }
        
    }

    func userData(){
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        nameLbl.text = staff.name
        codeLbl.text = staff.code
        if spot != nil{
            workPlaceLbl.text = "\(NSLocalizedString("Job", comment: "")) : \(spot.name_other)"
            statysLbl.text = "\(NSLocalizedString("Status", comment: "")) : \(userType!)"
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = true
                tabArray[1].isEnabled = true
            }
        } else {
            workPlaceLbl.text = "\(NSLocalizedString("Job", comment: "")) : -"
            statysLbl.text = "\(NSLocalizedString("Status", comment: "")) : -"
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = false
                tabArray[1].isEnabled = false
                
            }
        }
        
    }
}
