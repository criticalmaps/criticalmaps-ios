//
//  InterfaceController.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/8/19.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {
    @IBOutlet var map: WKInterfaceMap!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
