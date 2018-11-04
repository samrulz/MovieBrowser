//
//  ViewController.swift
//  MovieBrowser
//
//  Created by SAGAR THAKARE on 03/11/18.
//  Copyright © 2018 SAGAR THAKARE. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating,UIPopoverPresentationControllerDelegate {
    
    var filtered:[String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    

    
   
   
    
    var movieList = [String]()
    var movieBannar = [String]()
    var movieOverView = [String]()
    var movieRating = [String]()
    var movieReleaseDate = [String]()
    var movieOriginalTitle = [String]()
//    var filteredData = [String]()
    
    
    @IBOutlet weak var btnsetting: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var data1 = [String]()
    var filteredData = [String]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtered = movieList
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Movie"
        searchController.searchBar.sizeToFit()
        
        
        searchController.searchBar.becomeFirstResponder()
        
        
        self.navigationItem.titleView = searchController.searchBar
        
        getServiceCall()
        
    
       
        
    }
    
    
    
    
    
    func getServiceCall() {
        
        let url = ApiManager.baseUrl
        requestGETURL(url, params: nil, success: { (data) in
            print(data)
            
            let result = data["results"].arrayValue
            
            var dataIterator = 0
            for resultlist in result{
                let title = resultlist["title"].stringValue
                let bannar = resultlist["poster_path"].stringValue
                let posterPath = "https://image.tmdb.org/t/p/original/\(bannar)"
                let overView = resultlist["overview"].stringValue
                let rating = resultlist["vote_average"].stringValue
                let releaseDate = resultlist["release_date"].stringValue
                let originalTitle = resultlist["original_title"].stringValue
                
                self.movieList.insert(title, at: dataIterator)
                
               
                self.movieBannar.insert(posterPath, at: dataIterator)
                self.movieOverView.insert(overView, at: dataIterator)
                self.movieRating.insert(rating, at: dataIterator)
                self.movieReleaseDate.insert(releaseDate, at: dataIterator)
                self.movieOriginalTitle.insert(originalTitle, at: dataIterator)
                
                dataIterator = dataIterator + 1
               
            }
            print(self.movieRating)
            let defaults = UserDefaults.standard
            defaults.set(self.movieRating, forKey: "storeRatings")
            
            
            self.collectionView.reloadData()
       
            
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func btnSettingsTapped(_ sender: Any) {
      
        performSegue(withIdentifier: "reusable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "reusable")
        {
            let dvc = segue.destination as! PopOverVC
            dvc.preferredContentSize = CGSize(width: 200, height: 90)
            if let pop = dvc.popoverPresentationController
            {
                pop.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filtered = movieList.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filtered = movieList
        }
//        let searchString = searchController.searchBar.text
//
//        filtered = movieList.filter({ (item) -> Bool in
//            let countryText: NSString = item as NSString
//
//            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
        
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    }




extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive {
            return filtered.count
        }
        else
        {
            return movieList.count
        }

 
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Movielist
      
        cell.movieTitle.text = movieList[indexPath.row]
        cell.movieBanner.sd_setImage(with: URL(string: movieBannar[indexPath.row] ), placeholderImage: UIImage(named: "placeholder.png"))

        return cell
        
       }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusable", for: indexPath) as! SearchBarReusableView
            
            headerView.searchBar.delegate = self
        
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width-35)/2 , height:180)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let overView = self.movieOverView[indexPath.row]
        let rating = self.movieRating[indexPath.row]
        let releaseDate = self.movieReleaseDate[indexPath.row]
        let originalTitle = self.movieOriginalTitle[indexPath.row]
        let image = movieBannar[indexPath.row]
  
        let controller = storyboard?.instantiateViewController(withIdentifier: "movieDetailsVC") as! movieDetailsVC
        controller.getImage = image
        controller.getRating = rating
        controller.getOverview = overView
        controller.getReleaseDate = releaseDate
        controller.getOriginalTitle = originalTitle
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
   
    
}

class Movielist: UICollectionViewCell {
 
    @IBOutlet weak var movieBanner: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    func congigureCell(text: String) {
        
        movieTitle.text = text
    }
    
}

class SearchBarReusableView: UICollectionReusableView {
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
}

