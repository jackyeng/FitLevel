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
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    let ACTIVE_ROUTINE_NAME = "Active Workout"
    let PLAN_NAME = "Plan"

    var persistentContainer: NSPersistentContainer
    var childContext: NSManagedObjectContext?
   
    // Fetched Results Controllers
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var customWorkoutFetchedResultsController: NSFetchedResultsController<CustomWorkout>?
    var routineWorkoutsFetchedResultsController: NSFetchedResultsController<Routine>?
    var planWorkoutsFetchedResultsController: NSFetchedResultsController<Routine>?
    var workoutDateFetchedResultsController: NSFetchedResultsController<WorkoutDate>?
    
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
        
        
        if fetchAllWorkouts().count == 0 {
            createDefaultContent()
        }
      
        
        
    }

        
    //Protocols
    
    func getWorkoutDate(year: Int, month: Int) -> [WorkoutDate]{
           return fetchWorkoutDate(year: year, month: month)
       }
       
    func addWorkoutDate(year: Int, month: Int, day: Int) {
           let workoutdates = fetchWorkoutDate(year: year, month: month, day:day)
          
           if workoutdates == [] {
               let workoutDate = NSEntityDescription.insertNewObject(forEntityName: "WorkoutDate",
                                                                       into: persistentContainer.viewContext) as! WorkoutDate
               workoutDate.year = Int64(year)
               workoutDate.month = Int64(month)
               workoutDate.day = Int64(day)
           
               saveDraft()
           }
       }
       
    func getRoutineWorkout(name: String) -> [CustomWorkout] {
           return fetchRoutineWorkout(name: name)
       }
       
    func addCustomWorkoutToRoutine(customWorkout:CustomWorkout,routine: Routine){
           routine.addToCustomworkout(customWorkout)
     
           
       }
    func addWorkoutToCustomWorkout(workout: Workout, customWorkout: CustomWorkout) {
           workout.addToCustom(customWorkout)

       }
       
       
    func addCustomWorkout(set: String, repetition: String, duration: String) -> CustomWorkout {
           let customWorkout = NSEntityDescription.insertNewObject(forEntityName: "CustomWorkout",
                                                                   into: persistentContainer.viewContext) as! CustomWorkout
           customWorkout.set = set
           customWorkout.repetition = repetition
           customWorkout.duration = duration
           saveDraft()
           return customWorkout
       }
   
       
    func addActiveRoutine(activeroutineName: String) -> ActiveRoutine {
           let activeRoutine = NSEntityDescription.insertNewObject(forEntityName: "ActiveRoutine",
                       into: persistentContainer.viewContext) as! ActiveRoutine
           activeRoutine.name = activeroutineName
           return activeRoutine
       }
       
    func removeRoutinefromActive(active: ActiveRoutine, routine: Routine) {
           routine.removeFromActiveroutine(active)
           saveDraft()
       }
       
    func addRoutineToActive(routine: Routine, active: ActiveRoutine) -> Bool {
           //Cocktail validation
           /*
           let routines = activeRoutine.routine!
           
           for item in routines{
               let activeRoutine = item as! Routine
               if activeRoutine.name! == routine.name! { //compare name of cocktails in My Drink to name of cocktail to be added, if cocktail name already exists, then return false
                   //if it's the same object then return true.
                   return false
               }
           }*/
           routine.addToActiveroutine(active)
           //active.addToRoutine(routine)
           saveDraft()
           return true
       }
       
    func addEmptyRoutine() -> Routine {
           let emptyroutine = NSEntityDescription.insertNewObject(forEntityName: "Routine",
                                                                  into: persistentContainer.viewContext) as! Routine
           return emptyroutine
       }
       
    func addWorkout(name: String, imageURL: String?, level: Int) -> Workout{
           let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout",
                       into: childContext!) as! Workout
           workout.name = name
           workout.image = imageURL
           workout.level = Int16(level)
           return workout
       }
       
    func addRoutine(routineName: String) -> Routine {
           let routine = NSEntityDescription.insertNewObject(forEntityName: "Routine",
                       into:  persistentContainer.viewContext) as! Routine
           routine.name = routineName
           return routine
       }
       
    func addPlan(planName: String) -> Plan {
           let plan = NSEntityDescription.insertNewObject(forEntityName: "Plan",
                                                            into: childContext!) as! Plan
           plan.name = planName
           return plan
       }
       
    
    func addRoutineToPlan(routine: Routine, plan: Plan) -> Bool {
           routine.addToPlan(plan)
           return true
       }
    
    
    lazy var activeRoutine: ActiveRoutine = {
        var routines = [ActiveRoutine]()

        let request: NSFetchRequest<ActiveRoutine> = ActiveRoutine.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", ACTIVE_ROUTINE_NAME)
        request.predicate = predicate

        do {
            try routines = persistentContainer.viewContext.fetch(request) //
        } catch {
            print("Fetch Request Failed: \(error)")
        }

        if routines.count == 0 { //
            return addActiveRoutine(activeroutineName: ACTIVE_ROUTINE_NAME) //
        }

        return routines.first! //
    }()
 
    
    lazy var recommendedPlan: Plan = {
        var plan = [Plan]()

        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", PLAN_NAME)
        request.predicate = predicate

        do {
            try plan = persistentContainer.viewContext.fetch(request) //
        } catch {
            print("Fetch Request Failed: \(error)")
        }

        if plan.count == 0 { //
            return addPlan(planName: PLAN_NAME)//
        }

        return plan.first! //
    }()
    
    
    
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
            listener.onRoutineChange(change: .update, routineWorkouts: fetchActiveRoutine())
        }
        if listener.listenerType == .workout || listener.listenerType == .all {
            listener.onWorkoutListChange(change: .update, workouts: fetchAllWorkouts())
        }
        if listener.listenerType == .workoutstats || listener.listenerType == .all {
            listener.onWorkoutListChange(change: .update, workouts: fetchAllWorkouts(sort: "level", bool: false))
        }
        if listener.listenerType == .routineworkout || listener.listenerType == .all {
            listener.onWorkoutListChange(change: .update, workouts: fetchAllWorkouts())
        }
        if listener.listenerType == .plan || listener.listenerType == .all {
            listener.onPlanListChange(change: .update, recommendedPlan: fetchRecommendedPlan())
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
                    listener.onRoutineChange(change: .update, routineWorkouts: fetchActiveRoutine())
                }
            }
        }
    }

    // MARK: - Core Data Fetch Requests
    
    func fetchRecommendedPlan() -> [Routine]{
    if planWorkoutsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY plan.name == %@", PLAN_NAME) // fix
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            planWorkoutsFetchedResultsController =
                NSFetchedResultsController<Routine>(fetchRequest: fetchRequest,
                    managedObjectContext: persistentContainer.viewContext,
                        sectionNameKeyPath: nil, cacheName: nil)
            planWorkoutsFetchedResultsController?.delegate = self

            do {
                try planWorkoutsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }

        var routines = [Routine]()
        if planWorkoutsFetchedResultsController?.fetchedObjects != nil {
            routines = (planWorkoutsFetchedResultsController?.fetchedObjects)!
        }

        return routines
    }
    
    func fetchActiveRoutine() -> [Routine]{
        if routineWorkoutsFetchedResultsController == nil {
                let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
                let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                let predicate = NSPredicate(format: "ANY activeroutine.name == %@", ACTIVE_ROUTINE_NAME) // fix
                fetchRequest.sortDescriptors = [nameSortDescriptor]
                fetchRequest.predicate = predicate
                routineWorkoutsFetchedResultsController =
                    NSFetchedResultsController<Routine>(fetchRequest: fetchRequest,
                        managedObjectContext: persistentContainer.viewContext,
                            sectionNameKeyPath: nil, cacheName: nil)
                routineWorkoutsFetchedResultsController?.delegate = self

                do {
                    try routineWorkoutsFetchedResultsController?.performFetch()
                } catch {
                    print("Fetch Request Failed: \(error)")
                }
            }

            var workouts = [Routine]()
            if routineWorkoutsFetchedResultsController?.fetchedObjects != nil {
                workouts = (routineWorkoutsFetchedResultsController?.fetchedObjects)!
            }

            return workouts
        }
    
    func fetchRoutineWorkout(name: String) -> [CustomWorkout]{
    
        let fetchRequest: NSFetchRequest<CustomWorkout> = CustomWorkout.fetchRequest()
        // Sort by name
        let nameSortDescriptor = NSSortDescriptor(key: "set", ascending: true)
        let predicate = NSPredicate(format: "ANY routine.name == %@", name) // fix
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        fetchRequest.predicate = predicate
        // Initialize Results Controller
        customWorkoutFetchedResultsController =
            NSFetchedResultsController<CustomWorkout>(fetchRequest:
                fetchRequest, managedObjectContext: persistentContainer.viewContext,
                              sectionNameKeyPath: nil, cacheName: nil)
        // Set this class to be the results delegate
        customWorkoutFetchedResultsController?.delegate = self

        do {
            try customWorkoutFetchedResultsController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
    

        var workout = [CustomWorkout]()
   
        workout = (customWorkoutFetchedResultsController?.fetchedObjects)!
        return workout
        
    }
    
    func fetchWorkoutDate(year: Int, month:Int, day: Int? = -1) -> [WorkoutDate]{

        let fetchRequest: NSFetchRequest<WorkoutDate> = WorkoutDate.fetchRequest()
        // Sort by name
        let nameSortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        if day == -1{
            let predicate = NSPredicate(format: "year == \(year) AND month == \(month)") // fix
            fetchRequest.predicate = predicate
        }
        else{
            let predicate = NSPredicate(format: "year == \(year) AND month == \(month) AND day == \(day ?? -1)")
            fetchRequest.predicate = predicate
        }
         fetchRequest.sortDescriptors = [nameSortDescriptor]
         
         // Initialize Results Controller
         workoutDateFetchedResultsController =
             NSFetchedResultsController<WorkoutDate>(fetchRequest:
                 fetchRequest, managedObjectContext: persistentContainer.viewContext,
                               sectionNameKeyPath: nil, cacheName: nil)
         // Set this class to be the results delegate
         workoutDateFetchedResultsController?.delegate = self

         do {
             try workoutDateFetchedResultsController?.performFetch()
         } catch {
             print("Fetch Request Failed: \(error)")
         }
     

        var workout = [WorkoutDate]()
    
        workout = (workoutDateFetchedResultsController?.fetchedObjects)!


        return workout
     }
    
    
    
    
    func fetchAllWorkouts(sort: String? = "name", bool: Bool? = true) -> [Workout] {
        // If results controller not currently initialized
    
            let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: sort, ascending: bool! )
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
        

        var workout = [Workout]()
        if allWorkoutsFetchedResultsController?.fetchedObjects != nil {
            workout = (allWorkoutsFetchedResultsController?.fetchedObjects)!
        }

        return workout
    }
    
    
    
    //Default Content Initialization
    func createDefaultContent(){
        createDefaultWorkout()
        saveDraft()
        createDefaultPlans()
        createDefaultRoutine()
        createDefaultWorkoutDate()
        saveDraft()
    }
    
    //https://www.youtube.com/watch?time_continue=270&v=_knIf9vF4k4&feature=emb_logo
    func createDefaultWorkout(){
        let _ = addWorkout(name: "Burpees", imageURL: "",level: 1)
        let _ = addWorkout(name: "Close Body Squats", imageURL: "", level: 1)
        let _ = addWorkout(name: "Forward Lunges", imageURL: "",level: 1)
        let _ = addWorkout(name: "Hips Raises", imageURL: "",level:1)
        let _ = addWorkout(name: "Jumping Jacks", imageURL: "",level:1)
        let _ = addWorkout(name: "Mountain Climbers", imageURL: "",level:1)
        let _ = addWorkout(name: "Planks", imageURL: "",level:1)
        let _ = addWorkout(name: "Push Ups", imageURL: "",level:1)
        let _ = addWorkout(name: "Seal Jacks", imageURL: "",level:1)
        let _ = addWorkout(name: "Superman", imageURL: "",level:1)

    }
    
    //Add routine to plans
    func createDefaultPlans(){
        let r1 = addRoutine(routineName: "Beginner Plan I")
        let r2 = addRoutine(routineName: "Intermediate Plan I")
        let r3 = addRoutine(routineName: "Advanced Plan I")
               
        var int = 0
        let workouts = fetchAllWorkouts()
        let workoutCount = workouts.count
        
        for item in workouts{
            int += 1
            let custom1 = addCustomWorkout( set: "3", repetition: "12", duration: "15")
            let custom2 = addCustomWorkout( set: "3", repetition: "12", duration: "30")
            let custom3 = addCustomWorkout( set: "3", repetition: "12", duration: "45")
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom1)
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom2)
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom3)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom1, routine: r1)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom2, routine: r2)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom3, routine: r3)
            if int == workoutCount{
                break
                }
            }
               
        let _ = addRoutineToPlan(routine: r1, plan: recommendedPlan)
        let _ = addRoutineToPlan(routine: r2, plan: recommendedPlan)
        let _ = addRoutineToPlan(routine: r3, plan: recommendedPlan)
        
        
    }

    
    func createDefaultRoutine(){
       
        let r1 = addRoutine(routineName: "Fat Burning Bodyweight Workout")
     
        var int = 0
        let workouts = fetchAllWorkouts()
        let workoutCount = workouts.count
        for item in workouts{
            int += 1
            let custom = addCustomWorkout( set: "3", repetition: "12", duration: "30")
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r1)
          
            saveDraft()
            if int == workoutCount{
                break
            }
        }
        
        let _ = addRoutineToActive(routine: r1, active: activeRoutine)
    
    }
    
    
    func createDefaultWorkoutDate(){
        
    }
    
    
    //Unused
    
    func addWorkoutToPlan(workout: Workout, plan: Plan) -> Bool {
        return true
    }
    
    func addWorkoutToRoutine(workout: Workout, routine: Plan) -> Bool {
        return true
    }

}

