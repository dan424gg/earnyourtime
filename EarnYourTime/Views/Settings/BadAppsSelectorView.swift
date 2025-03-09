//
//  BadAppsView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

import SwiftUI
import FamilyControls

struct BadAppsSelectorView: View {
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage("familySelections") private var familySelectionsData: Data = Data()
    @Environment(\.dismiss) var dismiss
        
    private func loadBadSelections() {
        if let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: familySelectionsData) {
            deviceActivityModel.badSelections = decoded
        }
    }
    
    private func saveBadSelections() {
        if let encoded = try? JSONEncoder().encode(deviceActivityModel.badSelections) {
            familySelectionsData = encoded
        }
    }

    var body: some View {
        @Bindable var bindable_model = deviceActivityModel

        NavigationView {
            FamilyActivityPicker(selection: $bindable_model.badSelections)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "hand.thumbsdown")
                            .fontWeight(.bold)
                        Text("Bad Apps")
                            .foregroundStyle(Color.bad)
                            .font(.title.bold())
                    }
                    .padding(.top, 50)
                }
            }
            .onAppear {
                loadBadSelections()
            }
            .safeAreaInset(edge: .bottom) {
                SaveButton(disabled: bindable_model.badSelections.applicationTokens == [] || bindable_model.badSelections.categoryTokens == [] || bindable_model.badSelections.webDomainTokens == []) {
                    saveBadSelections()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    BadAppsSelectorView()
}
