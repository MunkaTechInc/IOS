//
//  WelcomePopupVC.swift
//  Munka
//
//  Created by Amit on 06/11/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import UIKit
protocol GetUserType {
    func DelegateUserType(UserType:Int)
}
class WelcomePopupVC: UIViewController {
    var delagate: GetUserType!
    var isUpdateImage : Bool = false
    @IBOutlet weak var profileImage: UIImageView!
    var arrayProfileImage: [UIImage] = []
    // var dictPhoto =  [String:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    appDelegate().apparrayProfileImage  = [UIImage]()
    }
     @IBAction func touchOnView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionOnUserImage(_ sender: UIButton) {
    self.view.endEditing(true)
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.image = image
            self.arrayProfileImage.append(image)
            self.isUpdateImage = true
            //self.dictPhoto.updateValue(image, forKey: "profile_pic")
            //MyDefaults().swifarrayImages.append(image)
            appDelegate().apparrayProfileImage.append(image)
        }
    }
    @IBAction func actionOnUserType(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        switch sender.tag {
        case 101:
            // executable code
            MyDefaults().swiftUserType = "Individual"
           // self.performSegue(withIdentifier: SegueIdentifier.kkLoginToSignUp, sender: self)
           
            if !isUpdateImage {
               self.showAlert(title: ALERTMESSAGE, message: "Please select profile image.")
            }else{
                if self.delagate != nil {
                self.dismiss(animated: false, completion: nil)
                self.delagate.DelegateUserType(UserType: 101)
                }
            }
           
        case 102:
            // executable code
            MyDefaults().swiftUserType = "Professional"
            if !isUpdateImage {
               self.showAlert(title: ALERTMESSAGE, message: "Please select profile image.")
            }else{
                if self.delagate != nil {
                self.dismiss(animated: false, completion: nil)
                self.delagate.DelegateUserType(UserType: 102)
                }
            }
        default:
            // executable code
            break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
