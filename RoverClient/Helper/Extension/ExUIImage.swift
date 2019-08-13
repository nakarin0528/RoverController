import UIKit

extension UIImage {

    func rotatedBy(degree: CGFloat) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)

        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }

    // 画像の色変更
    func tint(_ tintColor: UIColor?) -> UIImage {
        guard let tintColor = tintColor else { return self }
        return modifiedImage { context, rect in
            context.setBlendMode(.multiply)
            context.clip(to: rect, mask: self.cgImage!)
            tintColor.setFill()
            context.fill(rect)
        }
    }

    private func modifiedImage(draw: (CGContext, CGRect) -> ()) -> UIImage {
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return newImage
    }

    // グラデーションイメージを生成
    class func gradientImage(with size: CGSize, colors: [UIColor], locations: [CGFloat]? = nil, start: CGPoint, end: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map { $0.cgColor } as CFArray, locations: locations) {
            context?.drawLinearGradient(gradient, start: start, end: end, options: CGGradientDrawingOptions())
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
