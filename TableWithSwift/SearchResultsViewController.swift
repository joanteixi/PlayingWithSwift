//
//  ViewController.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 16/2/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//
// SOURCE http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-5-async-image-loading-and-caching/

import UIKit
import QuartzCore

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApiControllerProtocol{

    @IBOutlet var appsTableView: UITableView?
    var tableData = []
    var speciality = [Speciality]()
    
    var api: ApiController?
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = ApiController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchOnfanFor("JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: SpecialityContributionDetailViewController = segue.destinationViewController as SpecialityContributionDetailViewController
        var specialityIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedSpecialityContribution = self.speciality[specialityIndex]
        detailsViewController.specialityContribution = selectedSpecialityContribution
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speciality.count;
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let specialityContribution = self.specialityContributions[indexPath.row]

        cell.textLabel?.text = specialityContribution.speciality.name
        cell.imageView?.image = UIImage(named: "Blank52")
        cell.detailTextLabel?.text = specialityContribution.speciality.venue.name
    
        let urlString = specialityContribution.imageUrl
        var image = self.imageCache[urlString]
        
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
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        
        let imgURL: NSURL? = NSURL(string: urlString)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    

    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["records"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            
            self.specialityContributions = SpecialityContribution.contributionsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        })
    }
    

    
}

