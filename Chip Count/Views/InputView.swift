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
    
    @StateObject private var viewModel = InputViewModel()
    
    @FocusState private var buyInFocused: Bool
    @FocusState private var endTotalFocused: Bool
    
    @State var endTime: Date = Date()
    @State var startTime: Date = (Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date())
    @State var location: String = ""
    @State var city: String = ""
    let locationTypeOptions = ["Home", "Casino", "Online"]
    @State var locationType: String = "Home"
    @State var smallBlind: String = ""
    @State var bigBlind: String = ""
    @State var buyIn: String = ""
    @State var cashOut: String = ""
    @State var rebuys: String = ""
    @State var players: String = ""
    @State var badBeats: String = ""
    @State var mood: Int = 3
    @State var notes: String = ""
    
    @State private var showHelp: Bool = false
    @State private var helpLabel: String? = nil
    @State private var helpDescription: String = ""
    
    func help(label: String) {
        helpLabel = label
        helpDescription = inputDescriptions[label] ?? ""
        showHelp = true
    }
    
    var body: some View {
        
        ZStack{
            
            Form {
                Section(header: HStack {
                    Text("New / Edit Session")
                    Spacer()
                    Button(action: { help(label: "Help") }) {
                        Image(systemName: "questionmark.circle")
                    }
                }) {
                    
                }
                Section(header: Text("Date and Time")) {
                    HStack {
                        Text("Start")
                            .onTapGesture {
                                help(label: "Start")
                            }
                        Spacer()
                        DatePicker("", selection: $startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    HStack {
                        Text("End")
                            .onTapGesture {
                                help(label: "End")
                            }
                        Spacer()
                        DatePicker("", selection: $endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }
                Section(header: Text("Location")) {
                    
                    FormRow(label: "Location", text: $location, onHelp: {
                        help(label: "Location")
                    })
                    FormRow(label: "City", text: $city, onHelp: {
                        help(label: "City")
                    })
                    
                    HStack {
                        Text("Location Type")
                            .onTapGesture {
                                help(label: "Location Type")
                            }
                        Spacer()
                        Picker("", selection: $locationType) {
                            ForEach(locationTypeOptions, id: \.self) {option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                Section(header: Text("Game info")) {
                    FormRow(label: "Players", text: $players, keyboardType: .numberPad, onHelp: {
                        help(label: "Players")
                    })
                    FormRow(label: "Small Blind", text: $smallBlind, keyboardType: .decimalPad, onHelp: {
                        help(label: "Small Blind")
                    })
                    FormRow(label: "Big Blind", text: $bigBlind, keyboardType: .decimalPad, onHelp: {
                        help(label: "Big Blind")
                    })
                }
                
                Section(header: Text("Gameplay")) {
                    FormRow(label: "Total Buy In", text: $buyIn, keyboardType: .decimalPad, onHelp: {
                        help(label: "Buy In")
                    })
                    FormRow(label: "Cash Out", text: $cashOut, keyboardType: .decimalPad, onHelp: {
                        help(label: "Cash Out")
                    })
                    FormRow(label: "Rebuys", text: $rebuys, keyboardType: .numberPad, onHelp: {
                        help(label: "Rebuys")
                    })
                    FormRow(label: "Bad Beats", text: $badBeats, keyboardType: .numberPad, onHelp: {
                        help(label: "Bad Beats")
                    })
                }
                Section(header: Text("Other")) {
                    HStack {
                        Text("Mood")
                            .onTapGesture {
                                help(label: "Mood")
                            }
                        Spacer()
                        MoodStar(starNumber: 1, mood: $mood)
                        MoodStar(starNumber: 2, mood: $mood)
                        MoodStar(starNumber: 3, mood: $mood)
                        MoodStar(starNumber: 4, mood: $mood)
                        MoodStar(starNumber: 5, mood: $mood)
                    }
                    FormRow(label: "Notes", text: $notes, keyboardType: .default, onHelp: {
                        help(label: "Notes")
                    })
                }
                Section(header: Text("Finish")) {
                    Button(action: {print("Discard changes")}) {
                        Text("Discard")
                    }
                    Button(action: {print("save")}) {
                        Text("Save")
                    }
                }
            }
        }
        .alert(isPresented: $showHelp) {
            Alert(title: Text(helpLabel ?? ""), message: Text(helpDescription), dismissButton: .default(Text("OK")))
        }
        
    }
}

struct MoodStar: View {
    let starNumber: Int
    @Binding var mood: Int
    
    var body: some View {
        
        Button(action: { mood = starNumber }) {
            if(mood >= starNumber) {
                Image(systemName: "star.fill")
                    .contentShape(Rectangle())
            } else {
                Image(systemName: "star")
                    .contentShape(Rectangle())
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormRow: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    let onHelp: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(label)
                .onTapGesture {
                    onHelp?()
                }
            Spacer()
            TextField("Enter \(label)", text: $text)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    InputView()
}
