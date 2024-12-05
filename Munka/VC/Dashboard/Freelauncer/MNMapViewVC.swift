//
//  MNMapViewVC.swift
//  Munka
//
//  Created by Amit on 30/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
class MNMapViewVC: UIViewController {
    func tracingLocation(currentLocation: CLLocation) {
        
    }
    
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewListMap: UIView!
    @IBOutlet weak var lblJobTiltle: UILabel!
    @IBOutlet weak var lblFixed: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblPostedDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStartdate: UILabel!
    @IBOutlet weak var lblEnddate: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var viewPicker: UIView!
   
    var isselectedPin = false
    var strid = ""
    var mapMarkers : [GMSMarker] = []
    private let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
       // self.locationManager.requestWhenInUseAuthorization()
        
       // self.navigationController?.navigationBar.isHidden = true
       // LocationSingleton.sharedInstance.delegate = self
         // Do any additional setup after loading the view.
         placesClient = GMSPlacesClient.shared()
        // LocationSingleton.sharedInstance.startUpdatingLocation()
         print(MyDefaults().maplist.count)
       //  ShowHud(view: self.view)
    }
    override func viewDidLoad() {
          super.viewDidLoad()
          locationManager.requestWhenInUseAuthorization()
          var currentLoc: CLLocation!
          if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
          CLLocationManager.authorizationStatus() == .authorizedAlways) {
             currentLoc = locationManager.location
             print(currentLoc.coordinate.latitude)
             print(currentLoc.coordinate.longitude)
          let location = CLLocation(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
            self.mapView.isMyLocationEnabled = true
           self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
           let position = CLLocationCoordinate2D(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
           let locationmarker = GMSMarker(position: position)
           locationmarker.map = self.mapView
           
           self.mapView.delegate = self
           LocationSingleton.sharedInstance.stopUpdatingLocation()
           self.reloadMarker()

          // HideHud()
            HideHud(view: self.view)

        }
       }
    
    
//    func tracingLocation(currentLocation: CLLocation) {
//            self.convertLatLongToAddress(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//
//    }
//    func tracingLocationDidFailWithError(error: NSError) {
//
//    }
//    func convertLatLongToAddress(latitude:Double,longitude:Double){
//                let geoCoder = CLGeocoder()
//                let location = CLLocation(latitude: latitude, longitude: longitude)
//                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//                    // Place details
//                    var placeMark: CLPlacemark!
//                    placeMark = placemarks![0]
//                    var adressString : String = ""
//                    print(placeMark!)
//
//                   // self.strLaction = placeMark!.locality ?? ""
//                   // self.strsublocality = placeMark!.subLocality ?? ""
//                    // Location name
//
//                    // Street address
//                    if let street = placeMark.thoroughfare {
//                        print(street)
//                        adressString = adressString + placeMark.thoroughfare! + ", "
//                         print(adressString)
//                       // strStreet = street
//                    }
//                    if let locationName = placeMark.location {
//                        print(locationName)
//                        // strLaction = placeMark.location
//                        adressString = adressString + placeMark.subLocality! + ", "
//                        print(adressString)
//                    }
//                    // City
//                    if let city = placeMark.subAdministrativeArea {
//                        print(city)
//                         adressString = adressString + placeMark.subAdministrativeArea! + ", "
//                         print(adressString)
//                    }
//                    // Zip code
//                    if let zip = placeMark.isoCountryCode {
//                        print(zip)
//                       // adressString = adressString + placeMark.isoCountryCode! + ", "
//                         print(adressString)
//                    }
//                    // Country
//                    if let country = placeMark.country {
//                        print(country)
//                         print(adressString)
//                        adressString = adressString + placeMark.country! + ", "
//                    }
//                    if let sublocality = placeMark.subLocality {
//                        print(sublocality)
//                       // self.currentLocality = sublocality
//                         print(adressString)
//                    }
////                    self.lblAddress.text =  adressString
////                    MyDefaults().currentLocation = adressString
//                })
//               self.mapView.isMyLocationEnabled = true
//                self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//                let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                let locationmarker = GMSMarker(position: position)
//               // locationmarker.map = self.mapView
//
//                self.mapView.delegate = self
//                LocationSingleton.sharedInstance.stopUpdatingLocation()
//                self.reloadMarker()
//
//                HideHud(view: self.view)
//    }
    func reloadMarker() {
        for items in MyDefaults().maplist {
            let position = CLLocationCoordinate2D(latitude: Double(items.latitude)!, longitude: Double (items.longitude)!)
            let locationmarker = GMSMarker(position: position)
            locationmarker.map = self.mapView
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x:0, y:0, width:38, height:38));
            imageView.image = #imageLiteral(resourceName: "ic_places_marker_green")
            locationmarker.iconView = imageView
            locationmarker.userData = items
            self.mapMarkers.append(locationmarker)
        }
    }
    @IBAction func actionOnProcessDetail(_ sender: UIButton) {
              // let mapData = marker.userData as? ModelListViewDetail
               let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailFreelauncerVC") as! MNPostDetailFreelauncerVC
                   details.strJobId = strid
               self.navigationController?.pushViewController(details, animated: true)
       }
}
extension MNMapViewVC: GMSMapViewDelegate{
     func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        
//        lblFixed.text! = mapData.
//        lblDays.text! = mapData
//        lblPostedDate.text! = mapData
//        lblAddress.text! = mapData
//        lblStartdate.text! = mapData
//        lblEnddate.text! = mapData
//        lblMiles.text! = mapData
        
       
//        if  mapData?[marker].jobType == "Fixed" {
//             cell?.lblFix.text = "Fixed - " + self.listdetails[indexPath.row].budgetAmount  + "$"
//             cell?.lblHour.text = self.listdetails[indexPath.row].timeDuration + " " + "Days"
//         }else{
//             cell?.lblFix.text = "Hourly - " + self.listdetails[indexPath.row].budgetAmount  + "/h" + "$"
//             cell?.lblHour.text = self.listdetails[indexPath.row].timeDuration + " " + "Days"
//         }
//        let startDate = self.convertDateFormater(self.listdetails[indexPath.row].jobStartDate)
//         let startTime = self.convertTimeFormater(self.listdetails[indexPath.row].jobStartTime)
//         cell?.lblStartDate.text = startDate + "  " + startTime
//
//        let EndDateDate = self.convertDateFormater(self.listdetails[indexPath.row].jobEndDate)
//        let endTime = self.convertTimeFormater(self.listdetails[indexPath.row].jobEndTime)
//           cell?.lblEndDate.text = EndDateDate + "  " + endTime
//         cell?.lblTitle.text = self.listdetails[indexPath.row].jobTitle
//         cell?.lblAddress.text = self.listdetails[indexPath.row].jobLocation
        let mapData = marker.userData as? ModelListViewDetail
        if mapData !=  nil {
            
                   let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNPostDetailFreelauncerVC") as! MNPostDetailFreelauncerVC
                       details.strJobId = mapData!.id
                   self.navigationController?.pushViewController(details, animated: true)
        }
            
       
        
    }
           func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
               let customView = Bundle.main.loadNibNamed("ClientInfoView", owner: self, options: nil)?.first as? ClientInfoView
              //  customView?.imgMunka.image = UIImage.init(named: "ic_places_marker_green")
            
            let mapData = marker.userData as? ModelListViewDetail
            if mapData ==  nil {
                
            }else{
            if mapData?.jobType == "Fixed" {
                lblFixed.text = "Fixed - " + "$" + mapData!.budgetAmount  
                lblDays.text = mapData!.timeDuration + " " + "Days"
            }else{
                lblFixed.text = "hr - " + "$" + mapData!.budgetAmount
                lblDays.text = mapData!.timeDuration + " " + "Hourly"
            }
            
            let startDate = self.convertDateFormater1(mapData!.jobStartDate)
            let startTime = mapData!.jobStartDate.self.convertTimeFormater1(mapData!.jobStartTime)
             lblStartdate.text = startDate + "  " + startTime
             
            let EndDateDate = self.convertDateFormater1(mapData!.jobEndDate)
            let endTime = mapData!.jobEndTime.self.convertTimeFormater1(mapData!.jobEndTime)
               lblEnddate.text = EndDateDate + "  " + endTime
             lblJobTiltle.text = mapData!.jobTitle
             lblAddress.text = mapData!.jobLocation
            let createdDate = mapData!.created.self.convertDateFormaterForAll1(mapData!.created)
            // let createdDate = self.convertDateFormaterForAll(self.listdetails[indexPath.row].created)
             let date = createdDate[0]
             let time = createdDate[1]
             
             lblPostedDate.text = "Posted " + date + " " + time
             let doubleMiles = Double(mapData!.distance)!
             let get = String(format: "%.2f", doubleMiles)
             lblMiles.text  = get + " Miles"
             strid = mapData!.id

                if !isselectedPin {
                    isselectedPin = true
                    self.MoveUpPicker()
                }

            if mapData?.isSelectedwindow == false{
                mapData?.isSelectedwindow = true
               // self.setImageOnPin(mapdata: mapData!)
            }else{
               // mapData?.isSelectedwindow = false
            }
            }
            return customView
        }
    
    func setImageOnPin(mapdata:ModelListViewDetail) {
        
        if mapdata.isSelectedwindow == true{
            let position = CLLocationCoordinate2D(latitude: Double(mapdata.latitude)!, longitude: Double (mapdata.longitude)!)
            let locationmarker = GMSMarker(position: position)
            locationmarker.map = self.mapView
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x:0, y:0, width:38, height:38));
            imageView.image = #imageLiteral(resourceName: "ic_places_marker_black")
            locationmarker.iconView = imageView
            locationmarker.userData = mapdata
            self.mapMarkers.append(locationmarker)
        }else{
            let position = CLLocationCoordinate2D(latitude: Double(mapdata.latitude)!, longitude: Double (mapdata.longitude)!)
            let locationmarker = GMSMarker(position: position)
            locationmarker.map = self.mapView
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x:0, y:0, width:38, height:38));
            imageView.image = #imageLiteral(resourceName: "ic_places_marker_sea_green")
            locationmarker.iconView = imageView
            locationmarker.userData = mapdata
            self.mapMarkers.append(locationmarker)
        }
    }
    func MoveUpPicker()  {
        let xPosition = self.viewPicker.frame.origin.x
        //View will slide 20px up
        let yPosition = self.viewPicker.frame.origin.y - 142
        let height = self.viewPicker.frame.size.height
        let width = self.viewPicker.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            // self.viewPicker.frame = CGRectMake(xPosition, yPosition, height, width)
            self.viewPicker.frame = CGRect(x:xPosition, y:yPosition, width:width, height: height)
             
        })
    }
    func MoveDownPicker()  {
        let xPosition = self.viewPicker.frame.origin.x
        //View will slide 20px up
        let yPosition = self.viewPicker.frame.origin.y + 142
        let height = self.viewPicker.frame.size.height
        let width = self.viewPicker.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            // self.viewPicker.frame = CGRectMake(xPosition, yPosition, height, width)
            self.viewPicker.frame = CGRect(x:xPosition, y:yPosition, width:width, height: height)
            
        })
     }
}

   


