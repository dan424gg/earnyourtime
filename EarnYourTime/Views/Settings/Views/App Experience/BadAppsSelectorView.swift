//
//  BadAppsView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

import SwiftUI
import FamilyControls

struct BadAppsSelectorView: View {
    var updateMonitoring: Bool = true
    var askConfirmation: Bool = true

    @State private var tempFamilySelectionsData: FamilyActivitySelection = FamilyActivitySelection()
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage(StorageKey.badFamilySelections.rawValue) private var familySelectionsData: Data = Data()
    @Environment(\.dismiss) var dismiss
    @State private var showConfirmation: Bool = false
        
    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $tempFamilySelectionsData)
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
            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                tempFamilySelectionsData = decode(FamilyActivitySelection.self, from: familySelectionsData, defaultValue: FamilyActivitySelection())
            }
            .safeAreaInset(edge: .bottom) {
                ActionButton(disabled: tempFamilySelectionsData == FamilyActivitySelection()) {
                    familySelectionsData = encode(tempFamilySelectionsData)
                    
                    // check if monitoring should be updated
                    if updateMonitoring {
                        
                        //check if confirmation is needed (ie. not in onboarding view)
                        if askConfirmation {
                            showConfirmation = true
                        } else {
                            deviceActivityModel.updateMonitoring()
                            dismiss()
                        }
                    } else {
                        dismiss()
                    }
                }
            }
            .alert("Confirmation", isPresented: $showConfirmation) {
                Button("Cancel", role: .cancel) {}
                
                Button("Ok") {
                    deviceActivityModel.updateMonitoring()
                    dismiss()
                }
            } message: {
                Text("Updating this will reset monitoring using today’s data, which might temporarily skew your stats. Things should normalize within a day.")
            }
        }
    }
}

#Preview {
    BadAppsSelectorView()
}
