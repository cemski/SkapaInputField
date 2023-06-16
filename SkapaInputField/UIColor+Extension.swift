//
//  UIColor+Extension.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI

extension Color {
    static let interactiveEmphasisedBgDefault = Color("interactive-emphasised-bg-default")
    static let neutral1 = Color("neutral-1")
    static let neutral5 = Color("neutral-5")
    static let semanticNegative = Color("semantic-negative")
    static let semanticPositive = Color("semantic-positive")
    static let textAndIcon1 = Color("text-and-icon-1")
    static let textAndIcon2 = Color("text-and-icon-2")
    static let textAndIcon3 = Color("text-and-icon-3")
}

extension Font {
    static let bodyM = CustomFont(size: 14, lineHeight: 22)
    static let bodyS = CustomFont(size: 12, lineHeight: 18)
    static let headingXs = CustomFont(size: 14, lineHeight: 22, bold: true)
    
}

struct CustomFont: ViewModifier {
    var size: CGFloat
    var lineHeight: CGFloat
    var bold: Bool = false
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(.bold)
            .lineSpacing(lineHeight - size)
    }
}

extension Text {
    func customFont(size: CGFloat, lineHeight: CGFloat) -> some View {
        self.modifier(CustomFont(size: size, lineHeight: lineHeight))
    }
}
