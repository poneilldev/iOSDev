//
//  ViewController.swift
//  StrategyPatternCarBrakes
//
//  Created by Paul O'Neill on 11/9/14.
//  Copyright (c) 2014 Paul O'Neill. All rights reserved.
//

import UIKit

protocol Brakes {
    func brakeType() ->String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        class Honda : Brakes {
            func brakeType() -> String {
            return "Pump Brakes"
            }
        }
        
        class BMW : Brakes {
            func brakeType() -> String {
            return "Disc Brakes"
            }
        }
        
        
        var car1 = Honda.brakeType()
        println(car1)
        
        var car2 = BMW.brakeType()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

