//
//  TutorialScreenPresenter.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import Foundation
import CoreLocation

protocol TutorialScreenViewProtocol: AnyObject {
    func setupView(with stepModels: [TutorialStepModel])
    func enableButton()
    func showNextScreen()
}

final class TutorialScreenPresenter {
    weak var view: TutorialScreenViewProtocol?
    private var currentStepIndex = 0
    private var locationService: LocationService
    private var tutorialCompletion: () -> Void
    private var model: TutorialScreenModel
    
    init(view: TutorialScreenViewProtocol, model: TutorialScreenModel, locationService: LocationService, completion: @escaping () -> Void) {
        self.view = view
        self.locationService = locationService
        self.tutorialCompletion = completion
        self.model = model
        locationService.addObserver(self)
    }
}

extension TutorialScreenPresenter: TutorialViewPresenterProtocol {
    var buttonText: String {
        model.stepModels[currentStepIndex].buttonText
    }
    
    func viewDidLoad() {
        view?.setupView(with: model.stepModels)
        if locationService.isLocationAccessGranted {
            view?.enableButton()
        }
        locationService.requestAuthorization()
    }
    
    func buttonTapped() {
        if currentStepIndex < model.stepModels.count - 1 {
            currentStepIndex += 1
            view?.showNextScreen()
        } else {
            tutorialCompletion()
        }
    }
}

extension TutorialScreenPresenter: LocationServiceObserver {
    func didUpdateLocations(newLocation: String) {}
    
    func authorizationStatusChanged() {
        guard locationService.isLocationAccessGranted else { return }
        view?.enableButton()
    }
}
