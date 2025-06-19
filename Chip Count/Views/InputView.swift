//
//  Input.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

// Add things like # players, # bad beats, time started, location...
// Also add rankings, compared to this users other sessions

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InputView: View {
    
    @StateObject private var viewModel = InputViewModel()
    
    @FocusState private var buyInFocused: Bool
    @FocusState private var endTotalFocused: Bool
    
    @State var numPlayers: String = ""
    
    var body: some View {
            
        Form {
            Section(header: Text("Session Info")) {
                TextField("Number of Players", text: $numPlayers).keyboardType(.numberPad)
            }
        }
//        ZStack {
//            
//            Color.black
//                .ignoresSafeArea()
//            
//            ScrollView(.vertical, showsIndicators: true) {
//                
//                VStack{
//                    
//                    Text("New Session")
//                        .modifier(SmallTextStyle(color: .white))
//                    
//                    Divider()
//                        .frame(width: 350)
//                        .frame(height: 2)
//                        .background(Color.white)
//                        .padding(.vertical, 8)
//                    
//                    VStack{
//                        
//                        Text("Date")
//                            .modifier(SmallTextStyle(color: .white))
//                            .frame(maxWidth: 225, alignment: .leading)
//                        
//                        DatePicker(" ", selection: $viewModel.date, in: ...Date(), displayedComponents: [.date])
//                            .datePickerStyle(.wheel)
//                            .colorScheme(.dark)
//                            .frame(width: 300, height: 100)
//                            .cornerRadius(10)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.white, lineWidth:2)
//                            )
//                        
//                        Text("Buy In Total")
//                            .modifier(SmallTextStyle(color: .white))
//                            .frame(maxWidth: 225, alignment: .leading)
//                            .padding(.top, 20)
//                        
//                        HStack{
//                            Text("$")
//                                .modifier(SmallTextStyle(color: .white))
//                            
//                            TextField("", text: $viewModel.buyIn)
//                                .keyboardType(.decimalPad)
//                                .focused($buyInFocused)
//                                .onChange(of: viewModel.buyIn) {
//                                    if viewModel.buyIn.count > 8 {
//                                        viewModel.buyIn = String(viewModel.buyIn.prefix(8))
//                                    }
//                                }
//                                .textFieldStyle(PrimaryTextFieldStyle())
//                        }
//                        .background(Color.black)
//                        
//                        
//                        Text("End Total")
//                            .modifier(SmallTextStyle(color: .white))
//                            .frame(maxWidth: 225, alignment: .leading)
//                            .padding(.top, 20)
//                        
//                        
//                        HStack{
//                            Text("$")
//                                .modifier(SmallTextStyle(color: .white))
//                            
//                            TextField("", text: $viewModel.winnings)
//                                .keyboardType(.decimalPad)
//                                .focused($endTotalFocused)
//                                .onChange(of: viewModel.winnings) {
//                                    if viewModel.winnings.count > 8 {
//                                        viewModel.winnings = String(viewModel.winnings.prefix(8))
//                                    }
//                                }
//                                .textFieldStyle(PrimaryTextFieldStyle())
//                        }
//                        .background(Color.black)
//                        
//                        
//                        Text("Duration")
//                            .modifier(SmallTextStyle(color: .white))
//                            .frame(maxWidth: 225, alignment: .leading)
//                            .padding(.top, 20)
//                        
//                        DurationPicker(hours: $viewModel.hours, minutes: $viewModel.minutes)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.white, lineWidth:2)
//                            )
//                        
//                        Spacer()
//                        
//                    }
//                    
//                    Spacer()
//                    Spacer()
//                    
////                    Button("Save"){ viewModel.saveSession(context: viewContext) {} }
////                        .buttonStyle(PrimaryButtonStyle())
//                    
//                    Spacer()
//                    
//                }
//            }
//            .scrollDismissesKeyboard(.interactively)
//        }
//        .onTapGesture {
//            hideKeyboard()
//        }
//        .alert("Error", isPresented: $viewModel.showAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text(viewModel.alertMessage)
//        }
//        .toolbar {
//            if buyInFocused || endTotalFocused {
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("Done") {
//                        buyInFocused = false
//                        endTotalFocused = false
//                    }
//                }
//            }
//        }
    }
    
}

struct DurationPicker: View {
    
    @Binding var hours: Int
    @Binding var minutes: Int
    
    let allMinutes = Array(stride(from: 0, through: 45, by: 15))
    
    var body: some View {
        
        HStack {
        
            Picker("Hours", selection: $hours) {
                ForEach(0..<24) { h in
                    Text("\(h)").tag(h)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .colorScheme(.dark)
            .frame(width: 80)
            
            Text(":")
                .modifier(LargeTextStyle(color: .white))
                .padding(.bottom)
            
            Picker("Minutes", selection: $minutes) {
                ForEach(allMinutes, id: \.self) { m in
                    Text("\(m)").tag(m)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .colorScheme(.dark)
            .frame(width: 80)
        }
        .frame(width: 300, height: 100)
        .cornerRadius(10)
    }
}

#Preview {
    InputView()
}
