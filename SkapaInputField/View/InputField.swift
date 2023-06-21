//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI
/// A control that displays an editable text interface. Is configurable to support secure text, character limit as well as different states (see ``InputFieldStates``). The InputField has a text title above it which replaces the usual need for a placeholder. There is a text below the InputField as well which is used for showing the current prompt or error/success prompt with an associated icon. Enabling the **isSecure** property sets the InputField into a secure state where the input is obstructed. When in in this state there is a button present on the right-hand side which is used to toggle visibility.
///
/// The following example shows a InputField is bound with a $username and an InputField that doesn't have a character limit or trigger any error/success states the code shown below should suffice.
///
///     @State private var username: String = ""
///     @State private var userState: InputFieldStates = .unselected
///
///     InputField(
///      text: $username,
///      state: $userState,
///      title: "Username")
///     )
///
/// The following example shows a InputField with more options enabled. In this scenario the entry method is set to secure, a maximum limit of 8 characters is set as well as a prompt to help the user is passed in.
///
///     @State private var password: String = ""
///     @State private var passwordState: InputFieldStates = .unselected
///
///     InputField(
///      text: $password,
///      isSecure: true,
///      state: $passwordState,
///      title: "Password",
///      promptString: "Maximum 8 characters",
///      maxLength: 8)
///
///
///
struct InputField: View {
    // State Variables
    /// A binding string that the InputField displays.
    @Binding var text: String
    /// A boolean value that determines if the InputField is currently in focus.
    @FocusState var isFocused: Bool
    /// A boolean value that determines if the presented InputField should use secure entry, commonly used for passwords.
    ///
    /// This property is set to false by default. Setting this property to true will set the InputField to use a SecureField instead which disables the user’s ability to copy the text in the view and, in some cases, also disables the user’s ability to record and broadcast the text in the view.
    @State var isSecure: Bool
    /// A boolean value that determines whether the currently displayed SecureField has visible text.
    ///
    /// This property is set to true by default. Setting this property to false will enable the user to see the current text of the InputField.
    @State var isTextHidden: Bool
    /// A custom enum (TextEntryStates) which sets the
    @Binding var state: InputFieldStates
    
    // Other properties
    /// A UInt16 value that determines the maximum characters allowed for input.
    ///
    /// This property is set to 0 by default. This will cause the InputField not to  trigger any other states than the selected and unselected states.
    var maxLength: UInt16
    /// A string that displays the title for the InputField, helpful for explaining what the InputField below is used for.
    ///
    /// This property is optional in case there isn't a need for a title. By not supplying a title, the top row will not be rendered.
    var title: String?
    /// A string that is displayed as the prompt message for the InputField, helpful for explaining any restrictions that may apply.
    var promptString: String?
    
    
    /// The initializer will have default values for the fields not required to use a secure entry approach. The **isTextHidden** property is always set to true even though it only comes into effect if the **isSecure** property is set to true as well. The title and promptString have optional nil values that disables the top and bottom to be rendered respectively. If you set up a InputField with all of the properties you are most likely setting up an InputField for secure entry. An example would look like the following code:
    ///
    ///      InputField(
    ///      text: $password,
    ///      isSecure: true,
    ///      state: $passwordState,
    ///      title: "Password",
    ///      promptString: "Maximum 8 characters",
    ///      maxLength: 8)
    ///
    public init(text: Binding<String>, isSecure: Bool = false, state: Binding<InputFieldStates>, title: String? = nil, promptString: String? = nil, maxLength: UInt16 = 0) {
        self._text = text
        self.isSecure = isSecure
        self.isTextHidden = true
        self._state = state
        self.maxLength = maxLength
        self.title = title
        self.promptString = promptString
    }
    
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
                    adjustFocus(focus: focus)
                }
                .onChange(of: text) { _ in
                    validateInput()
                }
                .frame(maxWidth: .infinity, minHeight: 26)
                .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
                .font(.bodyL)
                .textFieldStyle(.plain)
                .background(Color.neutral1)
                .foregroundColor(.textAndIcon1)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(self.state.borderColor, lineWidth: isFocused ? 2 : 1)
                )
        }
        .padding(.bottom, 4)
    }
    
    /// A private helper method to determine if a TextField or SecureField is to be used depending on the variables set for the InputField.
    ///
    /// - Returns: The desired type of Textfield/SecureField
    private func determineInputField() -> some View {
        Group {
            if isSecure {
                HStack {
                    if isTextHidden {
                        SecureField("", text: $text)
                            .accessibilityIdentifier("password")
                    } else {
                        TextField("", text: $text)
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
                TextField("", text: $text)
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
    
    private func setupBottomStack(prompt: String?) -> some View {
        HStack(alignment: .center, spacing: 0) {
            if let prompt = promptString {
                
                Label {
                    Text(state.promptMessage(prompt, maxLength: maxLength))
                        .font(.bodyS)
                        .foregroundColor(state.promptColor)
                } icon: {
                    if state != .selected  && !(state.promptImageString.isEmpty) {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(state.promptColor)
                                .frame(width: 16, height: 16)
                            Image(state.promptImageString)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.textAndIcon5)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 10, height: 10)
                        }
                        .padding(2)
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
    
    /// Sets the current state to selected or unselected if the InputField isn't displaying an error/success state.
    func adjustFocus(focus: Bool) {
        if !(state == .error) && !(state == .success)  {
            state = focus ? .selected : .unselected
        }
    }
    
    /// Default verification for the InputField. Triggers different states depending on the input count compared to the maxLength provided (default is 0).
    func validateInput() {
        guard maxLength > 0 else {
            state = .selected
            return
        }
        
        guard (text.range(of: "^[0-9]*$", options: .regularExpression) != nil) else {
            state = .error
            return
        }
        
        if text.count < maxLength {
            state = isFocused ? .selected : .unselected
        }
        
        if text.count > maxLength {
            state = .error
        }
        
        if text.count == maxLength {
            state = .success
        }
    }
}



struct InputPreview: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var usernameState = InputFieldStates.unselected
    @State var passwordState = InputFieldStates.unselected
    
    var body: some View {
        VStack {
            InputField(text: $username,
                       state: $usernameState,
                       title: "Username")
            InputField(text: $password,
                       isSecure: true,
                       state: $passwordState,
                       title: "Pin",
                       promptString: "Only numeric input allowed",
                       maxLength: 8)
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
