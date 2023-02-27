//
//  LocationService.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import Foundation
import CoreLocation

protocol LocationServiceObserver: AnyObject {
    func authorizationStatusChanged()
    func didUpdateLocations(newLocation: String)
}

final class LocationWeakObserver {
    weak var observer: LocationServiceObserver?
    
    init(observer: LocationServiceObserver) {
        self.observer = observer
    }
}

final class LocationService: NSObject {
    
    private var observers: [LocationWeakObserver]
    private var manager: CLLocationManager?
    
    var isLocationAccessGranted: Bool {
        manager?.authorizationStatus == .authorizedWhenInUse || manager?.authorizationStatus == .authorizedAlways
    }
    
    override init() {
        manager = CLLocationManager()
        observers = []
        super.init()
        manager?.delegate = self
        if isLocationAccessGranted {
            manager?.requestLocation()
        }
    }
    
    func requestAuthorization() {
        guard manager?.authorizationStatus == .notDetermined else { return }
        manager?.requestWhenInUseAuthorization()
    }
    
    func addObserver(_ observer: LocationServiceObserver) {
        guard observers.contains(where: { $0.observer === observer }) == false else { return }
        observers.append(LocationWeakObserver(observer: observer))
    }
    
    func removeObserver(_ observer: LocationServiceObserver) {
        observers.removeAll(where: { $0.observer === observer })
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        observers.forEach {
            $0.observer?.authorizationStatusChanged()
        }
        if isLocationAccessGranted {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update locations")
        guard isLocationAccessGranted,
            let latitude = locations.first?.coordinate.latitude,
            let longitude = locations.first?.coordinate.longitude else { return }
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        Task {
            print("Geocoder task started")
            var placemarks: [CLPlacemark]?
            do {
                placemarks = try await geocoder.reverseGeocodeLocation(location) }
            catch {
                print("Failed to retrieve address")
            }
            if let placemarks = placemarks, let locality = placemarks.first?.locality {
                self.observers.forEach { $0.observer?.didUpdateLocations(newLocation: locality) }
                print("Geocoder task completed")
            } else {
                print("No Matching Address Found")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to retrieve location with error: \(error.localizedDescription)")
    }
}
