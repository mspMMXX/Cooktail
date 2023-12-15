//
//  TutorialView.swift
//  Cooktail
//
//  Created by Markus Platter on 15.12.23.
//

import Foundation
import SwiftUI

struct TutorialView: View {
    
    //MARK: - Properties
    @Binding var showTutorial: Bool /// Speichert den Wert ob die App zum ersten mal gestartet wurde
    @State private var selection = 0
    
    let tutorialImages = ["Tut_1", "Tut_2", "Tut_3", "Tut_4", "Tut_5", "Tut_6", "Tut_7"]
    
    //MARK: - Body
    var body: some View {
        if showTutorial {
            TabView(selection: $selection) {
                ForEach(0..<tutorialImages.count, id: \.self) { index in
                    Image(tutorialImages[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Button("Überspringen") {
                UserDefaults.standard.set(false, forKey: "ShowTutorial")
                showTutorial = false
            }
        } else {
            RecipeListView()
        }
    }
}
