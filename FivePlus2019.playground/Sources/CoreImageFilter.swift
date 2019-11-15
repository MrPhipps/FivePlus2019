import Foundation
import CoreImage
import UIKit

public extension CIFilter {

    typealias Filter = (CIImage) -> (CIImage)
    typealias Parameters = Dictionary<String,AnyObject>

    convenience init(name: String, parameters: Parameters) {
        self.init(name: name)!
        setDefaults()
        for (key, value) in parameters {
            setValue(value, forKey:key)
        }
    }

    var outputImage: CIImage { return self.value(forKey: kCIOutputImageKey) as! CIImage }
}

public func boxBlur(radius:Float) -> CIFilter.Filter {
    return { image in
        let filter = CIFilter(name: "CIBoxBlur")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        return filter!.outputImage.cropped(to: image.extent)
    }
}

public func blur(radius: Double) -> CIFilter.Filter {
    return { image in
        let filter = CIFilter(name:"CIGaussianBlur")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        return filter!.outputImage.cropped(to: image.extent)
    }
}

public func colorGenerator(color: UIColor) -> CIFilter.Filter  {
    return { image in
        let filter = CIFilter(name:"CIConstantColorGenerator")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(color, forKey: kCIInputColorKey)
        return filter!.outputImage.cropped(to: image.extent)
    }
}

public func compositeSourceOver(overlay: CIImage) -> CIFilter.Filter  {
    return { image in
        let filter = CIFilter(name:"CISourceOverCompositing")
        filter?.setValue(image, forKey: kCIInputBackgroundImageKey)
        filter?.setValue(overlay, forKey: kCIInputImageKey)
        return filter!.outputImage.cropped(to: image.extent)
    }
}

public func colorOverlay(color: UIColor) -> CIFilter.Filter  {
    return { image in
        let overlay = image |> colorGenerator(color: color)
        return image |> compositeSourceOver(overlay: overlay)
    }
}

precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
  return f(a)
}






