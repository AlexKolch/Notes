//
//  ListRow.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI

struct ListRow: View {
    
    let item: Todo
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(alignment: .top, spacing: 8.0) {
                Image(systemName: item.completed ? "checkmark.circle" : "circle")
                    .foregroundStyle(item.completed ? .yellow : .gray)
                VStack(alignment: .leading, spacing: 6.0) {
                    Text("Task title placeholder")
                        .strikethrough(item.completed)
                    Text(item.todo)
                    Text(dateFormatter.string(from: Date()))
                        .foregroundStyle(.gray)
                }
                .foregroundStyle(item.completed ? .gray : .white)
            }
            Rectangle()
                .frame(height: 1)
                .opacity(0.5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ListRow(item: Todo(id: 1, todo: "Test", completed: true))
    }
  
}
