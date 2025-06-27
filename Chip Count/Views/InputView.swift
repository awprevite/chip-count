//
//  Input.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI
// enum for focus state and button on keyboard to move on, also done button for closing keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct InputView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = InputViewModel()
    
    @FocusState private var buyInFocused: Bool
    @FocusState private var endTotalFocused: Bool
    
    var body: some View {
        
        ZStack{
            
            Form {
                Section(header: HStack {
                    Text("New / Edit Session")
                    Spacer()
                    Button(action: { viewModel.help(label: "Help") }) {
                        Image(systemName: "questionmark.circle")
                    }
                }) {
                    
                }
                Section(header: Text("Date and Time")) {
                    HStack {
                        Text("Start")
                            .onTapGesture {
                                viewModel.help(label: "Start")
                            }
                        Spacer()
                        DatePicker("", selection: $viewModel.startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    HStack {
                        Text("End")
                            .onTapGesture {
                                viewModel.help(label: "End")
                            }
                        Spacer()
                        DatePicker("", selection: $viewModel.endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }
                Section(header: Text("Location")) {
                    
                    FormRow(label: "Location", text: $viewModel.location, onHelp: {
                        viewModel.help(label: "Location")
                    })
                    FormRow(label: "City", text: $viewModel.city, onHelp: {
                        viewModel.help(label: "City")
                    })
                    
                    HStack {
                        Text("Location Type")
                            .onTapGesture {
                                viewModel.help(label: "Location Type")
                            }
                        Spacer()
                        Picker("", selection: $viewModel.locationType) {
                            ForEach(viewModel.locationTypeOptions, id: \.self) {option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                }
                Section(header: Text("Game info")) {
                    FormRow(label: "Players", text: $viewModel.players, keyboardType: .numberPad, onHelp: {
                        viewModel.help(label: "Players")
                    })
                    FormRow(label: "Small Blind", text: $viewModel.smallBlind, keyboardType: .decimalPad, onHelp: {
                        viewModel.help(label: "Small Blind")
                    })
                    FormRow(label: "Big Blind", text: $viewModel.bigBlind, keyboardType: .decimalPad, onHelp: {
                        viewModel.help(label: "Big Blind")
                    })
                }
                
                Section(header: Text("Gameplay")) {
                    FormRow(label: "Total Buy In", text: $viewModel.buyIn, keyboardType: .decimalPad, onHelp: {
                        viewModel.help(label: "Buy In")
                    })
                    FormRow(label: "Cash Out", text: $viewModel.cashOut, keyboardType: .decimalPad, onHelp: {
                        viewModel.help(label: "Cash Out")
                    })
                    FormRow(label: "Rebuys", text: $viewModel.rebuys, keyboardType: .numberPad, onHelp: {
                        viewModel.help(label: "Rebuys")
                    })
                    FormRow(label: "Bad Beats", text: $viewModel.badBeats, keyboardType: .numberPad, onHelp: {
                        viewModel.help(label: "Bad Beats")
                    })
                }
                Section(header: Text("Other")) {
                    HStack {
                        Text("Mood")
                            .onTapGesture {
                                viewModel.help(label: "Mood")
                            }
                        Spacer()
                        MoodStar(starNumber: 1, mood: $viewModel.mood)
                        MoodStar(starNumber: 2, mood: $viewModel.mood)
                        MoodStar(starNumber: 3, mood: $viewModel.mood)
                        MoodStar(starNumber: 4, mood: $viewModel.mood)
                        MoodStar(starNumber: 5, mood: $viewModel.mood)
                    }
                    FormRow(label: "Notes", text: $viewModel.notes, keyboardType: .default, onHelp: {
                        viewModel.help(label: "Notes")
                    })
                }
                Section(header: Text("Finish")) {
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Text("Discard")
                    }
                    Button(action: {
                        viewModel.saveSession(context: context){
                            dismiss()
                        }
                    }) {
                        Text("Save")
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showHelp) {
            Alert(title: Text(viewModel.helpLabel ?? ""), message: Text(viewModel.helpDescription), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
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
