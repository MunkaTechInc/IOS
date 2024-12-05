//
//  HelpViewController.swift
//  RoyalTouch
//
//  Created by Harish on 27/12/16.
//  Copyright © 2016 Hitaishin. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataFoundView: UIView!
    var details = [ModelFAQDetail]()
    //MARK:- Property
    struct Section
    {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = true) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()

    //MARK:- View Controller Life Cycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //call API
        self.callServiceTermsConditionsAPI()
    }
    
    //MARK:- TableView Delegate And DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].collapsed!) ? 0 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header : CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "header") as! CommonTableViewCell
        header.contentView.backgroundColor = UIColor.clear
        header.checkMarkButton.tag = section
        let headerName : String = sections[section].name
        header.firstIconPrice.text = headerName
        
        header.checkMarkButton.addTarget(self, action: #selector(self.toggleCollapse(sender:)), for: .touchUpInside)
        
        if sections[section].collapsed == true
        {
            header.checkMarkButton.setImage(#imageLiteral(resourceName: "ic_down_gray"), for: .normal)
        }
        else
        {
            header.checkMarkButton.setImage(#imageLiteral(resourceName: "ic_up_gray"), for: .normal)
        }
        return header.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommonTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let strItem = sections[indexPath.section].items[indexPath.row]
      //  cell.secondIconPrice.text = "\(strItem)".htmlToString
        cell.secondIconPrice.text = strItem.htmlToString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let str : String = sections[section].name
        let height : CGFloat = Global.heightForView(str,font: UIFont(name: FontNames.Avenir.Medium, size: 16)!,width: ScreenSize.SCREEN_WIDTH - 50)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str : String = sections[indexPath.section].items[indexPath.row]
        let height : CGFloat = Global.heightForView(str,font: UIFont(name: FontNames.Avenir.Medium, size: 15)!,width: ScreenSize.SCREEN_WIDTH - 30)
        return height
    }
    @IBAction func actionOnBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Custom Button Action

    @IBAction func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed!
        
        // Reload section
        self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    
    func callServiceTermsConditionsAPI() {

         //   ShowHud()
ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["":""]
             debugPrint(parameter)
       
        HTTPService.callForPostApi(url:MNFAQAPI , parameter: parameter) { (response) in
                 debugPrint(response)

           //   HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
                    let response = ModelIndividualFAQ.init(fromDictionary: response as! [String : Any])
                    self.details = response.details
                       // self.setupUI()
                    for n in 0..<self.details.count {
                            self.sections.append(Section(name: self.details[n].question, items:[self.details[n].answer]))
                    }
                    self.tableView.reloadData()
                 } else if status == "4"
                 {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                 }
                 else
                 {
                     self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else
                {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
                
             }
        }

}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
