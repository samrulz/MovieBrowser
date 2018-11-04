//
//  ApiManager.swift
//  MovieBrowser
//
//  Created by SAGAR THAKARE on 03/11/18.
//  Copyright © 2018 SAGAR THAKARE. All rights reserved.
//
import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ApiManager: NSObject {
   // static let baseUrl = "https://api.themoviedb.org/3/movie/550?api_key=f8dc9faa54a1cd7fee02f491c43cc153"
    static let baseUrl = "https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2014-09-15&primary_release_date.lte=2014-10-22&api_key=f8dc9faa54a1cd7fee02f491c43cc153"
    

}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

public func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
    
    if Connectivity.isConnectedToInternet {
        SVProgressHUD.show()
        
        Alamofire.request(strURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (responseObject) -> Void in
            
            // print(responseObject)
            
            if responseObject.result.isSuccess {
                SVProgressHUD.dismiss()
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }else{
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Movie Browser", message: "Please,check your internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
}

