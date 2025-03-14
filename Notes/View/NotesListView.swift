//
//  ContentView.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI

struct NotesListView: View {
    
    @StateObject private var vm = NotesListViewModel()
    
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $vm.searchText)
            List {
                ForEach(vm.notes, id: \.id) { item in
                    ListRow(isCompleted: item.completed, todo: item.todo, checkmarkTapped: {
                        vm.selectedTodo = item
//                        vm.updateTodo()
                    })
                        .onTapGesture {
                            withAnimation(.linear) {
                                //vm.updateTask(item: item)
                                
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .onAppear {
                //            fetchDatafromAPI()
            }
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
        NotesListView()
    }
}
