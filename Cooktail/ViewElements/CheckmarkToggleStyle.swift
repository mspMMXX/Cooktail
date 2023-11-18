//
//  CheckmarkToggleStyle.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation
import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {})
        ZStack{
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: 30, height: 30)
            
            if configuration.isOn {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
            }
        }
    }
}
