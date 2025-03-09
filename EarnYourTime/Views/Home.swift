//
//  Home.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

import FamilyControls
import SwiftUI
import DeviceActivity

struct Home: View {
    @Environment(DeviceActivityModel.self) private var model
    @State var goodSelectorPresented: Bool = false
    @State var badSelectorPresented: Bool = false
    @State var goodAppTime: Int?
    @State var badAppTime: Int?
    @State var checkpointTime: Int?
    
    @State private var goodContext: DeviceActivityReport.Context = .init(rawValue: "GoodActivity")
    @State private var badContext: DeviceActivityReport.Context = .init(rawValue: "BadActivity")
    @State private var goodFilter: DeviceActivityFilter?
    @State private var badFilter: DeviceActivityFilter?
    
    
    var body: some View {
        @Bindable var bindable_model = model
        
        VStack {
            HStack {
                if goodFilter != nil {
                    DeviceActivityReport(goodContext, filter: goodFilter!)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(10)
                } else {
                    Text("Nothing yet")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if badFilter != nil {
                    DeviceActivityReport(badContext, filter: badFilter!)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(10)
                } else {
                    Text("Nothing yet")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

            VStack(spacing: 15) {
//                TextField("Good App Time", value: $goodAppTime, format: .number)
//                    .padding([.leading, .trailing], 100)
//                    .keyboardType(.numberPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .multilineTextAlignment(.center)
                
                TextField("Bad App Time", value: $badAppTime, format: .number)
                    .padding([.leading, .trailing], 100)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)

                TextField("Checkpoint Time", value: $checkpointTime, format: .number)
                    .padding([.leading, .trailing], 100)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)

                Button("Select the good apps") {
                    goodSelectorPresented = true
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .familyActivityPicker(isPresented: $goodSelectorPresented, selection: $bindable_model.goodSelections)

                Button("Select the bad apps") {
                    badSelectorPresented = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .familyActivityPicker(isPresented: $badSelectorPresented, selection: $bindable_model.badSelections)

                
                HStack {
                    Button("Start Monitoring") {
                        do {
                            try model.startMonitoring(badAppTime: badAppTime ?? 0, checkpointTime: checkpointTime ?? 15)
                        } catch {
                            print("couldn't start monitoring\n\(error))")
                        }
                        
                        goodFilter = DeviceActivityFilter(
                            segment: .daily(
                                during: DateInterval(
                                    start: .now,
                                    end: Calendar.current.startOfDay(for: .now).addingTimeInterval(86400 - 1)
                                )
                            ),
                            devices: .init([.iPhone, .iPad]),
                            applications: model.goodSelections.applicationTokens
                        )
                        
                        badFilter = DeviceActivityFilter(
                            segment: .daily(
                                during: DateInterval(
                                    start: .now,
                                    end: Calendar.current.startOfDay(for: .now).addingTimeInterval(86400 - 1)
                                )
                            ),
                            devices: .init([.iPhone, .iPad]),
                            applications: model.badSelections.applicationTokens
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                    Button("Stop Monitoring") {
                        model.stopMonitoring()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                endTextEditing()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Home()
        .environment(DeviceActivityModel())
}
