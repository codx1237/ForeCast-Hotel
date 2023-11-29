//
//  AlertTypes.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 22.10.2023.
//

import SwiftUI

enum AlertTypes: Identifiable {
    
    case noButton(title: String,
                            message: String? = nil)
    
    case oneButton(title: String,
                      message: String? = nil,
                      dismissButton: Alert.Button)
    
    case twoButton(title: String,
                      message: String? = nil,
                      primaryButton: Alert.Button ,
                      secondaryButton: Alert.Button)
    
    var alert: Alert {
        switch self {
        case .noButton(title: let title,
                            message: let message):
            
            return Alert(title: Text(title),
                         message: message != nil ? Text(message!) : nil)
            
        case .oneButton(title: let title,
                           message: let message,
                           dismissButton: let dismissButton):
            
            return Alert(title: Text(title),
                         message: message != nil ? Text(message!) : nil,
                         dismissButton: dismissButton)
            
        case .twoButton(title: let title,
                         message: let message,
                         primaryButton: let primaryButton,
                         secondaryButton: let secondaryButton):
            
            return Alert(title: Text(title),
                         message: message != nil ? Text(message!) : nil,
                         primaryButton: primaryButton,
                         secondaryButton: secondaryButton)
        }
    }
    
    var id: String {
        switch self {
        case .noButton:
            return "noButton"
        case .oneButton:
            return "oneButton"
        case .twoButton:
            return "twoButton"
        }
    }
    
}
