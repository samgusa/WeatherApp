//
//  IntExtension.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/12/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementVal = self + num
        let mod = incrementVal % 7
        
        return mod
    }
}
