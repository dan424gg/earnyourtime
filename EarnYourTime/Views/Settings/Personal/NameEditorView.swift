//
//  NameEditorView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

struct NameEditorView: View {
    @State private var tempName: String = ""
    @AppStorage(StorageKey.fullName.rawValue) var name: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter your name", text: $tempName)
            }
            .onAppear {
                tempName = name
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "person")
                            .fontWeight(.bold)
                        Text("What is your name?")
                            .font(.title.bold())
                    }
                    .padding(.top, 50)
                }
            }
            .safeAreaInset(edge: .bottom) {
                SaveButton(disabled: tempName == "") {
                    name = tempName
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NameEditorView()
}
