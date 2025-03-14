//
//  UIApplication + Ext..swift
//  Notes
//
//  Created by Алексей Колыченков on 14.03.2025.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    ///resignFirstResponder
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
