//
//  RootForTableVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/21/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RootForTableVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var buttonBar: ButtonBarView!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 0)
        settings.style.buttonBarItemBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 0)
        settings.style.selectedBarBackgroundColor = .init(red: 1, green: 143/255, blue: 0, alpha: 1)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 18, weight: UIFont.Weight.light)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .init(white: 50/100, alpha: 1)
            newCell?.label.textColor = UIColor.init(red: 1, green: 143/255, blue: 0, alpha: 1)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
            let cell1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TablesVC") as! TablesVC
        let cell2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTablesVC") as! MyTablesVC
        
        
        return [cell1, cell2]
        
    }
    
}
