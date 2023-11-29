//
//  RecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    
    //MARK: - @State Properties
    @State private var newNotificationDate: Date = Date() //Zuweisung des neuen NotificationDates
    @State private var newPortionAmount: Int = 1 //Zuweisung der neuen Portionsmenge
    @State private var didUpdate: Bool = false
    
    //MARK: - @Environment Properties
    @EnvironmentObject var dataController: DataController
    
    //MARK: - Properties
    var recipe: MealRecipe //Das übergebende Objekt zur Detail-Darstellung
    var notificationController: NotificationController = NotificationController()
    
    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: recipe.wrappedImageURL), scale: 17)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(recipe.wrappedTitle)
                        .bold()
                    Text("Arbeitsaufwand: \(recipe.cookingDuration / 60) min.")
                        .font(.caption)
                    Text("Portionen: \(recipe.portions)")
                        .font(.caption)
                }
            }
            .padding(.bottom)
            Form {
                Section("Anleitung") {
                    List(Array(recipe.instructionsArray.enumerated()), id: \.element) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .bold()
                                .frame(width: 30, alignment: .leading)
                            Text(step)
                            Spacer()
                        }
                    }
                }
                Section("Zutaten") {
                    List {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient.wrappedName)
                                Spacer()
                                Text(ingredient.wrappedAmount.replacing(".", with: ","))
                                Text(ingredient.wrappedUnit)
                            }
                        }
                    }
                }
                Section("Einstellungen") {
                    DatePicker("Koch-Alarm", selection: $newNotificationDate)
                    HStack {
                        Text("Portionen: \(newPortionAmount)")
                        Stepper("", value: $newPortionAmount)
                    }
                    HStack {
                        Spacer()
                        Button {
                            if let id = recipe.id {
                                dataController.updateRecipe(from: recipe, newPortion: newPortionAmount, newNotificationDate: newNotificationDate)
                                notificationController.updateScheduledNotification(at: newNotificationDate, recipeTitle: recipe.wrappedTitle, recipeID: id)
                            }
                            didUpdate = true
                        } label: {
                            Text(didUpdate ? "Alles up to date" : "Aktualisieren")
                                .disabled(didUpdate)
                        }
                        Spacer()
                    }
                }
                .onChange(of: didUpdate, {
                    dataController.loadRecipes()
                })
                .onAppear {
                    if let date = recipe.notificationDate {
                        newNotificationDate = date
                    }
                    newPortionAmount = Int(recipe.portions)
                }
            }
        }
    }
    
    //Zur Umwandlung eines Date-Objekts in einen String
    private func dateAsString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
}
