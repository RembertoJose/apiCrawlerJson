//
//  NetworkManager.swift
//  JSONParsingProjects
//
//  Created by Remberto  Nunez  on 10/15/19.
//  Copyright © 2019 Remberto  Nunez . All rights reserved.
//

import Foundation

class NetworkManager {
  
  static let shared = NetworkManager()
  
  private init() { }
  
  func callAPI(using urlString: String, completion: @escaping (Data?, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(nil, NetworkError.NotAUrl)
      return
    }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      completion(data, error)
    }.resume()
  }
}

enum NetworkError: Error {
  case NotAUrl
}
