import Foundation

struct AppExtension<Base> {
    let base: Base
    init(base: Base) {
        self.base = base
    }
}

protocol AppExtensionConvertable {
    associatedtype Compatible
    static var app: AppExtension<Compatible>.Type { get set }
    var app: AppExtension<Compatible> { get set }
}

extension AppExtensionConvertable {
    static var app: AppExtension<Self>.Type {
        get { return AppExtension<Self>.self }
        set {}
    }

    var app: AppExtension<Self> {
        get { return AppExtension(base: self) }
        set {}
    }
}
