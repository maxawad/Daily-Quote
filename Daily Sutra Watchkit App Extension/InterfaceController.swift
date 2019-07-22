//
//  InterfaceController.swift
//  Daily Quote Watchkit App Extension
//
//  Created by Moustafa Awad on 6/28/18.
//  Copyright © 2018 Moustafa Awad. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController {

    // MARK: - Outlets
    
    @IBOutlet var QuoteLabelOutlet: WKInterfaceLabel!
    @IBOutlet var NextOutlet: WKInterfaceButton!
    @IBOutlet var watchGroupOutlet: WKInterfaceGroup!
    
    @IBAction func NextAction() {
        newQuote()
    }
    
    func newQuote() {
        let counter = Int.random(in: 0 ..< watchData.count)
        let quote = watchData[counter]["quote"]! + " - " + watchData[counter]["where"]!
        let session = WCSession.default
        QuoteLabelOutlet.setText(quote)
        if session.activationState == .activated {
            try! session.updateApplicationContext(["quote" : quote])
            scroll(to: watchGroupOutlet, at: .top, animated: true)
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        newQuote()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    

}
