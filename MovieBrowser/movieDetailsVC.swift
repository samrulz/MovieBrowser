//
//  movieDetailsVC.swift
//  MovieBrowser
//
//  Created by SAGAR THAKARE on 03/11/18.
//  Copyright © 2018 SAGAR THAKARE. All rights reserved.
//

import UIKit
import SDWebImage

class movieDetailsVC: UIViewController {

  
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var overViewText: UITextView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var lblTitleWithDate: UILabel!
    
    var getOverview:String?
    var getReleaseDate:String?
    var getOriginalTitle:String?
    var getRating:String?
    var getImage:String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movie Details"
    
        posterView.sd_setImage(with: URL(string: getImage!  ), placeholderImage: UIImage(named: "placeholder.png"))
        overViewText.text = getOverview!
        lblTitleWithDate.text = "\(getOriginalTitle!) | \(getReleaseDate!)"
        lblStar.text = getRating!
        

    }



}


