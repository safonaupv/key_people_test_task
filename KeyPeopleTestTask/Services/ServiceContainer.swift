//
//  ServiceContainer.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import Foundation

final class ServiceContainer {
    static let shared = ServiceContainer()
    
    let weatherService: WeatherService
    let locationService: LocationService
    
    private init() {
        locationService = LocationService()
        weatherService = WeatherService()
        locationService.addObserver(weatherService)
    }
}
