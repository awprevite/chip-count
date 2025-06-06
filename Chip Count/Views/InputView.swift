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
    
    @State private var date: Date = Date()
    @State private var buyIn: String = ""
    @State private var winnings: String = ""
    @State private var duration: String = ""
    
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
                        
                        Text("Buy In")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                            .padding(.top, 20)
                        
                        HStack{
                            Text("$")
                                .modifier(SmallTextStyle(color: .white))
                            
                            TextField("", text: $buyIn)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PrimaryTextFieldStyle())
                        }
                        .background(Color.black)
                        
                        
                        Text("Winnings")
                            .modifier(SmallTextStyle(color: .white))
                            .frame(maxWidth: 225, alignment: .leading)
                            .padding(.top, 20)
                        
                        
                        HStack{
                            Text("$")
                                .modifier(SmallTextStyle(color: .white))
                            
                            TextField("", text: $winnings)
                                .keyboardType(.decimalPad)
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
    }
    
    private func saveSession() {
        guard let buyInValue = Double(buyIn),
              let winningsValue = Double(winnings) else {
            print("Invalid number inputs")
            return
        }
        
        let totalDuration = Int16(hours * 60 + minutes)
        
        let newSession = Session(context: viewContext)
        newSession.date = date
        newSession.buyIn = buyInValue
        newSession.winnings = winningsValue - buyInValue
        newSession.duration = totalDuration
        
        do {
            try viewContext.save()
            print("Session saved")
            
            buyIn = ""
            winnings = ""
            hours = 0
            minutes = 0
        } catch {
            print("Failed to save session: \(error.localizedDescription)")
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
