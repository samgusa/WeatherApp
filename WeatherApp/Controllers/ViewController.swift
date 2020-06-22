//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/11/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let networkManager = WeatherNetworkManager()
    
    let topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let btmView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let currentLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "6 June 2020"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "°F / °C"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let tempSymbol: UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.tintColor = .gray
        return img
    }()
    
    let maxTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °F/  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let minTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °F/  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView: UIStackView!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)), UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast)), UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        transparentNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleConstraints), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        addViews()
    }

    func addViews() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(topView)
        //layout
        let defaultTop = topView.topAnchor.constraint(equalTo: guide.topAnchor)
        let defaultLeading = topView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        
        //portrait
        let portraitTrailing = topView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        let portraitHeight = topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
        
        //add views to topView
        self.topView.addSubview(currentLocation)
        currentLocation.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        currentLocation.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 18).isActive = true
        currentLocation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        currentLocation.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -18).isActive = true
        self.topView.addSubview(currentTime)
        currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 18).isActive = true
        currentTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        currentTime.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -18).isActive = true
        
        
        
        //btm view layout
        view.addSubview(btmView)
        let defaultTrailing = btmView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        let defaultBtm = btmView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        
        //portrait
        let portraitBtm = btmView.topAnchor.constraint(equalTo: topView.bottomAnchor)
        let portraitLeading = btmView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        
        //landscape constraints
        
        let landscapeBtm = topView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        let landscapeWidth = topView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4)
        
        //view landscape constraints
        let landscapeTop = btmView.topAnchor.constraint(equalTo: guide.topAnchor)
        let landscapeTrailing = btmView.leadingAnchor.constraint(equalTo: topView.trailingAnchor)
        
        //add to btmView
        self.btmView.addSubview(currentTemperatureLabel)
        self.btmView.addSubview(tempSymbol)
        self.btmView.addSubview(tempDescription)
        self.btmView.addSubview(minTemp)
        self.btmView.addSubview(maxTemp)
        
//        currentTemperatureLabel.centerYAnchor.constraint(equalTo: btmView.centerYAnchor).isActive = true
        currentTemperatureLabel.topAnchor.constraint(equalTo: btmView.topAnchor, constant: 5).isActive = true
        currentTemperatureLabel.leadingAnchor.constraint(equalTo: btmView.leadingAnchor, constant: 18).isActive = true
        currentTemperatureLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //        currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor).isActive = true
        tempSymbol.leadingAnchor.constraint(equalTo: btmView.leadingAnchor, constant: 18).isActive = true
        tempSymbol.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tempSymbol.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDescription.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 12.5).isActive = true
        tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: 8).isActive = true
        tempDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDescription.widthAnchor.constraint(equalTo: self.btmView.widthAnchor).isActive = true
        minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80).isActive = true
        minTemp.leadingAnchor.constraint(equalTo: btmView.leadingAnchor, constant: 18).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTemp.widthAnchor.constraint(equalTo: btmView.widthAnchor).isActive = true
        
        maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor).isActive = true
        maxTemp.leadingAnchor.constraint(equalTo: btmView.leadingAnchor, constant: 18).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTemp.widthAnchor.constraint(equalTo: btmView.widthAnchor).isActive = true
        
        let defaultConstraints = [defaultTop, defaultLeading, defaultBtm, defaultTrailing]
        portraitConstraints = [portraitHeight, portraitTrailing, portraitBtm, portraitLeading]
        landscapeConstraints = [landscapeWidth, landscapeBtm, landscapeTop, landscapeTrailing]
        
        self.view.addConstraints(defaultConstraints)
        toggleConstraints()
        
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = "\(weather.main.temp.kelvinToFarenheitConverter())°F  / \n \(weather.main.temp.kelvinToCelciusConverter())°C"
                self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToFarenheitConverter()) + "°F" + " / " +  String(weather.main.temp_min.kelvinToCelciusConverter()) + "°C")
                self.maxTemp.text = ("Max: " + String(weather.main.temp_min.kelvinToFarenheitConverter()) + "°F" + " / " +  String(weather.main.temp_min.kelvinToCelciusConverter()) + "°C")
                self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = (String(weather.main.temp.kelvinToFarenheitConverter()) + "°F" + (String(weather.main.temp.kelvinToCelciusConverter()) + "°C"))
                self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
                self.tempDescription.text = weather.weather[0].description
                self.currentTime.text = stringDate
                self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToFarenheitConverter()) + "°F" + " / " +  String(weather.main.temp_min.kelvinToCelciusConverter()) + "°C")
                self.maxTemp.text = ("Max: " + String(weather.main.temp_min.kelvinToFarenheitConverter()) + "°F" + " / " +  String(weather.main.temp_min.kelvinToCelciusConverter()) + "°C")
                self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let cityName = firstTextField.text else { return }
            
            self.loadData(city: cityName) // calling the load function
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) -> Void in
            print("cancel")
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
    
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    @objc func toggleConstraints() {
        if UIDevice.current.orientation.isLandscape {
            self.view.removeConstraints(portraitConstraints)
            self.view.addConstraints(landscapeConstraints)
        } else {
            self.view.removeConstraints(landscapeConstraints)
            self.view.addConstraints(portraitConstraints)
        }
    }
    
}


