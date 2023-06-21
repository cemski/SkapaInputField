//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI

struct InputField: View {
    /// A boolean value that determines if the InputField is currently in focus.
    @FocusState var isFocused: Bool
    /// A float value representing the scaling factor when used for accessibility.
    @ScaledMetric var scale: CGFloat = 1
    /// The view-model responsible for handling all of the data in the view.
    @StateObject private var viewModel: InputFieldViewModel

    init(model: InputFieldModel) {
         _viewModel = StateObject(wrappedValue: InputFieldViewModel(model: model))
     }
    
    var body: some View {
        VStack {
            setupTopStack(title: viewModel.model.title)
            setupInputFields()
            setupBottomStack(prompt: viewModel.model.promptString)
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
                    viewModel.adjustStateOnFocusChange(focus: focus)
                }
                .onChange(of: viewModel.model.text) { text in
                    viewModel.validateString(text)
                }
                .frame(maxWidth: .infinity, maxHeight: 26 * scale) // minheight
                .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
                .font(.bodyL)
                .textFieldStyle(.plain)
                .background(Color.neutral1)
                .foregroundColor(.textAndIcon1)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(viewModel.model.inputFieldState.borderColor, lineWidth: isFocused ? 2 : 1)
                )
        }
        .padding(.bottom, 4)
    }
    
    private func determineInputField() -> some View {
        Group {
            if viewModel.model.isSecure {
                HStack {
                    if viewModel.model.isTextHidden {
                        SecureField(viewModel.model.placeholder, text: $viewModel.model.text)
                            .accessibilityIdentifier("password")
                    } else {
                        TextField(viewModel.model.placeholder, text: $viewModel.model.text)
                            .accessibilityIdentifier("visiblePassword")
                    }
                    Button(action: {
                        viewModel.model.isTextHidden.toggle()
                    }, label: {
                        Image(viewModel.model.isTextHidden ? "eye" : "eye.slash")
                            .renderingMode(.template)
                            .foregroundColor(.textAndIcon1)
                    })
                    .accessibilityIdentifier("visibilityButton")
                }
                
            } else {
                TextField(viewModel.model.placeholder, text: $viewModel.model.text)
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
            if let prompt = viewModel.model.promptString {
                
                Label {
                    Text(viewModel.getPromptMessage(prompt: prompt))
                        .font(.bodyS)
                        .foregroundColor(viewModel.model.inputFieldState.promptColor)
                } icon: {
                    if viewModel.model.inputFieldState != .selected  &&
                        viewModel.model.inputFieldState != .unselected {
                        ZStack(alignment: .center) {
                            
                            Circle()
                                .fill(viewModel.model.inputFieldState.promptColor)
                                .frame(width: 16 * scale, height: 16 * scale)
                                .padding(2)
                            Image(viewModel.model.inputFieldState.promptImageString)
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
            if viewModel.isCharacterCountBelowLimit() {
                Text(viewModel.getCharacterCountOverTotal())
                    .accessibilityIdentifier("counter")
                    .font(.bodyS)
                    .foregroundColor(.textAndIcon3)
            }
        }
    }
}



struct InputPreview: View {    
    private var usernameModel = InputFieldModel(text: "", title: "Username")
    private var passModel = InputFieldModel(text: "", isSecure: true, maxLength: 8, title: "Pin", promptString: "Only numeric input allowed")

    var body: some View {
        VStack {
            InputField(model: usernameModel)
            InputField(model: passModel)
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

enum ValidationError: Error {
    case char, long, short
    
    func validation(string: String) -> String {
        if string.contains("Chars") {
            return ValidationError.char.message
        } else if string.count < 10 {
            return ValidationError.short.message
        } else if string.count > 10 {
            return ValidationError.long.message
        }
        return ""
    }
    
    var message: String {
        switch self {
        case .char:
            return "The input contains illegal input"
        case .long:
            return "The input is too long"
        case .short:
            return "short"
        }
    }
}


/// Enum defining different states for the input field.
enum InputFieldStates: Equatable {
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
