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
            ZStack(alignment: .top) {
                Rectangle().fill(.bottomBG)
                    .overlay(alignment: .center) {
                            Text("\(vm.notes.count) Задач")
                            .frame(maxWidth: .infinity, alignment: .top)
                            .padding(.bottom)
                    }
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 28)
                            .foregroundStyle(.yellow)
                            .padding()
                            .background(.black.opacity(0.001))
                            .onTapGesture {
                                vm.router.showScreen(.push) { _ in
                                    DetailView(vm: vm, title: "", date: Date().description, content: "")
                                }
                            }
                    }
            }
            .frame(width: UIScreen.main.bounds.width, height: 83)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .bottom)
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
