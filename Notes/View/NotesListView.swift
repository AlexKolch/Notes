//
//  ContentView.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI
import SwiftfulRouting

struct NotesListView: View {
    
    @StateObject var vm: NotesListViewModel
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $vm.searchText)
            
            List {
                ForEach(vm.notes, id: \.id) { item in
                    ListRow(isCompleted: item.completed, todo: item.todo, checkmarkTapped: {
                        vm.selectedTodo = item
                        vm.updateStatusTodo()
                    })
                    .onTapGesture {
                        vm.selectedTodo = item
                        vm.router.showScreen(.push) { _ in
                            DetailView(vm: vm, title: "Task title placeholder", date: Date().description, content: item.todo)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .listStyle(.plain)
            .navigationTitle("Задачи")
        }
        .frame(maxWidth: .infinity)
//        .refreshable {
//            vm.updateNote()
//        }
    }
    
//    private func fetchDatafromAPI() {
//        DispatchQueue.global().async {
//            vm.fetchTasksfromNetwork()
//        }
//    }
}

#Preview {
    NavigationStack {
        RouterView { router in
            NotesListView(vm: NotesListViewModel(router: router))
        }
    }
}
