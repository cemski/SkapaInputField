//
//  InputFieldStates.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-21.
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
