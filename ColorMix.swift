import SwiftUI
import UIKit

extension Color {

    func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let ui = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        ui.getRed(&r, green: &g, blue: &b, alpha: &a)

        return (r,g,b,a)
    }

}
func mixPigment(_ c1: Color, _ c2: Color) -> Color {

    let a = c1.components()
    let b = c2.components()

    // subtractive style mix (closer to paint behaviour)

    let r = sqrt(a.r * b.r)
    let g = sqrt(a.g * b.g)
    let b2 = sqrt(a.b * b.b)

    return Color(red: r, green: g, blue: b2)
}
