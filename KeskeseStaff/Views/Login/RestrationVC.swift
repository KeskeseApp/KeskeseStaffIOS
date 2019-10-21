//
//  RestrationVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 7/30/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Lottie

class RestrationVC: UIViewController {


    @IBOutlet var viewModel: ViewModelRegObj!
    @IBOutlet weak var imageBGView: UIView!
    @IBOutlet weak var imageBGAnimationView: AnimationView!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    var staffType : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreferenceUtils.clearData()
        UI()
    }
    
    func UI(){
//        passTF.text = "1234567q"
//        confirmPassTF.text = "1234567q"
//        NameTF.text = "test2"
//        mailTF.text = "test2@gmail.com"
        
        ProfileImg.setRounded()
       
        imageBGAnimationView.animation = Animation.named("profile")
        imageBGAnimationView.animationSpeed = 1.5
        imageBGAnimationView.play()
        singleLine(view: NameTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
        singleLine(view: mailTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
        singleLine(view: passTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
        singleLine(view: confirmPassTF, lineColor: UIColor.init(white: 33/100, alpha: 1))
    }
    
    func goNext(){
        self.performSegue(withIdentifier: staffType, sender: self)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        viewModel.pickImageCallback = { image in
            self.ProfileImg.image = image
        }
        viewModel.pickImage(viewController: self)
    }
    
    
    @IBAction func confirmRegBtn(_ sender: Any) {
        
        viewModel.mail = mailTF.text!
        viewModel.name = NameTF.text!
        viewModel.pass = passTF.text!
        viewModel.confirmPass = confirmPassTF.text!
        viewModel.view = self.view
        
        viewModel.chekData()
    }
    

}
