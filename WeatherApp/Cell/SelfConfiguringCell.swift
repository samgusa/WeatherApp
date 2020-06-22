//
//  SelfConfiguringCell.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/13/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
    static var reuseIndentifier: String { get }
    func configure(with item: ForecastTemperature)
}


