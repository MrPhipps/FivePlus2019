import SwiftUI
import UIKit
import PlaygroundSupport
import CoreImage

precedencegroup ForwardApplication {
  associativity: left
}

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator |>: ForwardApplication
infix operator >>> :ForwardComposition

func |> <A, B>(a: A, f: (A) -> B) -> B {
  return f(a)
}

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
  return { a in
    g(f(a))
  }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) } }
}

let page = PlaygroundPage.current

struct ContentView: View {
  var body: some View {
    EmptyView()
  }
}

PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView()
)

extension Double {
    func phi() -> Double {
        return self * (1.0 + sqrt(5.0))/2.0
    }
}

extension Float {
    func phi() -> Float {
        return self * (1.0 + sqrt(5.0)) / 2.0
    }
}

extension Int {
  func incr() -> Int {
    return self + 1
  }

  func square() -> Int {
    return self * self
  }
}

func phi(x:Double)->Double {
    return x * (1.0 + sqrt(5.0))/2.0
}

func phi(x:CGFloat)->CGFloat {
    return x * (1.0 + sqrt(5.0))/2.0
}

func phi(x:Float)->Float {
    return x * (1.0 + sqrt(5.0))/2.0
}

func square(x:Int)->Int{
    return x * x
}

func incr(x:Int)->Int {
    return x + 1
}

func greet(at date: Date, name: String) -> String {
  let seconds = Int(date.timeIntervalSince1970) % 60
  return "Hello \(name)! It's \(seconds) seconds past the minute."
}

func greet(at date: Date) -> (String) -> String {
  return { name in
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
  }
}

curry(greet(at:name:))
greet(at:)

curry(String.init(data:encoding:))
    >>> {$0(.utf8)}



let image:CIImage = CIImage(image: UIImage(named: "35mm_10292_011e.jpg")!)!


//let filter =  blur(radius:5) >|> colorOverlay(color: .blue)
//let result = filter(image!.ciImage!)

image |>
    boxBlur(radius: 1.0 |> phi ) >>>
    blur(radius: 10.0 |> phi)








