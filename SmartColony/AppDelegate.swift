//
//  AppDelegate.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared: AppDelegate? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        AppDelegate.shared = self
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // stop timer here
        if let window = UIApplication.shared.delegate?.window {
            var viewController = window!.rootViewController
            if (viewController is UINavigationController) {
                viewController = (viewController as! UINavigationController).visibleViewController
            }
            
            if let gameViewController = viewController as? GameViewController {
                
                // check if we have the game
                if let _ = gameViewController.gameScene?.game {
                    
                    //game.pause()
                    print("game paused")
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // stop timer here
        if let window = UIApplication.shared.delegate?.window {
            var viewController = window!.rootViewController
            if (viewController is UINavigationController) {
                viewController = (viewController as! UINavigationController).visibleViewController
            }
            
            if let gameViewController = viewController as? GameViewController {
                
                // check if we have the game
                if let game = gameViewController.gameScene?.game {
                    
                    //game.resume()
                    //print("resume game: \(game.title)")
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {

        if let window = UIApplication.shared.delegate?.window {
            var viewController = window!.rootViewController
            if (viewController is UINavigationController) {
                viewController = (viewController as! UINavigationController).visibleViewController
            }

            if let gameViewController = viewController as? GameViewController {
                
                // check if we have the game
                if let game = gameViewController.gameScene?.game {
                    // let gameUsecase = GameUsecase()
                    // gameUsecase.backup(game: game)
                }
            }
        }

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        
        let persistentContainer = CoreDataManager.shared.persistentContainer
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

