//
//  Utility.swift
//  Munka
//
//  Created by keshav on 14/10/23.
//  Copyright © 2023 Amit. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleLocation {

    var lat, lng: Double?
    var city, state, country, name, postalCode: String?

    func extractFromGooglePlcae(place: GMSPlace) -> GoogleLocation {
        self.lat = place.coordinate.latitude
        self.lng = place.coordinate.longitude
        self.city = place.name!
        self.state = place.addressComponents?.first(where: { $0.type == "administrative_area_level_1" })?.name
        self.country = place.addressComponents?.first(where: { $0.type == "country" })?.name
        self.postalCode = place.addressComponents?.first(where: { $0.type == "postal_code" })?.name
        self.city = place.addressComponents?.first(where: { $0.type == "locality" })?.name
        
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                print("Type :\(type ), data: \( addressComponent.name)")
            }
        }
        print("city: \(city), state: \(state), Country: \(country), code : \(postalCode)")
            
        self.name = self.getFullName()


        return self
    }

    private func getFullName() -> String {
        //return "\(String(describing: self.city)), \(String(describing: self.state)), \(String(describing: self.country))"
        return (self.city ?? "") + ", " + (self.state ?? "") + ", " + (self.country ?? "")
    }
}

