//
//  MNProfessinalHomeVc.swift
//  Munka
//
//  Created by Amit on 26/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GLWalkthrough

class MNProfessinalHomeVc: UIViewController {
    weak var currentViewController: UIViewController?
    @IBOutlet weak var lblSlider: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var constraintLeadingSlideLable : NSLayoutConstraint!
    @IBOutlet weak var btnListView: UIButton!
    @IBOutlet weak var btnMapView: UIButton!
    
    @IBOutlet weak var vwBg: IBView!
   
    @IBOutlet weak var txtSearch: UITextField!
    
    var isListView: Bool = true
    var coachMarker:GLWalkThrough!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        btnListView.setTitleColor(UIColorFromRGB("#000000"), forState: .Normal)
//        btnMapView.setTitleColor(UIColorFromRGB("#7E8290"), forState: .Normal)
        
        btnListView.setTitleColor(UIColor.hexStringToUIColor(hex: "#000000"), for: .normal)
        btnMapView.setTitleColor(UIColor.hexStringToUIColor(hex: "#7E8290"), for: .normal)
        self.setLayoutAccordingToTapSelcetion(isSelectMap: isListView)
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.clickOnHomeNotification),
        name: NSNotification.Name(rawValue: "HomeNotification"),
        object: nil)
    }
    
   @objc private func clickOnHomeNotification(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.bool(forKey: "isDisplayIntroPage") {
            
            managePreview()
            UserDefaults.standard.set(false, forKey: "isDisplayIntroPage")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    @IBAction func actionOnListView(_ sender: Any) {
        btnListView.setTitleColor(UIColor.hexStringToUIColor(hex: "#000000"), for: .normal)
        btnMapView.setTitleColor(UIColor.hexStringToUIColor(hex: "#7E8290"), for: .normal)
           self.isListView = true
           setLayoutAccordingToTapSelcetion(isSelectMap: self.isListView)
       }
       @IBAction func actionOnMapView(_ sender: Any) {
        btnListView.setTitleColor(UIColor.hexStringToUIColor(hex: "#7E8290"), for: .normal)
        btnMapView.setTitleColor(UIColor.hexStringToUIColor(hex: "#000000"), for: .normal)
           self.isListView = false
           setLayoutAccordingToTapSelcetion(isSelectMap: self.isListView)
       }
       func setLayoutAccordingToTapSelcetion(isSelectMap: Bool) {
           
           if isListView {
               UIView.animate(withDuration: 0.3) {
                   self.constraintLeadingSlideLable.constant = self.btnListView.frame.origin.x
                   self.view.layoutIfNeeded()
               }
               self.currentViewController = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNListViewVC")
               self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
               self.addChild(self.currentViewController!)
               self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
               
           } else {
               
               UIView.animate(withDuration: 0.3) {
                   self.constraintLeadingSlideLable.constant = self.btnMapView.frame.origin.x
                   self.view.layoutIfNeeded()
               }
               self.currentViewController = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNMapViewVC")
               self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
               self.addChild(self.currentViewController!)
               self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
           }
       }
       func addSubview(subView:UIView, toView parentView:UIView) {
           parentView.addSubview(subView)
           var viewBindingsDict = [String: AnyObject]()
           viewBindingsDict["subView"] = subView
           parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
           parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
       }
    
}

extension MNProfessinalHomeVc{
    
    func managePreview(){
        coachMarker = GLWalkThrough()
        coachMarker.dataSource = self
        coachMarker.delegate = self
        coachMarker.show()
    }
}


extension MNProfessinalHomeVc: GLWalkThroughDelegate {
    func didSelectNextAtIndex(index: Int) {
        if index == 5 {
            coachMarker.dismiss()
        }
    }
    
    func didSelectSkip(index: Int) {
        coachMarker.dismiss()
    }
}

extension MNProfessinalHomeVc : GLWalkThroughDataSource{

    func getTabbarFrame(index:Int) -> CGRect? {
        if let bar = self.tabBarController?.tabBar.subviews {
            var idx = 0
            var frame:CGRect!
            for view in bar {
                if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                    print(view.description)
                    if idx == index {
                        frame =  view.frame
                    }
                    idx += 1
                }
            }
            return frame
        }
        return nil
    }
    
    func numberOfItems() -> Int {
        return 5
    }
    
    func configForItemAtIndex(index: Int) -> GLWalkThroughConfig {
        let tabbarPadding:CGFloat = Helper.shared.hasTopNotch ? 88 : 50
        let overlaySize:CGFloat = Helper.shared.hasTopNotch ? 60 : 50
        let leftPadding:CGFloat = Helper.shared.hasTopNotch ? 8 : 5
        let screenHeight = UIScreen.main.bounds.height
        switch index {
        case 0:
            guard let frame = getTabbarFrame(index: 0) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Inbox"
            config.subtitle = "Here you can explore chat list"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            
            return config
        case 1:
            guard let frame = getTabbarFrame(index: 1) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Calendar"
            config.subtitle = "Here you can explore Job list from the calendar"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomLeft
            return config
        case 2:
            guard let frame = getTabbarFrame(index: 2) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Munka"
            config.subtitle = "From this page you can post your jobs"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomCenter
            return config
        case 3:
            guard let frame = getTabbarFrame(index: 3) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Progress"
            config.subtitle = "Here you can see all running job progress"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomRight
            return config
        case 4:
            guard let frame = getTabbarFrame(index: 4) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "My Profile"
            config.subtitle = "Your Account details, Wallets, Settings"
            config.nextBtnTitle = "Finish"
            
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomRight
            return config
        default:
            return GLWalkThroughConfig()
        }
    }
}
