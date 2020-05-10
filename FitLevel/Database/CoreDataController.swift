//
//  CoreDataController.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit
import CoreData
class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    func addWorkoutToPlan(workout: Workout, plan: Plan) -> Bool {
        return true
    }
    
    func addWorkoutToRoutine(workout: Workout, routine: Plan) -> Bool {
        return true
    }
    
    func addPlan(planName: String) -> Plan {
        let object = [Plan]()
        return object[0]
    }
    
    func addRoutine(routineName: String) -> Routine {
        let object = [Routine]()
        return object[0]
    }
    


    var listeners = MulticastDelegate<DatabaseListener>() // send messages when changes are made to the database
    var persistentContainer: NSPersistentContainer // main link to database, containts properties and methods needed to work with core data
    var childContext: NSManagedObjectContext?
   
    // Fetched Results Controllers
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var routineWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var planWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?


    override init() { // Core database is loaded here
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "Workout")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        super.init()
        childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext?.parent = self.persistentContainer.viewContext
       
        if fetchAllWorkouts().count == 0 {
            saveDraft()
        }
    }

 

    func saveContext() { //has to be called to make changes to the file otherwise changes are only made to managed object
        if persistentContainer.viewContext.hasChanges { //if there are changes context , then we save
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    //https://code-craftsman.fr/2015/08/04/saving-core-data-objects/
    func saveDraft() {
        do {
            try childContext?.save() //save changes to child context before saving to persistent container
        } catch {
            fatalError("Failed to save to main context: \(error)")
        }
        if persistentContainer.viewContext.hasChanges { //if there are changes context , then we save
                   do {
                       try persistentContainer.viewContext.save()
                   } catch {
                       fatalError("Failed to save to CoreData: \(error)")
                   }
               }
        
        
    }
    
    func discardDraft() {
        childContext?.rollback()
    }
    // MARK: - Database Protocol Functions
    func cleanup() {
        saveContext()
    }
    
 

  

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .routine || listener.listenerType == .all {
            listener.onRoutineChange(change: .update, routineWorkouts: fetchAllWorkouts())
        }

        if listener.listenerType == .workout || listener.listenerType == .all {
            listener.onWorkoutListChange(change: .update, workouts: fetchAllWorkouts())
        }
        
       

        
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    // MARK: - Fetched Results Controller Protocol Functions
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allWorkoutsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .workout || listener.listenerType == .all {
                    listener.onWorkoutListChange(change: .update, workouts: fetchAllWorkouts())
                }
            }
        } else if controller == routineWorkoutsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .routine || listener.listenerType == .all {
                    listener.onRoutineChange(change: .update, routineWorkouts: fetchAllWorkouts())
                }
            }
        }
    }

    // MARK: - Core Data Fetch Requests
    func fetchAllWorkouts() -> [Workout] {
        // If results controller not currently initialized
        if allWorkoutsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Initialize Results Controller
            allWorkoutsFetchedResultsController =
                NSFetchedResultsController<Workout>(fetchRequest:
                    fetchRequest, managedObjectContext: persistentContainer.viewContext,
                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allWorkoutsFetchedResultsController?.delegate = self

            do {
                try allWorkoutsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }

        var workout = [Workout]()
        if allWorkoutsFetchedResultsController?.fetchedObjects != nil {
            workout = (allWorkoutsFetchedResultsController?.fetchedObjects)!
        }

        return workout
    }


 
    


        
}

