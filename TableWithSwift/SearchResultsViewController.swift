//
//  ViewController.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 16/2/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApiControllerProtocol{

    @IBOutlet var appsTableView: UITableView?
    var tableData = []
    var api = ApiController()
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api.delegate = self

        api.searchOnfanFor("JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let specialityObject: NSDictionary = rowData["speciality"] as NSDictionary
        var name: String = specialityObject["name"] as NSString
        
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = "message"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let specialityObject: NSDictionary = rowData["speciality"] as NSDictionary
        let cellText: String? = specialityObject["name"] as? NSString

        cell.textLabel?.text = cellText
        cell.imageView?.image = UIImage(named: "Blank52")
    
    
        let urlString = rowData["image"] as String
        var image = self.imageCache[urlString]
        
        
        
        // TODO http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-5-async-image-loading-and-caching/
        
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        } else {
            
        }
        
        
        let imgURL: NSURL? = NSURL(string: urlString)
        
        
        
        // Download an NSData representation of the image at the URL
        let imgData = NSData(contentsOfURL: imgURL!)
        cell.imageView?.image = UIImage(data: imgData!)
        
        // Get the formatted price string for display in the subtitle
        let venueObject: NSDictionary = specialityObject["venue"] as NSDictionary
        let venueName: NSString = venueObject["name"] as NSString
        
        cell.detailTextLabel?.text = venueName
        
        return cell;
    }

    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["records"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }
    

    
}

