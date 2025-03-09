//
//  GoodAppsView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

import SwiftUI
import FamilyControls

struct GoodAppsSelectorView: View {
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage("familySelections") private var familySelectionsData: Data = Data()
    @Environment(\.dismiss) var dismiss
        
    private func loadBadSelections() {
        if let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: familySelectionsData) {
            deviceActivityModel.goodSelections = decoded
        }
    }
    
    private func saveBadSelections() {
        if let encoded = try? JSONEncoder().encode(deviceActivityModel.goodSelections) {
            familySelectionsData = encoded
        }
    }

    var body: some View {
        @Bindable var bindable_model = deviceActivityModel

        NavigationView {
            FamilyActivityPicker(selection: $bindable_model.goodSelections)
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
                loadBadSelections()
            }
            .safeAreaInset(edge: .bottom) {
                SaveButton(disabled: bindable_model.goodSelections.applicationTokens == [] || bindable_model.goodSelections.categoryTokens == [] || bindable_model.goodSelections.webDomainTokens == []) {
                    saveBadSelections()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    GoodAppsSelectorView()
        .environment(DeviceActivityModel())
}
