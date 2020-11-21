//
//  DataManager.swift
//  notepad
//
//  Created by Allie Kim on 2020/11/21.
//

import Foundation
import CoreData

class DataManager {

    static let shared = DataManager()

    private init() {

    }

    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var memoList = [Memo]()

    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()

        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]

        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }


    }


    // add the core data persistance controller
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "notepad")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container;
    }()

    func saveContext() {
        let context = persistentContainer.viewContext;
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
