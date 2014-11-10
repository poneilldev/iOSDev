//
//  ViewController.swift
//  DecoratorDesignExample
//
//  Created by Paul O'Neill on 11/10/14.
//  Copyright (c) 2014 Paul O'Neill. All rights reserved.
//

import UIKit

protocol Coffee {
    func getCost() -> Double
    func getIngredients() -> String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        class SimpleCoffee: Coffee {
            func getCost() -> Double {
                return 1.0
            }
            
            func getIngredients() -> String {
                return "Coffee"
            }
        }
        
        class CoffeeDecorator: Coffee {
            private let decoratedCoffee: Coffee
            private let ingredientSeparator: String = ", "
            
            required init(decoratedCoffee: Coffee) {
                self.decoratedCoffee = decoratedCoffee
            }
            
            func getCost() -> Double {
                return decoratedCoffee.getCost()
            }
            
            func getIngredients() -> String {
                return decoratedCoffee.getIngredients()
            }
        }
        
        class Milk: CoffeeDecorator {
            required init(decoratedCoffee: Coffee) {
                super.init(decoratedCoffee: decoratedCoffee)
            }
            
            override func getCost() -> Double {
                return super.getCost() + 0.5
            }
            
            override func getIngredients() -> String {
                return super.getIngredients() + ingredientSeparator + "Milk"
            }
        }
        
        class WhipCoffee: CoffeeDecorator {
            required init(decoratedCoffee: Coffee) {
                super.init(decoratedCoffee: decoratedCoffee)
            }
            
            override func getCost() -> Double {
                return super.getCost() + 0.7
            }
            
            override func getIngredients() -> String {
                return super.getIngredients() + ingredientSeparator + "Whip"
            }
        }
        
        
        var someCoffee: Coffee = SimpleCoffee()
        println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
        someCoffee = Milk(decoratedCoffee: someCoffee)
        println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
        someCoffee = WhipCoffee(decoratedCoffee: someCoffee)
        println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

