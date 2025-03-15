//
//  DetailView.swift
//  Notes
//
//  Created by Алексей Колыченков on 14.03.2025.
//

import SwiftUI
import SwiftfulRouting

struct DetailView: View {
    @ObservedObject var vm: NotesListViewModel
    var title: String
    let date: String
    @State var content: String = ""
    @Environment(\.router) var router
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .padding(.top, 8)
                .padding(.bottom, 6)
            Text(date)
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(.bottom, 16)
            TextEditor(text: $content)
                .overlay(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Напишите текст")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            Spacer()
        }
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.dismissScreen()
                } label: {
                    BackBtn()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            print("onDisappear")
            if vm.selectedTodo != nil {
                vm.updateTodo(newTodo: content)
            } else {
                addNewTodo()
            }
        }
    }
    
    private func addNewTodo() {
        guard content != "" else { return }
        let newTodo = Todo(id: Int.random(in: 0..<100000), todo: content, completed: false)
        vm.addTodo(newTodo: newTodo)
    }
}

#Preview {
    RouterView { router in
        DetailView(vm: NotesListViewModel(router: router), title: "Заняться спортом", date: "02.10.24", content: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.")
    }
}
