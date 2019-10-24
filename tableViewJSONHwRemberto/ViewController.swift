//
//  ViewController.swift
//  tableViewJSONHwRemberto
//
//  Created by Remberto  Nunez  on 10/16/19.
//  Copyright © 2019 Remberto  Nunez . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var pokemonTableView: UITableView!
  var dict: [String:Any] = [:]
  var dictArr: [String:Any] = [:]
  var sortKeys: [String] = []
  var arr: [Any] = []
  var nextApi:String? = "https://pokeapi.co/api/v2"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pokemonTableView.dataSource = self
    pokemonTableView.delegate = self
    
    guard let apiURL = nextApi else { return }
    guard let startURL = URL(string: apiURL) else { return }
    let task = URLSession.shared.dataTask(with: startURL) { (data, response, error) in
      guard let dataResponse = data, error == nil else { print("Response Error")
        return }
      do {
        //here dataResponse received from a network request
        let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
        if let jsonDic = jsonResponse as? [String: Any] {
          self.dict = jsonDic
        } else if let jsonArray = jsonResponse as? [String] {
          self.arr = jsonArray
        } else {
          print("something went wrong")
        }
        DispatchQueue.main.async {
          self.pokemonTableView.reloadData()
        }
      } catch let parsingError {
        print("Error", parsingError)
      }
    }
    task.resume()
  }
  
  // Go back to the home page
  @IBAction func backToFirst(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
  }
  
}

// Table View
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.arr.isEmpty {
      return dict.count
    } else {
      return arr.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    self.sortKeys = self.dict.keys.sorted()
    
    if self.arr.isEmpty {
      
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
      let key = self.sortKeys[indexPath.row]
      cell.textLabel?.text = key
      
      if let value = self.dict[key] {
        if value is Int {
          cell.detailTextLabel?.text = "\(value)"
        } else if value is String {
          cell.detailTextLabel?.text = "\(value)"
        } else if value is NSNull {
          cell.detailTextLabel?.text = "NULL Value"
        } else if value is [Any] {
          if let val = value as? [Any] {
            cell.detailTextLabel?.text = "Total Array: \(val.count)"
          }
        } else if value is [String:Any] {
          if let val = value as? [String:Any] {
            cell.detailTextLabel?.text = "Total Dictionaries: \(val.count)"
          }
        } else if value is Bool {
          if let val = value as? Bool {
            cell.detailTextLabel?.text = "\(val)"
          }
        }
      }
      return cell
    } else {
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
      cell.textLabel?.text = "Index[\(indexPath.row)]"
      return cell
    }
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateViewController(identifier: "next") as! ViewController
    
    if arr.isEmpty {
      let value = self.dict[sortKeys[indexPath.row]]
      if value is String {
        if let val = value as? String {
          if val.starts(with: "https") {
            viewController.nextApi = val
            navigationController?.pushViewController(viewController, animated: true)
          }
        }
      } else if value is [Any] {
        if let val = value as? [Any] {
          viewController.arr = val
          viewController.nextApi = nil
          navigationController?.pushViewController(viewController, animated: true)
        }
      } else if value is [String:Any] {
        if let val = value as? [String: Any] {
          viewController.dict = val
          viewController.sortKeys = self.dict.keys.sorted()
          viewController.nextApi = nil
          navigationController?.pushViewController(viewController, animated: true)
        }
      }
    } else {
      if let dicArr = arr[indexPath.row] as? [String:Any] {
        viewController.dict = dicArr
        viewController.sortKeys = self.dict.keys.sorted()
        viewController.nextApi = nil
        navigationController?.pushViewController(viewController, animated: true)
      }
    }
  }
}
