//
//  Input.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

enum FormField: String, CaseIterable {
    
    case location
    case city
    case players
    case smallBlind
    case bigBlind
    case buyIn
    case cashOut
    case rebuys
    case badBeats
    case notes
    
    func next() -> FormField? {
        let allCases = FormField.allCases
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }
        let nextIndex = allCases.index(after: currentIndex)
        return nextIndex < allCases.endIndex ? allCases[nextIndex] : nil
    }
}

struct InputView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: InputViewModel
    
    @FocusState private var focusedField: FormField?
    
    var sessionToEdit: SessionData? = nil
    
    init(sessionToEdit: SessionData? = nil) {
        _viewModel = StateObject(wrappedValue: InputViewModel(sessionToEdit: sessionToEdit))
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Date and Time")) {
                    HStack {
                        Text("Start")
                            .onTapGesture {
                                viewModel.help(label: "Start Time")
                            }
                        Spacer()
                        DatePicker("", selection: $viewModel.startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    HStack {
                        Text("End")
                            .onTapGesture {
                                viewModel.help(label: "End Time")
                            }
                        Spacer()
                        DatePicker("", selection: $viewModel.endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }
                Section(header: Text("Location")) {
                    
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
                    
                    HStack {
                        Text("Location")
                            .onTapGesture {
                                viewModel.help(label: "Location")
                            }
                        Spacer()
                        TextField("Enter \("Location")", text: $viewModel.location)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .location)
                    }
                    
                    HStack {
                        Text("City")
                            .onTapGesture {
                                viewModel.help(label: "City")
                            }
                        Spacer()
                        TextField("Enter \("City")", text: $viewModel.city)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .city)
                    }
                }
                Section(header: Text("Game info")) {
                    
                    HStack {
                        Text("Players")
                            .onTapGesture {
                                viewModel.help(label: "Players")
                            }
                        Spacer()
                        TextField("Enter \("Players")", text: $viewModel.players)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .players)
                    }
                    
                    HStack {
                        Text("Small Blind")
                            .onTapGesture {
                                viewModel.help(label: "Small Blind")
                            }
                        Spacer()
                        TextField("Enter \("Small Blind")", text: $viewModel.smallBlind)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .smallBlind)
                    }
                    HStack {
                        Text("Big Blind")
                            .onTapGesture {
                                viewModel.help(label: "Big Blind")
                            }
                        Spacer()
                        TextField("Enter \("Big Blind")", text: $viewModel.bigBlind)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .bigBlind)
                    }
                }
                
                Section(header: Text("Gameplay")) {
                    HStack {
                        Text("Total Buy In")
                            .onTapGesture {
                                viewModel.help(label: "Buy In")
                            }
                        Spacer()
                        TextField("Enter \("Total Buy In")", text: $viewModel.buyIn)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .buyIn)
                    }
                    HStack {
                        Text("Cash Out")
                            .onTapGesture {
                                viewModel.help(label: "Cash Out")
                            }
                        Spacer()
                        TextField("Enter Cash Out", text: $viewModel.cashOut)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .cashOut)
                    }
                    HStack {
                        Text("Rebuys")
                            .onTapGesture {
                                viewModel.help(label: "Rebuys")
                            }
                        Spacer()
                        TextField("Enter Rebuys", text: $viewModel.rebuys)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .rebuys)
                    }
                    HStack {
                        Text("Bad Beats")
                            .onTapGesture {
                                viewModel.help(label: "Bad Beats")
                            }
                        Spacer()
                        TextField("Enter Bad Beats", text: $viewModel.badBeats)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .badBeats)
                    }
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
                    HStack {
                        Text("Notes")
                            .onTapGesture {
                                viewModel.help(label: "Notes")
                            }
                        Spacer()
                        TextField("Enter Notes", text: $viewModel.notes)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .notes)
                    }
                }
                Section(header:
                    HStack{
                        Text("Finish")
                        Spacer()
                        Button(action: { viewModel.help(label: "Help") }) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                ){
                    Button(action: {
                        viewModel.discard()
                    }) {
                        Text("Discard")
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        viewModel.saveSession(context: context)
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationTitle(viewModel.sessionToEditID == nil ? "New Session" : "Edit Session")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        focusedField = nil
                    }
                    
                    if focusedField?.next() != nil {
                        Button("Next") {
                            if let currentField = focusedField {
                                focusedField = currentField.next()
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showHelp) {
            
            if viewModel.helpLabel == "Discard" {
                return Alert(
                    title: Text(viewModel.helpLabel ?? ""),
                    message: Text(viewModel.helpDescription),
                    primaryButton: .destructive(Text("Discard")){
                        viewModel.reset()
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("Back")))
            } else if viewModel.helpLabel == "Success" {
                return Alert(
                    title: Text("Success"),
                    message: Text(viewModel.helpDescription),
                    dismissButton: .default(Text("OK")) {
                        dismiss() // <- dismiss on success
                    }
                )
            } else {
                return Alert(title: Text(viewModel.helpLabel ?? ""),
                      message: Text(viewModel.helpDescription),
                      dismissButton: .default(Text("OK")))
            }
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

#Preview {
    InputView()
}
