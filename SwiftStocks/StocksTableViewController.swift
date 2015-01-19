//
//  StocksTableViewController.swift
//  SwiftStocks
//
//  Created by MARIO EGUILUZ ALEBICTO on 07/08/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import UIKit

class StocksTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //1
    private var stocks: [(String,Double)] = [("AAPL",+1.5),("FB",+2.33),("GOOG",-4.3)]
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stocksUpdated:", name: kNotificationStocksUpdated, object: nil)
        self.updateStocks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return stocks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cellId")
        cell.textLabel!.text = stocks[indexPath.row].0 //position 0 of the tuple: The Symbol "AAPL"
        cell.detailTextLabel!.text = "\(stocks[indexPath.row].1)" + "%" //position 1 of the tuple: The value "1.5" into String
        
        //NEW CODE FOR WIDGETS
        //1
        if(stocks[indexPath.row].0 == "AAPL") {
            let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.SwiftStocks.Widget")!
            let symbolAndprize = "AAPL \(stocks[indexPath.row].1)" + "%"
            defaults.setObject( symbolAndprize , forKey: "AAPLvalue")
        }
        
        return cell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    //Customize the cell
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        switch stocks[indexPath.row].1 {
            case let x where x < 0.0:
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            case let x where x > 0.0:
                cell.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            case let x:
                cell.backgroundColor = UIColor(red: 44.0/255.0, green: 186.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        }
        
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 48)
        cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 48)
        cell.textLabel!.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.textLabel!.shadowOffset = CGSize(width: 0, height: 1)
        cell.detailTextLabel!.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        cell.detailTextLabel!.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    //Customize the height of the cell
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 120
    }
    
    //Stock updates
    //3
    func updateStocks() {
        let stockManager:StockManagerSingleton = StockManagerSingleton.sharedInstance
        stockManager.updateListOfSymbols(stocks)
        
        //Repeat this method after 15 secs. (For simplicity of the tutorial we are not cancelling it never)
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(15 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            {
                self.updateStocks()
            }
        )
    }
    
    //4
    func stocksUpdated(notification: NSNotification) {
        let values = (notification.userInfo as Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[kNotificationStocksUpdated]!
        stocks.removeAll(keepCapacity: false)
        for quote in stocksReceived {
            let quoteDict:NSDictionary = quote as NSDictionary
            var changeInPercentString = quoteDict["ChangeinPercent"] as String
            let changeInPercentStringClean: NSString = (changeInPercentString as NSString).substringToIndex(countElements(changeInPercentString)-1)
            stocks.append(quoteDict["symbol"] as String,changeInPercentStringClean.doubleValue)
        }
        tableView.reloadData()
        NSLog("Symbols Values updated :)")
    }
}

