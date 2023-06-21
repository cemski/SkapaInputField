//
//  InputFieldModel.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-21.
//

import Foundation
import SwiftUI

struct InputFieldModel {
    var text: String
    /// A boolean value that determines if the presented InputField should use secure entry, commonly used for passwords.
    ///
    /// This property is set to false by default. Setting this property to true will set the InputField to use a SecureField instead which disables the user’s ability to copy the text in the view and, in some cases, also disables the user’s ability to record and broadcast the text in the view.
    var isSecure: Bool = false
    /// A boolean value that determines whether the currently displayed SecureField has visible text.
    ///
    /// This property is set to true by default. Setting this property to false will enable the user to see the current text of the InputField.
    var isTextHidden: Bool = true
    /// A custom enum (TextEntryStates) which sets the
    var inputFieldState: InputFieldStates = .unselected
    /// A UInt16 value that determines the maximum characters allowed for input.
    ///
    /// This property is set to 0 by default. Using the default value the InputField will not to trigger any other states than the selected and unselected states. By using the UInt type instead of Int we can ensure that a negative value cannot be assigned.
    var maxLength: UInt16 = 0
    /// A string that displays the title for the InputField, helpful for explaining what the InputField below is used for.
    ///
    /// This property is optional in case there isn't a need for a title. By not supplying a title, the top row will not be rendered.
    var title: String? = ""
    /// A string that is displayed as the prompt message for the InputField, helpful for explaining any restrictions that may apply.
    var promptString: String?
    /// A string that is displayed as the error message for the InputField, helpful for explaining that the user has made an input that is not allowed.
    var errorString: String? = ""
    /// A string value that can be to give the user a suggestion on what an input should look like.
    ///
    /// This property has the default value of an empty string as the constructor for TextField/Securefield needs a string.
    var placeholder: String = ""
}
