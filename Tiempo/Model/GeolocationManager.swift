//
//  GeolocationManager.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 28/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    let latitude : Double
    let longitude : Double
}

protocol GeolocationManagerDelegate {
    func geolocationManagerDidUpdateWithLocation(location: Coordinate)
    
}

typealias CityName = String

class GeolocationManager : NSObject {
    
    static var shared : GeolocationManager = GeolocationManager()
    var delegate : GeolocationManagerDelegate?
    private var completionHandler : ((Coordinate, CityName?) -> Void)?
    private var updatingLocation = false
    
    private var currentLocation: CLLocation? {
        didSet {
            if let lat = currentLocation?.coordinate.latitude, let long = currentLocation?.coordinate.longitude {
                
                self.stopReceivingLocationChanges()
                
                let coord = Coordinate(latitude: lat, longitude: long)
                self.delegate?.geolocationManagerDidUpdateWithLocation(location: coord)
                
                // attempt get the place name as a string
                lookUpCurrentLocation { (placemark) in
                    
                    if let city = placemark?.locality {
                        // if we have a city name from the geocoding send it in the completion handler
                        if let completion = self.completionHandler {
                            completion(coord, city)
                        }
                    } else {
                        // if there is no valid city name, pass nil to the second arg of the completion handler
                        if let completion = self.completionHandler {
                            completion(coord, nil)
                        }
                    }
                    
                    // reset the completion handler for next call
                    self.completionHandler = nil
                    
                }
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    private let locationManager = CLLocationManager()
    
    private func enableBasicLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager.requestWhenInUseAuthorization()
                break
            
            case .restricted, .denied:
                // Disable location features
                stopReceivingLocationChanges()
                break
            
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                if updatingLocation == true {
                    startReceivingLocationChanges()
                }
                break
        }
    }
    
    private func startReceivingLocationChanges() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            
            return
        }
        
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func stopReceivingLocationChanges() {
        locationManager.stopUpdatingLocation()
        updatingLocation = false
    }
    
    func getCurrentLocation(completion: @escaping (Coordinate, CityName?) -> Void ) {
        if CLLocationManager.locationServicesEnabled() {
            updatingLocation = true
            self.completionHandler = completion
            enableBasicLocationServices()
        } else {
            print("Location service not enabled")
        }
    }
    
    private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = currentLocation {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
}

extension GeolocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enableBasicLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        
        if updatingLocation == false { return }
        
        let lastLocation = locations.last!
        
        // check the time stamp on the location to make sure it's recent -- if it's within the last 10 minutes, that is sufficient
        if lastLocation.timestamp > Calendar.current.date(byAdding: .minute, value: -10, to: Date())! {
            
            // check horizontal accuracy is valid ie. not negative
            if lastLocation.horizontalAccuracy > 0 {
                currentLocation = lastLocation
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            stopReceivingLocationChanges()
            return
        }
        // Notify the user of any errors.
    }
}
