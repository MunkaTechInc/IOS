//
//  HTTPService.swift
//  Fleet Management
//
//  Created by iMac on 30/10/17.
//  Copyright © 2017 iMac. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class HTTPService {
    
    //Mark: Method for call "Post" type Api's
    
    class func callForPostApi(url: String, parameter: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        print("url = " , url)
        print("Apikey = " , AppSecureKey.APIKey)
        AF.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: HTTPHeaders(headerDict)).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response: \(value)")
                completionHandler(value as AnyObject)
            case .failure(let error):
                print("Error: \(error)")
                completionHandler(response as AnyObject)
            }
        }
    }
    
    //Mark: Method for call "Get" type Api's with passing perameters
    
    class func callForGetWithParameterApi(url: String, parameter: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        print("url = " , url)

        AF.request(url, method:.get, parameters : parameter).responseJSON(completionHandler: { response in
            
            switch(response.result) {
                
            case .success(let value):
                debugPrint(value)
                completionHandler(value as AnyObject)
                break
            case .failure(_):
                completionHandler(response as AnyObject)
                break
            }
        })
        
    }
    
    //Mark: Method for call "Get" type Api's without perameters
    
    class func callForGetApi(url: String, completionHandler: @escaping (AnyObject) -> Void) {
        print("url = " , url)
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        AF.request(url, method: .get, headers: HTTPHeaders(headerDict)).responseJSON { response in
            
            switch(response.result) {
            case .success(let value):
                    debugPrint(value)
                    completionHandler(value as AnyObject)
                break
            case .failure(_):
                completionHandler(response as AnyObject)
                break
            }
        }
    }
    
    class func callForUploadMultipleImage(url: String,fileName:[String], imageToUpload: [UIImage], parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        
        AF.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            for i in 0..<imageToUpload.count {
                let image = imageToUpload[i]
                let name = fileName[i]
                let imageData: Data = image.jpegData(compressionQuality: 0.5)!
                multipartFormData.append(imageData, withName: name, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "file")
            }
            
            print(multipartFormData)
            
        }, to: url,headers:HTTPHeaders(headerDict)).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
                completionHandler(value as AnyObject)
            case .failure(let error):
                print("failed")
                print(error)
                completionHandler(response as AnyObject)
            }
        }
    }
    
    class func callForProfessinalUploadMultipleImage(url: String,imageToUpload: [[String : Any]], parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        print(url)
        print(parameters)

        AF.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            for i in 0..<imageToUpload.count {
                let dict = imageToUpload[i]
                let fileType = dict["type"] as! String
                if fileType == "image"{
                    let dict = imageToUpload[i]
                    let image = dict["png"] as! UIImage
                    let name = dict["uploadfile"] as! String
                    let imageData: Data = image.jpegData(compressionQuality: 0.5)!
                    multipartFormData.append(imageData, withName: name, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "file")
                }else{
                    let dict = imageToUpload[i]
                    let urlUpload = dict["url"] as! URL
                    let name = dict["uploadfile"] as! String
                    multipartFormData.append(urlUpload, withName: name)
                }
            }
            
            
            print(multipartFormData)
            
        }, to: url,headers:HTTPHeaders(headerDict)).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
                completionHandler(value as AnyObject)
            case .failure(let error):
                print("failed")
                print(error)
                completionHandler(response as AnyObject)
            }
        }
    }
    
    
    //MARK:- Upload Doc Chat
    
    class func callForUploadDoc(url: String,imageToUpload: [[String : Any]], parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        AF.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            for i in 0..<imageToUpload.count {
                let dict = imageToUpload[i]
                let fileType = dict["type"] as! String
                if fileType == "image"{
                    let dict = imageToUpload[i]
                    let image = dict["png"] as! UIImage
                    let name = dict["uploadfile"] as! String
                    let imageData: Data = image.jpegData(compressionQuality: 0.5)!
                    multipartFormData.append(imageData, withName: name, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "file")
                }else{
                    let dict = imageToUpload[i]
                    let urlUpload = dict["url"] as! URL
                    let name = dict["message"] as! String
                    multipartFormData.append(urlUpload, withName: name)
                }
            }
            
            
            print(multipartFormData)
            
        }, to: url,headers:HTTPHeaders(headerDict)).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
                completionHandler(value as AnyObject)
            case .failure(let error):
                print("failed")
                print(error)
                completionHandler(response as AnyObject)
            }
        }
    }
    
    
    
    
    //MARK:- Upload Multiple Image Documents
    class func callForUploadMultipleImage(url: String,imageParameter:String ,imageToUpload: UIImage, parameters: [String: Any], completionHandler: @escaping (AnyObject) -> Void) {
        let headerDict : [String: String] = ["Apikey" : AppSecureKey.APIKey]
        AF.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            let image = imageToUpload
            let imageData = image.jpegData(compressionQuality: 0.5)!
            
            multipartFormData.append(imageData, withName: imageParameter, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "file")
            
            print(multipartFormData)
            
        }, to: url,headers:HTTPHeaders(headerDict)).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
                completionHandler(value as AnyObject)
            case .failure(let error):
                print("failed")
                print(error)
                completionHandler(response as AnyObject)
            }
        }
    }
}
