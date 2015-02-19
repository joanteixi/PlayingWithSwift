//
//  ApiController.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 17/2/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation

protocol ApiControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class ApiController
{
    var delegate: ApiControllerProtocol
    
    init(delegate: ApiControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchOnfanFor(searchTerm: String)
    {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://test.onfan.com/api/v4/users/4/specialitycontribution"
            self.get(urlPath)
        }
    }

    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println("ups.. error here")
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["records"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        
        task.resume()
        
        
    }
}
