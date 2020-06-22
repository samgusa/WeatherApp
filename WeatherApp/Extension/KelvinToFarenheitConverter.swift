//
//  KelvinToFarenheitConverter.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/13/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

extension Float {
    func truncate(places: Int) -> Float {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
}
