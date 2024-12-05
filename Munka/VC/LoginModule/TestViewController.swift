//
//  TestViewController.swift
//  Munka
//
//  Created by Amit on 12/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//     let yourHeaders: HTTPHeaders = [
//           "X-Access-Token": "dsfdsfdsf"
//       ]
//
//       Alamofire.upload(multipartFormData: { multipartFormData in
//
//           for (key, value) in parameter
//           {
//               multipartFormData.append(value.data(using: .utf8 )! , withName: key)
//           }
//           for videoData in VideoDataArray
//           {
//               if  videoData
//               {
//                   multipartFormData.append(videoData , withName: videoParameterName, fileName: "videoName.mp4", mimeType: "video/mp4")
//               }
//           }
//       }, to: "YourApiUrlHere", method: .post, headers : yourHeaders,
//               encodingCompletion: { encodingResult in
//                   switch encodingResult {
//                   case .success(let upload, _, _):
//                       print(upload.progress)
//
//                       upload.responseJSON {  response in
//
//                           if let JSON = response.result.value
//                           {
//                               print("JSON: \(JSON)")
//                       }
//                       break
//                   case .failure( _):
//                       }
//                   }
//           })
}
