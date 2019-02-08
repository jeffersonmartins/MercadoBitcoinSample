//
//  TickerAnimateLabel.swift
//  MercadoBitcoinDados
//
//  Created by Jefferson Martins  on 05/02/19.
//  Copyright © 2019 Jefferson Martins. All rights reserved.
//

import Foundation
import UIKit

class TickerAnimateLabel {
    
    private var labelTicker : UILabel!
    private var value : Double!
    private var currentValue : Double!
    private var updateTimer : Timer!
    
    private var incValue : Double {
        get {
            if value > 10000.0 {
                return 75.0
            } else if value > 5000.0 {
                return 45.0
            } else if value > 1000{
                return 10.0
            } else {
                return 2.0
            }
        }
    }
    
    init (withLabel: UILabel, andValueTicker: Double){
        self.labelTicker = withLabel
        self.value = andValueTicker
        
        DispatchQueue.main.async {
            self.currentValue = 0
            self.updateTimer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateLabel() {
        self.labelTicker!.text = (String(format: "R$ %.2f", currentValue ?? 0.00))
        currentValue! += incValue
        if currentValue > value! {
            self.labelTicker.text = (String(format: "R$ %.2f", value ?? 0.00))
            self.updateTimer?.invalidate()
            self.updateTimer = nil
            self.value = nil
            self.currentValue = nil
        }
    }
}
