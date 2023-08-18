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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)], animation: .default)
    
    // MARK: - Property
    
    private var events: FetchedResults<Event>

    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    NavigationLink {
                        Text("Item at \(event.startDate!, formatter: itemFormatter)")
                    } label: {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .padding()
                            .background(.yellow)
                            .clipShape(Circle())
                        
                        Text(event.startDate!, formatter: itemFormatter)
                            .bold()
                            .padding(.leading, 20)
                            .foregroundStyle(.red)
                        
                        Text("\(event.title!)")
                            .bold()
                            .padding(.leading, 20)
                            .foregroundStyle(.red)
                        
                        Text("\(event.content!)")
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
            let newEvent = Event(context: viewContext)
            newEvent.startDate = Date()

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
            offsets.map { events[$0] }.forEach(viewContext.delete)

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
