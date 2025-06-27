//
//  SessionView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

import SwiftUI

struct SessionView: View {
    
    @StateObject private var viewModel: SessionViewModel
    
    init(session: SessionData) {
        _viewModel = StateObject(wrappedValue: SessionViewModel(session: session))
    }
    
    var body: some View {
        
        List{
            Section(header: Text("Info")){
                ListContent(session: viewModel.session)
            }
        }
        Button("Edit Session"){
            
        }
        Spacer()
        Button("Delete Session"){
            
        }
    }
}

struct ListContent: View {
    
    
    // need to add computed properties, might just need to hard code in instead of mirror
    
    
    
    let session: SessionData
    
    var sessionStrings: [(label: String, value: String)] {
        var result: [(String, String)] = []
        let mirror = Mirror(reflecting: session)
        for child in mirror.children {
            if let label = child.label {
                result.append((label, "\(child.value)"))
            }
        }
        return result
    }
    
    var body: some View {
        ForEach(0..<sessionStrings.count, id: \.self) { i in
            let pair = sessionStrings[i]
            ListRow(label: pair.label, content: pair.value)
        }
    }
}

struct ListRow: View {
    let label: String
    let content: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(content)
        }
    }
}

#Preview {
    SessionView(session: mockData[0])
}
