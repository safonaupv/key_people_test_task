//
//  WeatherViewPresenter.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import Foundation

protocol WeatherViewProtocol: AnyObject {
    func setupView(with data: WeatherData)
}

final class WeatherViewPresenter {
    weak var view: WeatherViewProtocol?
    private let weatherService: WeatherService
    
    init(view: WeatherViewProtocol, weatherService: WeatherService) {
        self.weatherService = weatherService
        self.view = view
        weatherService.delegate = self
    }
}

extension WeatherViewPresenter: WeatherViewPresenterProtocol {
    func viewDidLoad() {
        guard let data = weatherService.lastWeatherData else { return }
        view?.setupView(with: data)
    }
}

extension WeatherViewPresenter: WeatherServiceDelegate {
    func weatherDataUpdated(_ data: WeatherData) {
        DispatchQueue.main.async {
            self.view?.setupView(with: data)
        }
    }
}
