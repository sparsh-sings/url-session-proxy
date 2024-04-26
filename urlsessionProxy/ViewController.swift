//
//  ViewController.swift
//  urlsessionProxy
//
//  Created by Sparsh Singh on 25/04/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performRequest()
    }

    
    func performRequest() {
        
        let proxyManager = ProxyManager.shared
        proxyManager.configureProxy(server: "103.110.127.85", port: 10443, username: "admin", password: "admin" , proxyType: .http)
        
        // Create URLSession with proxy configuration
        let session: URLSession
        if let proxyConfiguration = proxyManager.proxyConfiguration {
            session = URLSession(configuration: proxyConfiguration)
        } else {
            session = URLSession.shared
        }
        
        // Make request to ip-api.com
        let url = URL(string: "http://ip-api.com/json")!
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            if let data = data,
               let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("No data received")
            }
        }
        
        task.resume()
        
        
        
    }

}

