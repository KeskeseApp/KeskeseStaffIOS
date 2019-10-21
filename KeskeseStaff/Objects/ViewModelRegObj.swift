//
//  ViewModelRegObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/1/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON

class ViewModelRegObj: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var view : UIView!
    var mail : String!
    var name : String!
    var pass : String!
    var confirmPass : String!
    var compleate : Bool!
    @IBOutlet weak var View: RestrationVC!
    
    var selectedImage: UIImage? = nil
    var imageSourceController: UIViewController!
    var imagePicker = UIImagePickerController()
    var pickImageCallback : ((UIImage) -> ())?;
    
    func chekData(){
        notEmpty(name: name)
    }
    
    
    func notEmpty(name: String){
        
        let res = name.count != 0
        if res{
            isValidEmail(email: mail)
        } else{
            view.makeToast("Имя не может быть пустым")
        }
    }
    
    func isValidEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let res = emailTest.evaluate(with: email)
        if res{

            isValidPass(pass: pass)
        } else{
            view.makeToast("Почта введена неправильно")
            
        }
    }
    
    func hasLetters(pass: String) -> Bool{
        let letters = NSCharacterSet.letters
        
        let range = pass.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if let test = range {
            print(test)
            print("letters found")
            isMatching(pass: pass, conf: confirmPass)
            return true
        }
        else {
            print("letters not found")
            return false
        }
    }
    
    func isValidPass(pass: String){
        if pass.count >= 6 && hasLetters(pass: pass){
            
        } else{
            view.makeToast("Пароль должен содержать миннимум 6 символов и хотя бы одну букву")
            
        }
    }
    
    func isMatching(pass: String, conf: String){
        let res = pass == conf
        if res{
            registerUser()
        } else{
            view.makeToast("Пароли не совпадают")
            
        }
    }
    
    func registerUser(){
        print(mail!)
        KeskeseStaff.registerUser(username: mail!, pass: pass!, first_name: name!).responseJSON { (response) in
        
            switch response.result {
            case .success(let value):
                print(value)
                self.getToketValue(completion: { (error) in})
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getToketValue(completion: @escaping (_ error: NSError?) -> Void) {
        
        getToken(username: mail!, pass: pass!).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                if jsonData["token"] != JSON.null{
                    PreferenceUtils.token = jsonData["token"].string!
                    self.getUser()
                    
                } else {
                    
                    print(value)
                    self.view.makeToast("Уже есть пользыватель с такой почтой")
                    
                }
                break
            case .failure(let error):
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    
    func getUser(){
        KeskeseStaff.getUser(username: mail!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                user = response.data!.createList(type: ElementUser.self)[0]
                user.password = self.pass
                self.getStaff(userId: user.id!)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getStaff(userId : Int){
        KeskeseStaff.getStaff(userID: userId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                let staffResp = response.data!.createList(type: StaffSpotUser.self)
                if !staffResp.isEmpty{
                    staff = staffResp[0].staff
                    spot = staffResp[0].spot
                    
                    self.staffType(type: staff.staff_status!)
                    
                    self.patchStaffPhoto()
                    
                } else {
                    
                }
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func pickImage(viewController: UIViewController){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            self.imageSourceController = viewController
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.imageSourceController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            self.selectedImage = image
            pickImageCallback?(image)
            
            self.imageSourceController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func patchStaffPhoto(){
        if self.selectedImage == nil{
            self.postFcmDevice()
            return
        }
        let url = "\(ALL_STAFF)\(staff.id!)/"
        let imgData = self.selectedImage!.jpegData(compressionQuality: 0.9)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "img", fileName: "file.jpg", mimeType: "image/jpg")
        },
                         to: url, method: .patch, headers: header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    self.postFcmDevice()
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func postFcmDevice(){
        KeskeseStaff.postFcmDevice(name: user.first_name!,
                                   userId: user.id!,
                                   fcmToken: Messaging.messaging().fcmToken!).responseJSON { (response) in
                                    switch response.result {
                                    case .success(let value):
                                        print(value)
                                        self.saveData()
                                        self.View.goNext()
                                        break
                                    case .failure(let error):
                                        self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                        print(error)
                                        break
                                    }
        }
    }
    
    func saveData(){
        PreferenceUtils.username = self.mail
        PreferenceUtils.password = self.pass
    }
    
    
    func staffType(type : String){
        print(type)
        if type == "\(STAFF_STATUSES.ADMIN)"{
            View.staffType = "regToAdmin"
            userType = NSLocalizedString("Admin", comment: "")
        } else if type == "\(STAFF_STATUSES.WAITER)"{
            View.staffType = "regToWaiter"
            userType = NSLocalizedString("Waiter", comment: "")
        }
    }
    
}
