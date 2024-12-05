//
//  ViewAllJobsPopUps.swift
//  Munka
//
//  Created by Amit on 28/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol getJobType {
   
    func delegateJotType(strJob:String)
}
class ViewAllJobsPopUps: UIViewController {
 @IBOutlet weak var tblTyoe:UITableView!
    var delagate: getJobType!
     
    
    
    
    var jobType:[String] = ["All","Upcoming","In-Progress","Completed","Canceled","Rejected"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func touchOnView(_ sender: UIButton) {
           self.dismiss(animated: true, completion: nil)
       }
}
// MARK: - extension
extension ViewAllJobsPopUps: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobType.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ViewAllTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllTableViewCell", for: indexPath) as? ViewAllTableViewCell
        cell?.lblJobType.text = self.jobType[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = self.jobType[indexPath.row]
        if self.delagate != nil {
        self.dismiss(animated: true, completion: nil)
        self.delagate.delegateJotType(strJob: job)
        }
    
    }
    
}
