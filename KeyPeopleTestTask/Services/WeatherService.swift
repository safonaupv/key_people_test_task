//
//  WeatherService.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import Foundation

struct WeatherData {
    let name: String
    let temperature: Double
}

protocol WeatherServiceDelegate: AnyObject {
    func weatherDataUpdated(_ data: WeatherData)
}

final class WeatherService {
    let headers = [
        "X-RapidAPI-Key": "41ba93302fmshe527aa4f972435cp184ee5jsn530e6a0ab46d",
        "X-RapidAPI-Host": "open-weather13.p.rapidapi.com"
    ]
    
    weak var delegate: WeatherServiceDelegate?
    var lastWeatherData: WeatherData?
    
    private func getWeather(for location: String) async -> WeatherData? {
        let request = NSMutableURLRequest(url: NSURL(string: "https://open-weather13.p.rapidapi.com/city/\(location.lowercased())")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let data: Data
        do {
            try data = await session.data(for: request as URLRequest).0
        } catch {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any],
           let main = dictionary["main"] as? [String: Any],
           let temperature = main["temp"] as? Double {
            return WeatherData(name: location, temperature: temperature)
        }
        return nil
    }
}

extension WeatherService: LocationServiceObserver {
    func authorizationStatusChanged() {}
    
    func didUpdateLocations(newLocation: String) {
        Task {
            print("Weather task started")
            guard let data = await getWeather(for: newLocation) else { return }
            lastWeatherData = data
            delegate?.weatherDataUpdated(data)
            print("Weather data updated: \(data)")
            print("Weather task completed")
        }
    }
}
