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
    func getRoutineWorkout(name: String) -> [CustomWorkout] {
        return fetchRoutineWorkout(name: name)
    }
    
    func addCustomWorkoutToRoutine(customWorkout:CustomWorkout,routine: Routine){
        routine.addToCustomworkout(customWorkout)
        print(routine.customworkout!)
        
    }
    func addWorkoutToCustomWorkout(workout: Workout, customWorkout: CustomWorkout) {
        workout.addToCustom(customWorkout)
        print(customWorkout.workout!)
        
        
    }
    
    
    func addCustomWorkout(set: String, repetition: String) -> CustomWorkout {
        let customWorkout = NSEntityDescription.insertNewObject(forEntityName: "CustomWorkout",
                                                                into: persistentContainer.viewContext) as! CustomWorkout
        customWorkout.set = set
        customWorkout.repetition = repetition
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
        
        let test = fetchActiveRoutine()
        for i in test{
            print(i)
        }
        
        return true
        
    }
    
    var listeners = MulticastDelegate<DatabaseListener>()
    let ACTIVE_ROUTINE_NAME = "Active Workout"
    let PLAN_NAME = "Plan"
    
    func addEmptyRoutine() -> Routine {
        let emptyroutine = NSEntityDescription.insertNewObject(forEntityName: "Routine",
                                                               into: persistentContainer.viewContext) as! Routine
        return emptyroutine
    }
    
    func addWorkout(name: String, imageURL: String?) -> Workout{
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout",
                    into: childContext!) as! Workout
        workout.name = name
        workout.image = imageURL
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
    
    func addWorkoutToPlan(workout: Workout, plan: Plan) -> Bool {
        return true
    }
    
    func addWorkoutToRoutine(workout: Workout, routine: Plan) -> Bool {
        return true
    }
    
    
    


   
    var persistentContainer: NSPersistentContainer // main link to database, containts properties and methods needed to work with core data
    var childContext: NSManagedObjectContext?
   
    // Fetched Results Controllers
    var allWorkoutsFetchedResultsController: NSFetchedResultsController<Workout>?
    var customWorkoutFetchedResultsController: NSFetchedResultsController<CustomWorkout>?
    var routineWorkoutsFetchedResultsController: NSFetchedResultsController<Routine>?
    var planWorkoutsFetchedResultsController: NSFetchedResultsController<Routine>?
    
    
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
            requestWorkoutImage()
            while loadstatus == false {

            }
            AddWorkout()
            //createDefaultWorkout()
            
            saveDraft()
        }
        
        //createDefaultRoutine()
        //createDefaultPlans()
        
        saveDraft()
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
            
            let _ = addWorkout(name: workoutname, imageURL: mySubstring)
            
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
        let r1 = addRoutine(routineName: "Beginner Plan I")
        let r2 = addRoutine(routineName: "Intermediate Plan I")
        let r3 = addRoutine(routineName: "Advanced Plan I")
        
               
        var int = 0
        let workouts = fetchAllWorkouts()
               
        for item in workouts{
            int += 1
            let custom = addCustomWorkout( set: "3", repetition: "12")
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r1)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r2)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r3)
            saveDraft()
            if int == 7{
                break
                }
            }
               
               
               
               /*let test = fetchRoutineWorkout()
               for item in test{
                   print(item.workout?.name ?? "Empty" )
               }*/
               
               let _ = addRoutineToPlan(routine: r1, plan: recommendedPlan)
        
               let _ = addRoutineToPlan(routine: r2, plan: recommendedPlan)
               let _ = addRoutineToPlan(routine: r3, plan: recommendedPlan)
        
        
    }

    
    func createDefaultRoutine(){
       
    
        let r1 = addRoutine(routineName: "Routine 1")
        let r2 = addRoutine(routineName: "Routine 2")
        let r3 = addRoutine(routineName: "Routine 3")
 
        
        var int = 0
        let workouts = fetchAllWorkouts()
        
        for item in workouts{
            int += 1
            let custom = addCustomWorkout( set: "3", repetition: "12")
            let _ = addWorkoutToCustomWorkout(workout: item , customWorkout: custom)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r1)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r2)
            let _ = addCustomWorkoutToRoutine(customWorkout: custom, routine: r3)
            saveDraft()
            if int == 7{
                break
            }
        }
        
        
        
        /*let test = fetchRoutineWorkout()
        for item in test{
            print(item.workout?.name ?? "Empty" )
        }*/
        
        let _ = addRoutineToActive(routine: r1, active: activeRoutine)
 
        let _ = addRoutineToActive(routine: r2, active: activeRoutine)
        let _ = addRoutineToActive(routine: r3, active: activeRoutine)
        
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

