// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func hello(name: String) -> String {
    return "Hello, " + name
}

func bold(function: String -> String) -> (String -> String) {
    func decoratedBold(text: String) -> String {
        return "<b>" + function(text) + "</b>"
    }
    return decoratedBold
}
let boldHello = bold(hello)
println(boldHello("Vladimir"))          