//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI

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
    
    // Other properties
    /// A UInt16 value that determines the maximum characters allowed for input.
    ///
    /// This property is set to 0 by default. This will cause the InputField not to  trigger any other states than the selected and unselected states.
    var maxLength: UInt16 = 0
    /// A string that displays the title for the InputField, helpful for explaining what the InputField below is used for.
    ///
    /// This property is optional in case there isn't a need for a title. By not supplying a title, the top row will not be rendered.
    var title: String?
    /// A string that is displayed as the prompt message for the InputField, helpful for explaining any restrictions that may apply.
    var promptString: String?
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
            setupBottomStack(prompt: promptString)
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
                .frame(maxWidth: .infinity, maxHeight: 26 * scale)
                .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
                .font(.bodyL)
                .textFieldStyle(.plain)
                .background(Color.neutral1)
                .foregroundColor(.textAndIcon1)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(self.inputFieldState.borderColor, lineWidth: isFocused ? 2 : 1)
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
                        Image(isTextHidden ? "eye" : "eye.slash")
                            .renderingMode(.template)
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
    ///  - Parameter prompt (Optional): The prompt message for the bottom-left view in the InputField.
    ///
    /// - Returns: An assembled HStack containing a prompt (if there is one) and a character counter if the maxLength property has a positive value.
    
    @ScaledMetric var scale: CGFloat = 1
    private func setupBottomStack(prompt: String?) -> some View {
        HStack(alignment: .center, spacing: 0) {
            if let prompt = promptString {
                
                Label {
                    Text(inputFieldState.promptMessage(prompt, maxLength: maxLength))
                        .font(.bodyS)
                        .foregroundColor(inputFieldState.promptColor)
                } icon: {
                    if inputFieldState != .selected  && !(inputFieldState.promptImageString.isEmpty) {
                        ZStack(alignment: .center) {
                            
                            Circle()
                                .fill(inputFieldState.promptColor)
                                .frame(width: 16 * scale, height: 16 * scale)
                                .padding(2)
                            Image(inputFieldState.promptImageString)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.textAndIcon5)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 10 * scale, height: 10 * scale)
                        }
                    }
                }
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
        if text.contains("^[a-zA-Z]*$") {
            inputFieldState = .error
        }
        
        if text.count < maxLength {
            inputFieldState = isFocused ? .selected : .unselected
        }
        
        if text.count > maxLength {
            inputFieldState = .error
        }
        
        if text.count == maxLength {
            inputFieldState = .success
        }
    }
}



struct InputPreview: View {
    @State private var text: String = ""
    @State private var pass: String = ""
    
    var body: some View {
        VStack {
            InputField(text: $text, title: "Username")
            InputField(text: $pass, isSecure: true, maxLength: 10, title: "Pin", promptString: "Only numeric input allowed")
            Spacer()
        }
        .padding(30)
        .background(Color.neutral1)
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
    
    /// Returns the prompt message based on the state, the error state uses the maximum length assigned by the input parameter.
    func promptMessage(_ message: String, maxLength: UInt16) -> String {
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
    var borderColor: Color {
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
    
    /// Returns the color associated with each prompt state.
    var promptColor: Color {
        switch self {
        case .unselected, .selected:
            return .textAndIcon3
        case .error:
            return .semanticNegative
        case .success:
            return .semanticPositive
        }
    }
    
    /// Returns a preset symbol, if available, associated with each prompt state.
    var promptImageString: String {
        switch self {
        case .unselected, .selected:
            return ""
        case .error:
            return "notice"
        case .success:
            return "checkmark"
        }
    }
}
