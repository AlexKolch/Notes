//
//  SearchBarView.swift
//  Notes
//
//  Created by Алексей Колыченков on 14.03.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? .gray : .white
                )
            
            TextField("Search", text: $searchText)
                .autocorrectionDisabled(true)
                .foregroundStyle(.gray)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10.0)
                        .foregroundStyle(.gray)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing() //скрывает клавиатуру
                            searchText = ""
                        }
                }
                .overlay(alignment: .trailing) {
                    Image(systemName: "microphone.fill")
                        .foregroundStyle(.gray)
                        .opacity(searchText.isEmpty ? 1.0 : 0.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing() //скрывает клавиатуру
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 25.0)
            .fill(.gray)
            .shadow(color: .textFieldBG, radius: 10)
            .opacity(0.20)
        ).padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
