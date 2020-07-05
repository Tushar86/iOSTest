//
//  Helper.swift
//  Proficiency Exercise
//
//  Created by Tushar on 05/07/20.
//  Copyright © 2020 Tushar. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

class Helper{
    
    static let shared = Helper()
    
    typealias completionBlock = ([Model]) -> ()
    
    func getDataFromApi(withUrl dataUrl : String, completionBlock : @escaping completionBlock){
        guard let url = URL(string: dataUrl) else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let serializedString = String.init(data: data!, encoding: String.Encoding.ascii) {
                    let asciiData = serializedString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                    let json = try JSONSerialization.jsonObject(with: asciiData!, options: []) as? JSONDictionary
                    let dictionaries = json!["rows"] as! [JSONDictionary]
                    let sources = dictionaries.compactMap(Model.init)
                    DispatchQueue.main.async {
                        completionBlock(sources)
                    }
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
}
