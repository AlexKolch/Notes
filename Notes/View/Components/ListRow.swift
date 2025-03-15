//
//  ListRow.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI

struct ListRow: View {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    var isCompleted: Bool = false
    var todo: String
    var checkmarkTapped: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(alignment: .top, spacing: 8.0) {
                Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                    .foregroundStyle(isCompleted ? .yellow : .gray)
                    .onTapGesture {
                        checkmarkTapped?()
                    }
                VStack(alignment: .leading, spacing: 6.0) {
                    Text("Placeholder")
                        .strikethrough(isCompleted)
                    Text(todo)
                    Text(dateFormatter.string(from: Date()))
                        .foregroundStyle(.gray)
                }
                .foregroundStyle(isCompleted ? .gray : .white)
            }
            Rectangle()
                .frame(height: 1)
                .opacity(0.5)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ListRow(isCompleted: true, todo: "Test")
    }
  
}
