import Foundation
import CoreImage
import UIKit


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

func blur(radius: Double) -> Filter {
    return { image in
        let parameters : Parameters = [kCIInputRadiusKey: radius as AnyObject, kCIInputImageKey: image]
        let filter = CIFilter(name:"CIGaussianBlur", parameters:parameters)
        return filter.outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let filter = CIFilter(name:"CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor(color: color)])
        return filter.outputImage
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters : Parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        let filter = CIFilter(name:"CISourceOverCompositing", parameters: parameters)
        return filter.outputImage.cropped(to: image.extent)
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
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


