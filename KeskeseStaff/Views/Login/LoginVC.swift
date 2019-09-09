//
//  LoginVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 7/31/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class LoginVC: UIViewController , NVActivityIndicatorViewable {

    @IBOutlet var RegObj: RegObj!
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    var staffType : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UI()
        // Do any additional setup after loading the view.
    }
    
    func UI(){
        mailTF.text = "test2@gmail.com"
        passTF.text = "1234567q"
        singleLine(view: mailTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
        singleLine(view: passTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
    }
    
    func goNext(){
        self.performSegue(withIdentifier: staffType, sender: self)
    }

    @IBAction func loginBtn(_ sender: Any) {
        
        
        defaults.set(12, forKey: "Age")
        
        let age = defaults.integer(forKey: "Age")
        
        print("age \(age)")
        
        
        
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        RegObj.mail = mailTF.text!
        RegObj.pass = passTF.text
        RegObj.view = self.view
        
        RegObj.getToketValue(completion: { (error) in})
//        if RegObj.goNext(){
        
//        }
    }
    
    
    @IBAction func changeUser(_ sender: Any) {
        mailTF.text = "vasil@vasil.vasil"
        passTF.text = "123123q"
        
    }
}
