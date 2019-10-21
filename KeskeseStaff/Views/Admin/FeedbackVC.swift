//
//  FeedbackVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/24/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import XLPagerTabStrip
import Alamofire

class FeedbackVC: UIViewController, UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable, IndicatorInfoProvider {
    

    @IBOutlet weak var emptyView: EmptyView!
    @IBOutlet weak var tableView: UITableView!
    var feedback = [FeedbackElem]()
    var refresh : UIRefreshControl!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : NSLocalizedString("Feedback", comment: ""))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(FeedbackVC.refreshPage), for: UIControl.Event.valueChanged)
        emptyView.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        
        tableView.addSubview(refresh)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getComment()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.emptyList()
        KeskeseStaff.emptyView(index: feedback.count, view: emptyView)
        return feedback.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = feedback[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell", for: indexPath) as! FeedBackCell
        animate(cell: cell)
        cell.dateLbl.text = data.date
        cell.commentLbl.text = "\(NSLocalizedString("Feedback", comment: "")) : \(data.comment)"
        cell.commentIndexLbl.text = String(data.table_number)
        cell.staffNameLbl.text = data.staff_name
        if data.phone != ""{
            cell.nameLbl.isHidden = false
            cell.nameLbl.text = "\(NSLocalizedString("Name", comment: "")) : \(data.name!)"
        } else {
            cell.nameLbl.isHidden = true
        }
       
        if data.phone != ""{
            cell.phoneLbl.isHidden = false
             cell.phoneLbl.text = "\(NSLocalizedString("Phone", comment: "")) : \(data.phone!)"
        } else {
            cell.phoneLbl.isHidden = true
        }
        
        feedbackSeen(seen: data.seen, bg: cell.BG, indexBG: cell.indexBG)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = feedback[indexPath.row]
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        let successFunc = {
            self.feedback[indexPath.row].seen = !data.seen
            self.tableView.reloadData()
            self.stopAnimating()
            
        }
        
        patchFeedback(seen: !data.seen, elemId: data.id).responseJSON{
                    (response) in
                    switch response.result {
                    case .success(_):
                        successFunc()
                        break
                        
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
    }
    
    func getComment(){
        activity.startAnimating()
        
        getFeedbackForSpot(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                var feedbackResp = response.data!.createList(type: FeedbackElem.self)
                
                
                    
                feedbackResp.sort(by: { !$0.seen && $1.seen})
                

                self.feedback.removeAll(keepingCapacity: false)
                for feed in feedbackResp{
                    self.feedback.append(feed)
                }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.refresh.endRefreshing()
                self.activity.stopAnimating()
                break
            case .failure(let error):
                self.refresh.endRefreshing()
                self.activity.stopAnimating()
                self.emptyView.internetProblrms(view: self.emptyView)
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    @objc func refreshPage(){
        getComment()
        emptyView.isHidden = true
    }

}
