import UIKit

extension UIColor: AppExtensionConvertable {}

extension AppExtension where Base: UIColor {
    static var blue: UIColor {
        return #colorLiteral(red: 0.2941176471, green: 0.6823529412, blue: 0.9176470588, alpha: 1)
    }

    static var btnBlue: UIColor {
        return #colorLiteral(red: 0.4941176471, green: 0.7215686275, blue: 0.9411764706, alpha: 1)
    }

    static var backgronundBlue: UIColor {
        return #colorLiteral(red: 0.8352941176, green: 0.9137254902, blue: 0.9647058824, alpha: 1)
    }

    static var darkGray: UIColor {
        return #colorLiteral(red: 0.4391747117, green: 0.4392418861, blue: 0.4391601086, alpha: 1)
    }

    static var translucentBlack: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    static var gray: UIColor {
        return #colorLiteral(red: 0.5999458432, green: 0.600034833, blue: 0.5999264717, alpha: 1)
    }

    static var lightGray: UIColor {
        return #colorLiteral(red: 0.871522963, green: 0.875556767, blue: 0.8854150176, alpha: 1)
    }

    static var titleBlack: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    static var textBlack: UIColor {
        return #colorLiteral(red: 0.129396528, green: 0.1294215024, blue: 0.1293910444, alpha: 1)
    }
    
    static var calculator: UIColor {
        return UIColor(red: 77/255.0, green: 171/255.0, blue: 245/255.0, alpha: 0.8)
    }

    static var green: UIColor {
        return #colorLiteral(red: 0.3254901961, green: 0.7098039216, blue: 0.2078431373, alpha: 1)
    }

    static var creamColor: UIColor {
        return #colorLiteral(red: 0.9989084601, green: 0.9508033395, blue: 0.7191306353, alpha: 1)
    }

    static var aresRed: UIColor {
        return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }

}
