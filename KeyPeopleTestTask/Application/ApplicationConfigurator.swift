//
//  ApplicationConfigurator.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import UIKit

final class ApplicationConfigurator {
    private weak var window: UIWindow?
    
    private var isTutorialScreenShown: Bool {
        get { UserDefaults.standard.bool(forKey: "IsTutorialScreenShown") }
        set { UserDefaults.standard.set(newValue, forKey: "IsTutorialScreenShown") }
    }
    
    func startMainFlow(window: UIWindow) {
        self.window = window
        if !isTutorialScreenShown {
            showTutorialScreen { [weak self] in
                self?.isTutorialScreenShown = true
                self?.showWeatherScreen()
            }
        } else {
            showWeatherScreen()
            if !ServiceContainer.shared.locationService.isLocationAccessGranted {
                ServiceContainer.shared.locationService.requestAuthorization()
            }
        }
    }
    
    private func showTutorialScreen(completion: @escaping () -> Void) {
        let view = TutorialViewController()
        let model = TutorialScreenModel(stepModels: [TutorialStepModel(titleText: "Tutorial screen 1",
                                                                       buttonText: "Next"),
                                                     TutorialStepModel(titleText: "Tutorial screen 2",
                                                                       buttonText: "Ok")])
        let presenter = TutorialScreenPresenter(view: view, model: model,
                                                locationService: ServiceContainer.shared.locationService,
                                                completion: completion)
        view.presenter = presenter
        window?.rootViewController = view
    }
    
    private func showWeatherScreen() {
        let view = WeatherViewController()
        let presenter = WeatherViewPresenter(view: view, weatherService: ServiceContainer.shared.weatherService)
        view.presenter = presenter
        window?.rootViewController = view
    }
}
