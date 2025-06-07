//
//  Input.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InputView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var date: Date = Date()
    @State private var buyIn: String = ""
    @State private var winnings: String = ""
    @State private var duration: String = ""
    
    @FocusState private var buyInFocused: Bool
    @FocusState private var endTotalFocused: Bool
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var hours = 0
    @State private var minutes = 0
    
    var body: some View {
            
        ZStack {
            
            Color.black
                .ignoresSafeArea(.all)
                .ignoresSafeArea(.keyboard)
            
            ScrollView{
                
                VStack{
                    
                    Text("New Session")
                        .modifier(SmallTextStyle(color: .white))
                    
                    Divider()
                        .frame(width: 350)
                        .frame(height: 2)
                        .background(Color.white)
                        .padding(.vertical, 8)
                    
                    VStack{
                        
                        Text("Date")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                        
                        DatePicker(" ", selection: $date, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .frame(width: 300, height: 100)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth:2)
                            )
                        
                        Text("Buy In Total")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                            .padding(.top, 20)
                        
                        HStack{
                            Text("$")
                                .modifier(SmallTextStyle(color: .white))
                            
                            TextField("", text: $buyIn)
                                .keyboardType(.decimalPad)
                                .focused($buyInFocused)
                                .onChange(of: buyIn) {
                                    if buyIn.count > 8 {
                                        buyIn = String(buyIn.prefix(8))
                                    }
                                }
                                .textFieldStyle(PrimaryTextFieldStyle())
                        }
                        .background(Color.black)
                        
                        
                        Text("End Total")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                            .padding(.top, 20)
                        
                        
                        HStack{
                            Text("$")
                                .modifier(SmallTextStyle(color: .white))
                            
                            TextField("", text: $winnings)
                                .keyboardType(.decimalPad)
                                .focused($endTotalFocused)
                                .onChange(of: winnings) {
                                    if winnings.count > 8 {
                                        winnings = String(winnings.prefix(8))
                                    }
                                }
                                .textFieldStyle(PrimaryTextFieldStyle())
                        }
                        .background(Color.black)
                        
                        
                        Text("Duration")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                            .padding(.top, 20)
                        
                        DurationPicker(hours: $hours, minutes: $minutes)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth:2)
                            )
                        
                        Spacer()
                        
                    }
                    .toolbar {
                        if buyInFocused || endTotalFocused {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    buyInFocused = false
                                    endTotalFocused = false
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button("Save"){
                        saveSession()
                    }
                        .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                    
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveSession() {
        
        guard let buyInValue = Double(buyIn),
              let winningsValue = Double(winnings) else {
            alertMessage = "Please enter valid amounts for Buy In Total and End Total"
            showAlert = true
            return
        }
        
        let totalDuration = Int16(hours * 60 + minutes)
        
        if totalDuration == 0 {
            alertMessage = "Please enter a valid Duration time"
            showAlert = true
            return
        }
        
        let newSession = Session(context: viewContext)
        newSession.date = date
        newSession.buyIn = buyInValue
        newSession.winnings = winningsValue - buyInValue
        newSession.duration = totalDuration
        
        do {
            try viewContext.save()
            
            buyIn = ""
            winnings = ""
            hours = 0
            minutes = 0
            
            dismiss()
            
        } catch {
            alertMessage = "Failed to save sesson: \(error.localizedDescription)"
            showAlert = true
        }
        
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
            .frame(width: 80)
        }
        .frame(width: 300, height: 100)
        .cornerRadius(10)
    }
    
}

#Preview {
    InputView()
}
