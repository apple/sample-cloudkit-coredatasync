//
//  AddContactView.swift
//  CoreDataSync
//

import Foundation
import SwiftUI

/// View for adding new contacts.
struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var image: UIImage?
    @State private var isShowingImagePicker: Bool = false
    @State private var nameInput: String = ""

    /// Callback after user selects to add contact with given name and image.
    let onAdd: ((String, UIImage?) -> Void)?
    /// Callback after user cancels.
    let onCancel: (() -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    contactImage.onTapGesture {
                        self.isShowingImagePicker = true
                    }
                    TextField("Full Name", text: $nameInput)
                        .textContentType(.name)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Add Contact")
            .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                isShowingImagePicker = false
            }, content: {
                ImagePicker(selectedImage: $image)
            })
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { onCancel?() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: { onAdd?(nameInput, image) })
                        .disabled(nameInput.isEmpty)
                }
            }
        }
    }

    var contactImage: some View {
        if let image = image {
            return AnyView(Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64, alignment: .center)
                            .clipped())
        } else {
            return AnyView(Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64, alignment: .center)
                            .foregroundColor(.gray))
        }
    }
}
