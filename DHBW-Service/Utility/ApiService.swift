//
//  ApiService.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 29.01.21.
//

import Foundation

class ApiService {
    // MARK: HTTP POST Request
    public class func callPost(url: URL, parameters: [String:Any], finish: @escaping ((message: String, data: Data?)) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set params
        let postString = self.getPostString(params: parameters)
        request.httpBody = postString.data(using: .utf8)

        var result: (message: String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            do {
                guard error == nil else {
                    throw HttpFetchError.fetchError
                }

                guard let data = data else {
                    throw HttpFetchError.noDataReceivedError
                }
                
                result.message = "Success"
                result.data = data
            } catch let error {
                print(error.localizedDescription)
            }
            
            finish(result)
        }
        
        task.resume()
    }
    
    // MARK: HTTP GET Request
    public class func callGet(url: URL, finish: @escaping ((message: String, data: Data?)) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")

        var result: (message: String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            do {
                guard error == nil else {
                    throw HttpFetchError.fetchError
                }

                guard let data = data else {
                    throw HttpFetchError.noDataReceivedError
                }
                
                result.message = "Success"
                result.data = data
            } catch let error {
                print(error.localizedDescription)
            }
            
            finish(result)
        }
        
        task.resume()
    }
    
    // MARK: Data preparation
    private class func getPostString(params: [String:Any]) -> String {
        var data = [String]()
        for(key, value) in params{
            data.append(key + "=\(value)")
        }
        return data.map{String($0)}.joined(separator: "&")
    }
    
    // MARK: Error enum
    private enum HttpFetchError: Error {
        case fetchError
        case noDataReceivedError
    }
}
