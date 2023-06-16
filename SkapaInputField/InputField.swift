//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI
import Combine

enum InputFieldStates {
    case unselected, selected, success, error
}

enum InputFieldError {
    case unselected, selected, error, success
    
    var message: String {
        switch self {
        case .unselected, .selected:
            return "Only numeric input allowed"
        case .error:
            return "Invalid character"
        case .success:
            return "Success"
        }
    }
    
    var state: InputFieldStates {
        switch self {
        case .unselected:
            return .unselected
        case .selected:
            return .selected
        case .error:
            return .error
        case .success:
            return .success
        }
    }
    
    var color: Color {
        switch self {
        case .unselected:
            return .neutral5
        case .selected:
            return .interactiveEmphasisedBgDefault
        case .error:
            return .semanticNegative
        case .success:
            return .semanticPositive
        }
    }
}

enum SubtitleCases {
    case normal, error, success
    
    var color: Color {
        switch self {
        case .normal:
            return .textAndIcon3
        case .error:
            return .semanticNegative
        case .success:
            return .semanticPositive
        }
    }
    
    var stateIcon: String? {
        switch self {
        case .normal:
            return nil
        case .error:
            return "exclamationmark.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}

struct InputField: View {
    @FocusState var isFocused: Bool
    @Binding var text: String
    @State var isSecure: Bool = false
    @State var isValid: Bool? = nil
    @State var isTextHidden: Bool = true
    @State var placeholderText: String = "Placeholder"
    @State var inputFieldState: InputFieldError = .unselected
    @State var subtitleCase: SubtitleCases = .normal
    var maxLength = 8
    var title: String?
    var informationString: String?
    
    private func setupTopTitle() -> some View {
        HStack {
            Text(title ?? "Title")
                .font(.body)
                .foregroundColor(.textAndIcon3)
            Spacer()
        }
    }
    
    private func setupInputFields() -> some View {
        Group {
            if isSecure {
                SecureField(placeholderText, text: $text)
                    .overlay(
                        Button(action: {
                            self.isTextHidden.toggle()
                        }){
                            Image(systemName: isTextHidden ? "eye" : "eye.slash")
                                .renderingMode(.template)
                                .foregroundColor(.textAndIcon1)
                        }
                            .padding(.trailing, 10), alignment: .trailing)
            } else {
                TextField(placeholderText, text: $text)
                
            }
        }
        .focused($isFocused)
        .onChange(of: isFocused, perform: { focus in
            self.inputFieldState = focus ? .selected : .unselected
        })
        .font(.body)
        .textFieldStyle(.roundedBorder)
        .foregroundColor(.textAndIcon1)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(self.inputFieldState.color, lineWidth: 2)
        )
        
        .onReceive(Just(text), perform: { text in
            verifyInput()
        })
    }
    
    private func setupBottomStack() -> some View {
        HStack {
            Group {
                if subtitleCase != .normal {
                    Image(systemName: subtitleCase.stateIcon ?? "cloud")
                        .foregroundColor(subtitleCase.color)
                }
                
                Text(inputFieldState.message)
                    .foregroundColor(subtitleCase.color)
                    .font(.caption)
            }
            Spacer()
            
            if text.count < maxLength {
                Text("\(text.count)/\(maxLength)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        VStack {
            setupTopTitle()
            setupInputFields()
            setupBottomStack()
        }
    }
    
    private func verifyInput() {
        if text.count < maxLength {
            
        }
        //        let filtered = text.filter {
        //            $0.isNumber
        //        }
        //        if text.count < maxLength {
        //            inputFieldState = InputFieldError.selected
        //            subtitleCase = SubtitleCases.normal
        //        }
        
        if text.count > 0 && !isNumeric(string: text) {
            inputFieldState = InputFieldError.error
            subtitleCase = SubtitleCases.error
        }
        
        if text.count == maxLength {
            inputFieldState = InputFieldError.success
            subtitleCase = SubtitleCases.success
        }
    }
    
    func isNumeric(string: String) -> Bool {
        return !string.isEmpty && string.range(of: "^[0-9]*$", options: .regularExpression) != nil
    }
    
    private func submitInput() {
        if text.count < maxLength {
            inputFieldState = InputFieldError.error
            
        } else if text.contains("CHARACTERS") {
            inputFieldState = InputFieldError.error
            
        } else {
            inputFieldState = InputFieldError.success
        }
    }
}

struct InputPreview: View {
    @State private var text: String = ""
    @State private var pass: String = ""
    
    var body: some View {
        VStack {
            InputField(text: $text, title: "Username", informationString: "Only numeric input allowed")
            InputField(text: $pass, isSecure: true, title: "Pin")
        }
        .padding(30)
    }
}


struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputPreview()
        
        InputPreview()
            .environment(\.layoutDirection, .rightToLeft)
    }
}
