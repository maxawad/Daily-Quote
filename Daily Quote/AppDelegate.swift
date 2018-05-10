//
//  AppDelegate.swift
//  Daily Quote
//
//  Created by Moustafa Awad on 4/26/18.
//  Copyright © 2018 Moustafa Awad. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import FeedKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Fetch data once an hour.
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let newData = fetchQuotes() {
            saveFetchedQuotes(feed: newData)
            scheduleNotification(quote: rtnFirst(feed: newData), date: rtnDate())
            completionHandler(.newData)
        }
        completionHandler(.noData)
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveFetchedQuotes(feed: fetchQuotes()!)
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Custom functions
    public func scheduleNotification(quote: String, date: Date) {
        
        let content = UNMutableNotificationContent()
        
        content.body = quote
        content.sound = UNNotificationSound.default()
        
        // Configure the trigger for time in date for wakeup.
        var dateInfo = DateComponents()
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateInfo.hour = components.hour
        dateInfo.minute = components.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "DailyQuote", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
    }
    
    func fetchQuotes() -> RSSFeed?{
        let feedURL = URL(string: "https://www.brainyquote.com/link/quotebr.rss")!
        let parser = FeedParser(URL: feedURL)
        
        // Parse asynchronously, not to block the UI.
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            return result.rssFeed
        }
        return parser?.parse().rssFeed
    }
    
    
    
    // MARK: - Core Data Saving support
    
    func saveFetchedQuotes(feed: RSSFeed) {
        
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedQuotes", in: context)
        let newQuote = NSManagedObject(entity: entity!, insertInto: context)
        
        let item = feed.items?[0]
        let author:String = (item!.title)!
        var quoting = (item!.description)!
        quoting = String(quoting.dropLast())
        quoting = String(quoting.dropFirst())
        let quote: String = quoting
        
    
        newQuote.setValue(quote, forKey: "lastQuote")
        newQuote.setValue(author, forKey: "lastAuthor")
        
        do {
            try context.save()
            print("Saved Last ")
        } catch {
            print("Failed saving")
        }
        
    }
    func rtnFirst(feed: RSSFeed) -> String{
        let item = feed.items?[0]
        let author:String = (item!.title)!
        var quoting = (item!.description)!
        quoting = String(quoting.dropLast())
        quoting = String(quoting.dropFirst())
        let quote: String = quoting
        
        return quote + "\n - " + author
    }
    func rtnDate() -> Date{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedDate")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let lastDate =  (result as! [NSManagedObject]).last
            
            if (lastDate?.value(forKey: "date") != nil){
                print("rtned save Date")
                return lastDate?.value(forKey: "date") as! Date
                }
            
        } catch {
            
            print("Failed")
        }
        print("rtned Date()")
        return Date()
    }
    func saveDate(date: Date) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedDates", in: context)
        let newDate = NSManagedObject(entity: entity!, insertInto: context)
        newDate.setValue(date, forKey: "date")
        do {
            try context.save()
            print("Saved Date")
        } catch {
            print("Failed saving")
        }

        
    }
    
}

