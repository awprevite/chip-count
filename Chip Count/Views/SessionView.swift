//
//  SessionView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/19/25.
//

import SwiftUI

struct SessionView: View {
    
    let session: SessionData
    @State var editName: Bool = false
    @State var name = ""
    
    var body: some View {
        
        List{
            Section(header: Text("Info")){
                
                if(!editName){
                    
                    HStack{
                        Text("Name")
                        Spacer()
                        Text(session.name)
                        Spacer()
                        Button("edit"){
                            editName = true
                        }
                    }
                } else {
                    HStack{
                        TextField("Name", text: $name)
                        Spacer()
                        Button("done"){
                            editName = false
                        }
                    }
                }
            }
        }
        Button("Delete Session"){
            
        }
    }
}

#Preview {
    SessionView(session: mockData[0])
}
