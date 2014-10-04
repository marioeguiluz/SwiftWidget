//
//  TodayViewController.swift
//  StockWidget
//
//  Created by MARIO EGUILUZ ALEBICTO on 03/10/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    //0
    @IBOutlet weak var labelWidget: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        dispatch_async(dispatch_get_main_queue(),{
            self.labelWidget.text = "APPL +2.7%"
            
            //2
            let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.SwiftStocks.Widget")
            self.labelWidget.text = defaults.objectForKey("AAPLvalue") as NSString
        });

        completionHandler(NCUpdateResult.NewData)
    }
    
}
