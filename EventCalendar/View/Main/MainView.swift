//
//  ContentView.swift
//  EventCalendar
//
//  Created by Angus on 2023/7/19.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \EventContent.date, ascending: true)], animation: .default)
    
    // MARK: - Property
    
    private var items: FetchedResults<EventContent>

    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.date!, formatter: itemFormatter)")
                    } label: {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .padding()
                            .background(.yellow)
                            .clipShape(Circle())
                        
                        Text(item.date!, formatter: itemFormatter)
                            .bold()
                            .padding(.leading, 20)
                            .foregroundStyle(.red)
                        
                        Text("\(item.title!)")
                            .bold()
                            .padding(.leading, 20)
                            .foregroundStyle(.red)
                        
                        Text("\(item.content!)")
                            .bold()
                            .padding(.leading, 20)
                            .foregroundStyle(.red)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle(Text("事件"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }

                }
            }
            
            Text("空的")
        }
    }
    
    // MARK: - Method

    private func addItem() {
        withAnimation {
            let newItem = EventContent(context: viewContext)
            newItem.date = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    
    return formatter
}()

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}
