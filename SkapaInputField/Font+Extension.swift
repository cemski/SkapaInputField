//
//  Font+Extension.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-20.
//

import SwiftUI

extension Font {
    public static var bodyS: Font {
        return Font.custom("NotoSans-Regular", size: 12)
    }
    
    public static var bodyM: Font {
        return Font.custom("NotoSans-Regular", size: 14)
    }
    
    public static var bodyL: Font {
        return Font.custom("NotoSans-Regular", size: 16)
    }
    
    public static var headingXS: Font {
        return Font.custom("NotoSans-Bold", size: 14).weight(.bold)
    }
    
    public static var buttonLabelM: Font {
        return Font.custom("NotoSans-Bold", size: 14).weight(.bold)
    }
}

//struct LineHeight: ViewModifier {
//    let font: UIFont
//    let lineHeight: CGFloat
//
//    func body(content: Content) -> some View {
//        content
//            .lineSpacing(lineHeight - font.lineHeight)
//            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
//    }
//}
//
//extension View {
//    func lineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
//        return modifier(LineHeight(font: font, lineHeight: lineHeight))
//    }
//}
