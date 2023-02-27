//
//  TutorialViewController.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import UIKit

protocol TutorialViewPresenterProtocol {
    var buttonText: String { get }
    func viewDidLoad()
    func buttonTapped()
}

final class TutorialViewController: UIViewController, TutorialScreenViewProtocol {
    @IBOutlet private weak var stepViewsContainer: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    var presenter: TutorialViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStepsLayout()
    }
    
    func setupView(with stepModels: [TutorialStepModel]) {
        stepModels.forEach { model in
            let view = TutorialStepView(model: model)
            stepViewsContainer.embed(view)
        }
        actionButton.setTitle(presenter?.buttonText, for: .normal)
    }
    
    func enableButton() {
        actionButton.isEnabled = true
    }
    
    private func setupStepsLayout() {
        stepViewsContainer.subviews.enumerated().forEach { index, view in
            view.transform = view.transform.translatedBy(x: CGFloat(index) * view.frame.width, y: 0)
        }
    }
    
    func showNextScreen() {
        actionButton.setTitle(presenter?.buttonText, for: .normal)
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.stepViewsContainer.subviews.forEach { view in
                view.transform = view.transform.translatedBy(x: -view.frame.width, y: 0)
            }
        })
    }

    @IBAction private func actionButtonTapped(_ sender: Any) {
        presenter?.buttonTapped()
    }
}
