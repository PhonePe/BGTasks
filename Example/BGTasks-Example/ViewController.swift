//
//  ViewController.swift
//  BGFramework
//
//  Created by Shridhara V on 03/08/2021.
//  Copyright (c) 2021 Shridhara V. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sync1: Sync1Handler?
    var sync2: Sync2Handler?

    var arraySyncs = [GenericSyncHandler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        
        self.sync1 = Sync1Handler()
        self.sync2 = Sync2Handler()
        
        for i in 3..<8 {
            arraySyncs.append(GenericSyncHandler(identifier: "id_\(i)", duration: TimeInterval(5), requiresNetworkConnectivity: true))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
