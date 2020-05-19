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
    
    
    
    func addWorkout(name: String, imageURL: String?) {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout",
                    into: childContext!) as! Workout
        workout.name = name
        workout.image = imageURL
    }
    
    func addRoutine(routineName: String) {
        let routine = NSEntityDescription.insertNewObject(forEntityName: "Routine",
                    into: childContext!) as! Routine
        routine.name = routineName
    }
    
    func addPlan(planName: String) {
        let plan = NSEntityDescription.insertNewObject(forEntityName: "Plan",
                                                         into: childContext!) as! Plan
        plan.name = planName
    }
    
 
    func addRoutineToPlan() {
        
    }
    
    func addWorkoutToPlan(workout: Workout, plan: Plan) -> Bool {
        return true
    }
    
    func addWorkoutToRoutine(workout: Workout, routine: Plan) -> Bool {
        return true
    }
    
    
    


    var listeners = MulticastDelegate<DatabaseListener>() // send messages when changes are made to the database
    var persistentContainer: NSPersistentContainer // main link to database, containts properties and methods needed to work with core data
    var childContext: NSManagedObjectContext?
   
    // Fetched Results Controllers
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var routineWorkoutsFetchedResultsController: NSFetchedResultsController<ActiveRoutine>?
    var planWorkoutsFetchedResultsController: NSFetchedResultsController<Plan>?
    var workoutlist = [WorkoutData]()
    var loadstatus = false
    
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
        
        
        let workouts = fetchAllWorkouts()
        print(workouts)
        for i in workouts{
            print(i.name!)
        }
        requestWorkoutImage()
        while loadstatus == false {

        }
        AddWorkout()
        saveDraft()
        if fetchAllWorkouts().count == 0 {
            requestWorkoutImage()
            while loadstatus == false {

            }
            AddWorkout()
            createDefaultWorkout()
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
    
    
    ////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    ///////////////////////////
 

  

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
    
    func fetchRoutineWorkouts() -> [Workout]{
        return [Workout]()
    }
    
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

    func AddWorkout(){
        filterName()
        
    }
    
    
    func filterName() {
       
        for i in workoutlist{
            let mySubstring = String(i.imageURL!)
            var startindex = 0
            var endindex = -1
            var count = 0
            print(mySubstring)
            for (index,char) in mySubstring.enumerated(){
                print(index,char)
                if count == 6 && startindex == 0{
                   startindex = index
                }
                if char == "/"{
                    count += 1
                }
                
                if char.isNumber{
                    if (startindex != 0 && endindex == -1){
                        endindex = index
                    }
                    
                }
            
            }
            
            endindex -= (mySubstring.count + 1)
            print(startindex)
            print(endindex)
            let start = mySubstring.index(mySubstring.startIndex, offsetBy: startindex)
            
            let end = mySubstring.index(mySubstring.endIndex, offsetBy: endindex)
            let range = start..<end
            let finalstring = String(mySubstring[range])
            print(finalstring)
            
            var workoutname = ""
            for char in finalstring{
                if char == "-"{
                    workoutname += " "
                    
                }
                else{
                 workoutname += String(char)
            }
                }
            print(workoutname)
            
            addWorkout(name: workoutname, imageURL: mySubstring)
            
            }
            
    
    }
    
    func requestWorkoutImage() {
        let searchString = "https://wger.de/api/v2/exerciseimage.json/?is_main=True&language=2&page=9"
        let jsonURL =
            URL(string: searchString.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)!)

        let task = URLSession.shared.dataTask(with: jsonURL!) {
        (data, response, error) in
        // Regardless of response end the loading icon from the main thread
        DispatchQueue.main.async {
            
        }

        if let error = error {
            print(error)
            return
        }

        do {
            let decoder = JSONDecoder()
            let volumeData = try decoder.decode(VolumeData.self, from: data!)
            if let workouts = volumeData.Workout { //change
                self.workoutlist.append(contentsOf: workouts) //change
                self.loadstatus = true

                DispatchQueue.main.async {
                                    }
            }
        } catch let err {
            print(err)
        }
        }

        task.resume()
    
        }

    //Add routine to plans
    func createDefaultPlans(){
        
        
    }

    
    func createDefaultRoutine(){
        //routine name
        //link workout to the routine list
    }
    
    func createDefaultWorkout(){
        let _ = addWorkout(name: "Push ups", imageURL: "")
        let _ = addWorkout(name: "Sit ups", imageURL: "")
        let _ = addWorkout(name: "Pull ups", imageURL: "")
        let _ = addWorkout(name: "Planks", imageURL: "")

    }
    


}

