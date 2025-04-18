//
//  GoodAppsView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

import SwiftUI
import FamilyControls


struct GoodAppsSelectorView: View {
    var updateMonitoring: Bool = true
    
    @State private var tempFamilySelectionsData: FamilyActivitySelection = FamilyActivitySelection()
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage(StorageKey.goodFamilySelections.rawValue) private var familySelectionsData: Data = Data()
    @Environment(\.dismiss) var dismiss
            
    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $tempFamilySelectionsData)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                            .fontWeight(.bold)
                        Text("Good Apps")
                            .foregroundStyle(Color.good)
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
                    if updateMonitoring {
                        deviceActivityModel.updateMonitoring()
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    GoodAppsSelectorView()
}
