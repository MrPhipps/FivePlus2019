import SwiftUI
import UIKit
import PlaygroundSupport
import CoreImage

struct ContentView: View {
  var body: some View {
    EmptyView()
  }
}

import PlaygroundSupport

PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView()
)

func phi(_ value: CGFloat) -> (positive:CGFloat, negative:CGFloat) {
    let positive:CGFloat = value * (1.0 + sqrt(5.0))/2.0
    let negative:CGFloat = value * (1.0 - sqrt(5.0))/2.0

    return(positive, negative)
}

let x = phi(1).positive
let y = phi(1).negative


typealias Filter = (CIImage) -> (CIImage)
typealias Parameters = Dictionary<String,AnyObject>

extension CIFilter {

    convenience init(name: String, parameters: Parameters) {
        self.init(name: name)!
        setDefaults()
        for (key, value) in parameters {
            setValue(value, forKey:key)
        }
    }

    var outputImage: CIImage { return self.value(forKey: kCIOutputImageKey) as! CIImage }
}


precedencegroup ForwardApplication {
  associativity: left
}

infix operator >|> :ForwardApplication

func >|> ( filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return {
        img in filter2(filter1(img))
    }
}


