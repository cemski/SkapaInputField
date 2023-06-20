//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI

/// Enum defining different states for the input field.
enum InputFieldStates {
    /// Represents the unselected state.
    case unselected
    /// Represents the selected state.
    case selected
    /// Represents the error state.
    case error
    /// Represents the success state.
    case success
    
    /// Returns the hint message based on the state, the error state uses the maximum length assigned by the input parameter.
    func hintMessage(_ message: String, maxLength: UInt16) -> String {
        switch self {
        case .unselected, .selected:
            return message
        case .error:
            return "Please only enter up to \(maxLength) characters"
        case .success:
            return "Success"
        }
    }
    
    /// Returns the color associated with each state.
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

/// Enum defining different hint states for the input field.
enum HintStates {
        /// Represents the normal hint state.
        case normal
        /// Represents the error hint state.
        case error
        /// Represents the success hint state.
        case success
    
    /// Returns the color associated with each hint state.
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
    
    /// Returns a preset symbol, if available, associated with each hint state.
    var stateSymbolString: String {
        switch self {
        case .normal:
            return ""
        case .error:
            return "exclamationmark.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}

struct InputField: View {
    // State Variables
    /// A boolean value that determines if the InputField is currently in focus.
    @FocusState var isFocused: Bool
    /// The text that the InputField displays.
    @Binding var text: String
    /// A boolean value that determines if the presented InputField should use secure entry, commonly used for passwords.
    ///
    /// This property is set to false by default. Setting this property to true will set the InputField to use a SecureField instead which disables the user’s ability to copy the text in the view and, in some cases, also disables the user’s ability to record and broadcast the text in the view.
    @State var isSecure: Bool = false
    /// A boolean value that determines whether the currently displayed SecureField has visible text.
    ///
    /// This property is set to true by default. Setting this property to false will enable the user to see the current text of the InputField.
    @State var isTextHidden: Bool = true
    /// A custom enum (TextEntryStates) which sets the
    @State var inputFieldState: InputFieldStates = .unselected
    @State var subtitleCase: HintStates = .normal
    
    // Other properties
    /// A UInt16 value that determines the maximum characters allowed for input.
    ///
    /// This property is set to 0 by default. This will cause the InputField not to  trigger any other states than the selected and unselected states.
    var maxLength: UInt16 = 0
    /// A string that displays the title for the InputField, helpful for explaining what the InputField below is used for.
    ///
    /// This property is optional in case there isn't a need for a title. By not supplying a title, the top row will not be rendered.
    var title: String?
    /// A string that is displayed as the hint message for the InputField, helpful for explaining any restrictions that may apply.
    var hintString: String?
    /// A string that is displayed as the error message for the InputField, helpful for explaining that the user has made an input that is not allowed.
    var errorString: String?
    /// A string value that can be to give the user a suggestion on what an input should look like.
    ///
    /// This property has the default value of an empty string as the constructor for TextField/Securefield needs a string.
    var placeholder: String = ""
    
    var body: some View {
        VStack {
            setupTopStack(title: title)
            setupInputFields()
            setupBottomStack(hint: hintString)
        }
    }
    
    /// A private helper method the split up the views in smaller, more readable and maintainable sections.
    ///
    /// - Parameters:
    ///  - Parameter title (Optional): The title for the top-most view in the InputField.
    ///
    /// - Returns: An assembled HStack containing a title (if there is one).
    private func setupTopStack(title: String?) -> some View {
        HStack {
            if let title = title {
            Text(title)
                .font(.bodyM)
                .foregroundColor(.textAndIcon2)
            }
            Spacer()
        }
        .padding(.bottom, 2)
    }
    
    /// A private helper method the split up the views in smaller, more readable and maintainable sections.
    ///
    /// - Returns: An assembled HStack for the InputField itself.
    private func setupInputFields() -> some View {
        HStack {
            determineInputField()
            .focused($isFocused)
            .onChange(of: isFocused) { focus in
                if !(inputFieldState == .error) && !(inputFieldState == .success)  {
                    self.inputFieldState = focus ? .selected : .unselected
                }
            }
            .onChange(of: text) { _ in
                verifyInput()
            }
            .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
            .font(.bodyL)
            .textFieldStyle(.plain)
            .background(Color.neutral1)
            .foregroundColor(.textAndIcon1)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(self.inputFieldState.color, lineWidth: isFocused ? 2 : 1)
            )
        }
        .padding(.bottom, 4)
    }
    
    private func determineInputField() -> some View {
        Group {
            if isSecure {
                HStack {
                        if isTextHidden {
                            SecureField(placeholder, text: $text)
                                .accessibilityIdentifier("password")
                        } else {
                            TextField(placeholder, text: $text)
                                .accessibilityIdentifier("visiblePassword")
                        }
                    Button(action: {
                        self.isTextHidden.toggle()
                    }, label: {
                        Image(systemName: isTextHidden ? "eye" : "eye.slash")
                            .foregroundColor(.textAndIcon1)
                    })
                    .accessibilityIdentifier("visibilityButton")
                }
                
            } else {
                TextField(placeholder, text: $text)
                    .accessibilityIdentifier("username")
            }
        }
    }

    /// A private helper method the split up the views in smaller, more readable and maintainable sections.
    ///
    /// - Parameters:
    ///  - Parameter hint (Optional): The hint message for the bottom-left view in the InputField.
    ///
    /// - Returns: An assembled HStack containing a hint (if there is one) and a character counter if the maxLength property has a positive value.
    private func setupBottomStack(hint: String?) -> some View {
        HStack {
            if let hint = hintString {
                
            if subtitleCase != .normal  && !(subtitleCase.stateSymbolString.isEmpty) {
                Image(systemName: subtitleCase.stateSymbolString)
                    .foregroundColor(subtitleCase.color)
            }
                Text(inputFieldState.hintMessage(hint, maxLength: maxLength))
                    .foregroundColor(subtitleCase.color)
                    .font(.bodyS)
            }
            Spacer()
            if maxLength > 0  && text.count < maxLength {
                    Text("\(text.count)/\(maxLength)")
                    .accessibilityIdentifier("counter")
                        .font(.bodyS)
                        .foregroundColor(.textAndIcon3)
            }
        }
    }
    
    /// Default verification for the InputField.
    ///
    /// Triggers different states depending on the input count compared to the maxLength provided (default is 0).
    private func verifyInput() {
        guard maxLength > 0 else {
            return
        }
        
        if text.count < maxLength {
            inputFieldState = isFocused ? .selected : .unselected
            subtitleCase = .normal
        }
        
        if text.count > maxLength {
            inputFieldState = .error
            subtitleCase = .error
        }
        
        if text.count == maxLength {
            inputFieldState = .success
            subtitleCase = .success
        }
    }
}



struct InputPreview: View {
    @State private var text: String = ""
    @State private var pass: String = ""
    
    var body: some View {
        ZStack{
            Color.neutral1.ignoresSafeArea()
            VStack {
                InputField(text: $text, title: "Username")
                InputField(text: $pass, isSecure: true, maxLength: 10, title: "Pin", hintString: "Only numeric input allowed")
            }
            .padding(30)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputPreview()
            .previewDisplayName("Standard")
        InputPreview()
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")
        InputPreview()
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL")
        InputPreview()
            .environment(\.colorScheme, .dark)
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL Dark")
        
    }
}
