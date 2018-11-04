//
//  PopOverVC.swift
//  MovieBrowser
//
//  Created by SAGAR THAKARE on 03/11/18.
//  Copyright © 2018 SAGAR THAKARE. All rights reserved.
//

import UIKit

class PopOverVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var titleData = [String]()
    var imageData = [String]()
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleData = ["Ascending","Descending"]
        imageData = ["sort-ascending","sort-descending"]
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden  = true
    }

}
//MARK:TableViewDataSource

extension PopOverVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PopOverList
        cell.popImage.image = UIImage(named: imageData[indexPath.row])
        cell.lblAscending.text = titleData[indexPath.row]
         print(UserDefaults.standard.value(forKey: "storeRatings")!)
        
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sortArray = UserDefaults.standard.value(forKey: "storeRatings")! as! [String]
        print(sortArray)
        
        
        if indexPath.row == 0{
            
            sortArray.sort { (first, second) -> Bool in
                return first > second
            }
            
            print(sortArray)
           
            dismiss(animated: true, completion: nil)
        }else{
            sortArray.sort { (first, second) -> Bool in
                return first < second
            }
            print(sortArray)
            
            dismiss(animated: true, completion: nil)
        }
    }
}
//MARK:UITableViewCell

class PopOverList: UITableViewCell {
   
    @IBOutlet weak var popImage: UIImageView!
    
    @IBOutlet weak var lblAscending: UILabel!
    
}
