//
//  ContentView.swift
//  CoreDataSync
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Contact>

    @State private var isShowingAddView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(contacts) { contact in
                    HStack {
                        if let image = contact.photo {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64, alignment: .center)
                                .clipped()
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 64, height: 64, alignment: .center)
                                .foregroundColor(.gray)
                        }
                        Text(contact.name ?? "None")
                    }
                }
                .onDelete(perform: deleteContacts)
            }
            .navigationTitle("Core Data Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isShowingAddView = true }) { Image(systemName: "plus") }
                }
            }
        }
        .sheet(isPresented: $isShowingAddView, content: {
            AddContactView(onAdd: { name, image in
                isShowingAddView = false
                addContact(name: name, photo: image)
            }, onCancel: { isShowingAddView = false })
        })
    }

    private func addContact(name: String, photo: UIImage?) {
        let newContact = Contact(context: viewContext)
        newContact.name = name
        newContact.photo = photo

        do {
            try viewContext.save()
        } catch {
            fatalError("Error: \(error)")
        }
    }

    private func deleteContacts(offsets: IndexSet) {
        offsets.map { contacts[$0] }.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
