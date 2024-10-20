//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    @IBOutlet var searchTextField: UITextField!

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

//        if #available(iOS 14.0, *) {
//            if locationManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse || locationManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways {
//                if CLLocationManager.locationServicesEnabled() {
//                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                    locationManager.startUpdatingLocation()
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//            if CLLocationManager.locationServicesEnabled() {
//                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                locationManager.startUpdatingLocation()
//            }
//        }

        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }

    func didFailWithError(error: any Error) {
        print(error)
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // search city weather here

        weatherManager.fetchWeather(cityName: textField.text ?? "pune")

        searchTextField.text = ""
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        locationManager.stopUpdatingLocation()

//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate

        let lat = manager.location?.coordinate.latitude
        let lon = manager.location?.coordinate.longitude
        weatherManager.fetchWeather(latitude: lat ?? 0, longitute: lon ?? 0)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
