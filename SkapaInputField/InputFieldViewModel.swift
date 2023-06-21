//
//  InputFieldViewModel.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-20.
//

import SwiftUI

class InputFieldViewModel: ObservableObject {
    @Published var model: InputFieldModel
    
    init(model: InputFieldModel) {
        self.model = model
    }
    
    /// Returns a counter for the current number of characters and maximum allowed. Will return an empty string if maxLength is set to 0 which is the default value.
    ///
    /// - Returns: current input count / maximum length
    ///
    /// Example: the current input count is 6 and the maximum length is set to 8 yields the result: "6/8"
    func getCharacterCountOverTotal() -> String {
        guard model.maxLength > 0 else { return "" }
        return "\(model.text.count)/\(model.maxLength)"
    }
    
    /// Returns a boolean based on if input is shorter than the maxLength property. Will return false if maxLength is set to 0 which is the default value.
    ///
    /// - Returns: the truthfulness of the input meeting the criteria
    func isCharacterCountBelowLimit() -> Bool {
        return (model.maxLength > 0  && model.text.count < model.maxLength)
    }
    
    /// Sets the state of the InputField to match if it is currently selected. Skips changing the state back to .unselected when unfocusing if the state is already set to display an error or success state. Preferrably to be used with the .focused modifier.
    /// - Parameters:
    /// - Parameter focus: Boolean value for the current focus state.
    func adjustStateOnFocusChange(focus: Bool) {
        if (model.inputFieldState == .error) == false && (model.inputFieldState == .success) == false {
            model.inputFieldState = focus ? .selected : .unselected
        }
    }
    
    /// Returns the prompt message associated with the current state of the InputFieldView. Since the prompt is customizable on initialization it is taken as a parameter. Will return a blank string if the promptString property is not set for the model.
    /// - Parameters:
    /// -   Parameter prompt: The default prompt to be displayed.
    /// - Returns: The string associated with the current state.
    func getPromptMessage(prompt: String) -> String {
        return model.inputFieldState.promptMessage(prompt, maxLength: model.maxLength)
    }
    
    /// Default verification for the InputField.
    ///
    /// Takes the provided input string and sets the associated state depending on the outcome. Will set the current state to .selected if the maxLength is set to 0 (default).
    ///
    /// The outcomes are:
    /// - length < maxLength = selected
    /// - length > max = error
    /// - string contains letters = error
    /// - length == max = success
    /// - Parameters:
    /// - Parameter string: The string to be validated
    func validateString(_ string: String) {
        guard model.maxLength > 0 else {
            model.inputFieldState = .selected
            return
        }
        
        guard string.count > 0 && !(string.range(of: ("[A-Za-z]+"), options: .regularExpression) != nil) else {
            model.inputFieldState = .error
            return
        }
        
        guard !(string.count > model.maxLength) else {
            model.inputFieldState = .error
            return
        }
        
        if string.count == model.maxLength {
            model.inputFieldState = .success
        } else  {
            model.inputFieldState = .selected
        }
    }
}
