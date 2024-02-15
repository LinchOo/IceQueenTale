import Foundation
import CoreData
import SwiftUI
import UIKit
import UserNotifications
import UserNotificationsUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataBase")
    @Published var isMusic = true
    @Published var isVibro = true
    @Published var savedEntitys: [LeveL] = []
    let Titles: [String] = ["Ice Mountain", "Cold Water", "Frozen Tree", "Broken Bridge", "Fallen Tree", "Hills", "Frozen River", "Frozen Lake", "Queen Castle", "Forest and River", "Clear Sky", "Cold Snow", "Frozen Wind", "Through the Forest", "Wolf", "Snow Glade", "Forest Night", "Unexpected Guest", "Wood Road", "Edge of Forest", "Old House", "Quiet night", "Back on the Road", "Сold Room", "Warm Bed", "New Hope", "Old Village"]
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        getLeveLDB()
    }
    func getLeveLDB(){
        let request = NSFetchRequest<LeveL>(entityName: "LeveL")
        do {
            savedEntitys = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching LeveLEntitys. \(error.localizedDescription)")
        }
        if savedEntitys.count == 0 {
            for index in 1...27 {
                setupDB(context: container.viewContext, lvlName: "level_\(index)", number: index, title: Titles[index-1])
            }
            do {
                savedEntitys = try container.viewContext.fetch(request)
            } catch let error {
                print("Error fetching LeveLEntitys. \(error.localizedDescription)")
            }
        }
        if savedEntitys.count == 18 {
            for index in 19...27 {
                setupDB(context: container.viewContext, lvlName: "level_\(index)", number: index, title: Titles[index-1]) 
            }
            do {
                savedEntitys = try container.viewContext.fetch(request)
            } catch let error {
                print("Error fetching LeveLEntitys. \(error.localizedDescription)")
            }
        }
        print("\(savedEntitys.count)")
    }
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("We could not save the data...")
        }
    }
    func editNextLvLPass(lvl: LeveL){
        let nextPass = savedEntitys.first { LeveL in
            LeveL.number == lvl.number + 1
        }
        nextPass?.pass = true
        save()
        getLeveLDB()
    }
    func editTimeScore(lvl: LeveL,time: Int){
        lvl.time = Int16(time)
        save()
        getLeveLDB()
    }
    func editStarsScore(lvl: LeveL,stars: Int){
        lvl.stars = Int16(stars)
        save()
        getLeveLDB()
    }
    func setupDB(context: NSManagedObjectContext, lvlName: String, number: Int, title: String){
        let entity = LeveL(context: container.viewContext)
        entity.id = UUID()
        entity.title = title
        entity.lvlName = lvlName
        entity.stars = Int16(0)
        entity.number = Int16(number)
        entity.time = Int16(0)
        if entity.number == 1 {
            entity.pass = true
        }
        else {
            entity.pass = false
        }
        save()
        getLeveLDB()
    }
    private func save() {
        do{
            try container.viewContext.save()
        } catch let error {
            print("Error saveing to Core Data. \(error.localizedDescription)")
        }
    }
}
