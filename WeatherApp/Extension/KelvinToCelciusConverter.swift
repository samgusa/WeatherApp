//
//  KelvinToCelciusConverter.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/12/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

extension Float {
    func truncate(places: Int) -> Float {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToCelciusConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue = self
        let celValue = kelValue - constantVal
        return celValue.truncate(places: 1)
        
    }
    
    
    func kelvinToFarenheitConverter() -> Float {
        let constantVal: Float = 459.67
        let kelValue = self
        let farValue = (kelValue*(9/5) - constantVal)
        print(farValue)
        return farValue.truncate(places: 1)
    }

    
}
