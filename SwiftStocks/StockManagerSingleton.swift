//
//  StockManagerSingleton.swift
//  SwiftStocks
//
//  Created by MARIO EGUILUZ ALEBICTO on 18/08/14.
//  Copyright (c) 2014 MARIO EGUILUZ ALEBICTO. All rights reserved.
//

import Foundation
let kNotificationStocksUpdated = "stocksUpdated"

class StockManagerSingleton {
    
    //Singleton Init
    class var sharedInstance : StockManagerSingleton {
    struct Static {
        static let instance : StockManagerSingleton = StockManagerSingleton()
        }
        return Static.instance
    }
    
    /*!
    * @discussion Function that given an array of symbols, get their stock prizes from yahoo and send them inside a NSNotification UserInfo
    * @param stocks An Array of tuples with the symbols in position 0 of each tuple
    */
    func updateListOfSymbols(stocks:Array<(String,Double)>) ->() {
        
        //1: YAHOO Finance API: Request for a list of symbols example:
        //http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN ("AAPL","GOOG","FB")&format=json&env=http://datatables.org/alltables.env
        
        //2: Build the URL as above with our array of symbols
        var stringQuotes = "(";
        for quoteTuple in stocks {
            stringQuotes = stringQuotes+"\""+quoteTuple.0+"\","
        }
        stringQuotes = stringQuotes.substringToIndex(stringQuotes.endIndex.predecessor())
        stringQuotes = stringQuotes + ")"
        
        var urlString:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN "+stringQuotes+"&format=json&env=http://datatables.org/alltables.env").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url : NSURL = NSURL.URLWithString(urlString)
        var request: NSURLRequest = NSURLRequest(URL:url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        //3: Completion block/Clousure for the NSURLSessionDataTask
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                println(error.localizedDescription)
            }
            else {
                var err: NSError?
                //4: JSON process
                var jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                else {
                    //5: Extract the Quotes and Values and send them inside a NSNotification
                    var quotes:NSArray = ((jsonDict.objectForKey("query") as NSDictionary).objectForKey("results") as NSDictionary).objectForKey("quote") as NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationStocksUpdated, object: nil, userInfo: [kNotificationStocksUpdated:quotes])
                    })
                }
            }
        })
        
        //6: DONT FORGET to LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
    }
}
