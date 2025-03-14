//
//  Button + Ext.swift
//  Notes
//
//  Created by Алексей Колыченков on 14.03.2025.
//

import SwiftUI

struct BackBtn: View {
    let title: String = "Назад"
    let systemImage: String = "chevron.left"
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
            Text(title)
        }
        .foregroundStyle(.yellow)
    }
}
