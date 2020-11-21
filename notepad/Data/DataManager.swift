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

    func addNewMemo(_ memo: String?) {
        // 비어있는 인스턴스를 생성한다.
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        // 데이터 추가 시, list에 바로 저장하면 DB에서 다시 reload하는 역할이 줄어
        // 더 효율적이기 때문에 메모를 list에 저장한다.
        // 최신의 메모 부터 저장하기 때문에 .appned()대신 .insert()를 사용한다.
        memoList.insert(newMemo, at: 0)

        saveContext()
    }


    // add the core data persistance controller
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotePad")
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
