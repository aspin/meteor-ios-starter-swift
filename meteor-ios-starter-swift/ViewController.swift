//
//  ViewController.swift
//  meteor-ios-starter-swift
//
//  Created by Kevin Chen on 5/27/15.
//  Copyright (c) 2015 aspin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var meteorClient:MeteorClient!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Exposes the meteorClient data (initialized from AppDelegate) to this view controller.
        // Keep in mind that the client MIGHT not be ready yet though.
        // (e.g. everything will probably be ready by the time a user can feasibly make an input, but
        //  if this is the first view that appears after loading, you probably don't want to do any
        //  sort of initialization in this viewDidLoad function)
        self.meteorClient = (UIApplication.sharedApplication().delegate as! AppDelegate).meteorClient
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

