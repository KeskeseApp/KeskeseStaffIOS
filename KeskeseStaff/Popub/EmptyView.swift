//
//  EmptyView.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/17/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var reloadBtn: UIButton!
    
    typealias reload = ()  -> Void
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func emptyList(){
            mainLabel.text = NSLocalizedString("The list is empty", comment: "")

    }
    
    func internetProblrms(view : UIView){
        mainLabel.text = NSLocalizedString("Internet problems", comment: "")
        view.isHidden = false
    }
    
    
    @IBAction func reloadBtn(_ sender: Any) {

    }
    
}
