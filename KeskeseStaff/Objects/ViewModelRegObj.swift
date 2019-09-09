//
//  ViewModelRegObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/1/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewModelRegObj: NSObject {

    var view : UIView!
    var mail : String!
    var name : String!
    var pass : String!
    var confirmPass : String!
    var compleate : Bool!
    
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
            view.makeToast("Все данные введены верно")
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
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
}
