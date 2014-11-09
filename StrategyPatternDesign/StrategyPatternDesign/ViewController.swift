//
//  ViewController.swift
//  StrategyPatternDesign
//
//  Created by Paul O'Neill on 11/9/14.
//  Copyright (c) 2014 Paul O'Neill. All rights reserved.
//

import UIKit


/******************************************************
* PROTOCOL - it's like a Java Interface
* It gives certain instructions on what needs to be
* implemented
* This example is a little different from the car example
* I showed, but it still drives the point home
********************************************************/
protocol PrintStrategy {
    func printString(string: String) -> String
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        class Printer {
            
            let strategy: PrintStrategy
            
            func printString(string: String) -> String {
                return self.strategy.printString(string)
            }
            
            init(strategy: PrintStrategy) {
                self.strategy = strategy
            }
        }
        
        class UpperCaseStrategy : PrintStrategy {
            func printString(string:String) -> String {
                return string.uppercaseString
            }
        }
        
        class LowerCaseStrategy : PrintStrategy {
            func printString(string:String) -> String {
                return string.lowercaseString
            }
        }
        
        var lower = Printer(strategy:LowerCaseStrategy())
        println(lower.printString("Hello, World"))
        
        var upper = Printer(strategy:UpperCaseStrategy())
        println(upper.printString("Hello, World!"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

