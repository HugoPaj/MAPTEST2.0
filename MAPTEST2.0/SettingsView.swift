//
//  SettingsView.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 03.02.21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            List{
                Text("Hello, World!")
                Text("Hello, World!")
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }.navigationTitle("Settings")
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

class SettingsView: UIViewController {
    
}
