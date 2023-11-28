//
//  NotificationController.swift
//  Cooktail
//
//  Created by Markus Platter on 24.11.23.
//

import Foundation
import UserNotifications

class NotificationController{
    
    //MARK: - Properties
    let center = UNUserNotificationCenter.current() //Notification-Center-Objekt
    
    //MARK: - requestAuthorization
     ///Abfrage zur Zustimmung Notifications zu senden
     ///Userdefaults speichert bei erstmaliger Abfrage mit true, dass die Abfrage nicht mehr erscheint
    func requestAuthorization() {
        let hasRequestedNotification = UserDefaults.standard.bool(forKey: "hasRequestedNotification")
        
        if !hasRequestedNotification {
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notificationanfrage nicht ausfuehrbar: \(error)")
                }
                UserDefaults.standard.set(true, forKey: "hasRequestedNotification")
            }
        }
    }
    
    //MARK: - scheduleNotification
    ///Erstellt eine Notification mit dem übergebenen Date und dem Titel des Recipe
    func scheduleNotification(at date: Date, recipeTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Cookingtime!"
        content.body = recipeTitle
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Fehler beim hinzufügen der Notification: \(error)")
            }
        }
    }
}
