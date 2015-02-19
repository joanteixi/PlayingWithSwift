//
//  SpecialityContributionDetailViewController.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 18/02/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation
import UIKit

class SpecialityContributionDetailViewController : UIViewController,UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var specialityImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    var speciality: Speciality!
    var api: ApiController?
    let kCellIdentifier: String = "SearchResultCell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.speciality.name
        
        let url = NSURL(string: self.speciality!.imageUrl)
        let data = NSData(contentsOfURL: url!)
        specialityImage.image = UIImage(data: data!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
}