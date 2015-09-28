//
//  AppDelegate.swift
//  meteor-ios-starter-swift
//
//  Created by Kevin Chen on 5/27/15.
//  Copyright (c) 2015 aspin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Initializes the Meteor client, which is now interfaces the Meteor and iOS apps.
    // The first argument is the DDP version number (pretty unimportant) and the second is
    // the URL of your application. This'll probably typically be whatever your deployed *.meteor.com
    // domain is, but if you're testing with the iPhone emulator, you can also use localhost.
    // var meteorClient = initializeMeteor("1", "ws://meteor-ios-starter-swift.meteor.com/websocket")
    var meteorClient: MeteorClient!
    let version = "1"
    let endpoint = "ws://localhost:3000/websocket"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        meteorClient = MeteorClient.init(DDPVersion: version)
        let ddp = ObjectiveDDP.init(URLString: endpoint, delegate: meteorClient)
        meteorClient.ddp = ddp
        meteorClient.ddp.connectWebSocket()
        
        // Adds a subscription to a database. Not really necessary if you still have the autopublish package on. (?)
        self.meteorClient.addSubscription("cool_kids_collection")
        
        // A few useful notifications to indicate when the Meteor client is fully connected.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportConnection", name: MeteorClientDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportConnectionReady", name:         MeteorClientConnectionReadyNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportDisconnection", name: MeteorClientDidDisconnectNotification, object: nil)
        
        return true
    }
    
    func reportConnection() {
        print("================> connected to server!")
    }
    
    func reportConnectionReady() {
        print("================> server connection ready!")
        // e.g. You can start calling server methods or accessing the databases here!
        // (presumably, do any initialization here and bind other actions to events or buttons)
        
        // Example: calling a server method.
        let paramData = ["param1": "cool", "param2": "kids"]
        print("================> PING'ing the server!")
        self.meteorClient.callMethodName("ping", parameters: [paramData], responseCallback: { (response, err) -> Void in
            // response is an AnyObject dictionary, err is an NSError!
            print(response)
            // This is the actual return object. Cast as whatever type you're returning.
            print(response["result"] as! String)
            print("================> PING over.")
        })
        
        // Example: creating notifications for actions on the collection.
        // Notice that there is a colon after "itemAdded" -- this indicates that
        // the selected callback function is expecting one argument.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemAdded:", name: "cool_kids_collection_added", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemRemoved", name: "cool_kids_collection_removed", object: nil)
        
        // Example: inserting an object into a collection.
        var _id:String!
        let newObject = ["param1": "here's an example", "param2": "cheers"]
        print("================> Inserting an object!")
        self.meteorClient.callMethodName("/cool_kids_collection/insert", parameters: [newObject], responseCallback: { (response, err) -> Void in

            // The returned object is the inserted object, including its _id.
            // You need to cast do some funky casting, but it's alright...
            print(response)
            _id = ((response["result"] as! Array)[0] as Dictionary)["_id"]
            print(_id)
            
            print("================> Insertion successful!")
            
            // Example: removing the previously inserted object.
            // Keep in mind that these calls are all asynchronous.
            let removeQuery = ["_id": _id]
            print("================> Removing an object!")
            self.meteorClient.callMethodName("/cool_kids_collection/remove", parameters: [removeQuery], responseCallback: nil)
        })
    }
    
    // Callbacks for each notification.
    
    // You MUST match up the number of arguments here with the selector, otherwise
    // you're going to get a runtime error.
    func itemAdded(res: NSNotification) {
        print("================> Notification: Item was added.")
        // println(res) // if you want to inspect the notification
        
        // The actually useful return info from an item being added.
        // In this example, it's the entry that was just added to the
        // collection you're observing.
        let returnInfo = res.userInfo as? Dictionary<String, String>
        print(returnInfo)
    }
    
    func itemRemoved() {
        print("================> Notification: Item was removed.")
    }
    
    func reportDisconnection() {
        print("================> disconnected from server!")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

