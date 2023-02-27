//
//  WeatherViewController.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import UIKit

protocol WeatherViewPresenterProtocol {
    func viewDidLoad()
}

final class WeatherViewController: UIViewController, WeatherViewProtocol {
    @IBOutlet private weak var loadingLabel: UILabel!
    @IBOutlet private weak var weatherInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    var presenter: WeatherViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func setupView(with data: WeatherData) {
        loadingLabel.isHidden = true
        loadingIndicator.stopAnimating()
        weatherInfoLabel.text = "\(data.temperature) degrees in \(data.name)"
        weatherInfoLabel.isHidden = false
        titleLabel.isHidden = false
    }
}
