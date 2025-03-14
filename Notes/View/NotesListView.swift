//
//  ContentView.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI

struct NotesListView: View {
    
    @StateObject private var vm = NotesListViewModel()
    
//    var tasks: [Todo] = [Todo(id: 1, todo: "Test", completed: true, userID: 1), Todo(id: 2, todo: "Test2", completed: false, userID: 1), Todo(id: 3, todo: "Test3", completed: true, userID: 1)]
    
    var body: some View {
        List {
            ForEach(vm.notes, id: \.id) { item in
                ListRow(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            //vm.updateTask(item: item)
                        }
                    }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Задачи")
        .onAppear {
//            fetchDatafromAPI()
        }
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
