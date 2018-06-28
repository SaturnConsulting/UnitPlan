//
//  GoogleDataProvider.swift
//  Feed Me
//
/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

typealias PlacesCompletion = ([GooglePlace]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
  private var photoCache: [String: UIImage] = [:]
  private var placesTask: URLSessionDataTask?
  private var placesTask2: URLSessionDataTask?
  private var session: URLSession {
    return URLSession.shared
  }
  
  func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping PlacesCompletion) -> Void {
    
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
    let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
    urlString += "&types=\(typesString)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
    
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
      task.cancel()
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    placesTask = session.dataTask(with: url) { data, response, error in
      var placesArray: [GooglePlace] = []
      defer {
        DispatchQueue.main.async {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          completion(placesArray)
        }
      }
      guard let data = data,
        let json = try? JSON(data: data, options: .mutableContainers),
        let results = json["results"].arrayObject as? [[String: Any]] else {
          return
      }
      results.forEach {
        let place = GooglePlace(dictionary: $0, acceptedTypes: types)
        placesArray.append(place)
        if let reference = place.photoReference {
          self.fetchPhotoFromReference(reference) { image in
            place.photo = image
          }
        }
      }
    }
    placesTask?.resume()
  }
  
  func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) -> Void {
    if let photo = photoCache[reference] {
      completion(photo)
    } else {
      let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(googleApiKey)"
      guard let url = URL(string: urlString) else {
        completion(nil)
        return
      }
      
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
      
      session.downloadTask(with: url) { url, response, error in
        var downloadedPhoto: UIImage? = nil
        defer {
          DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(downloadedPhoto)
          }
        }
        guard let url = url else {
          return
        }
        guard let imageData = try? Data(contentsOf: url) else {
          return
        }
        downloadedPhoto = UIImage(data: imageData)
        self.photoCache[reference] = downloadedPhoto
        }
        .resume()
    }
  }
  
  // MARK: lookup address trial
  // API key must be activated with GeoCoding API on Google Developer portal and format of the request looks like this:
  
  // https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
  
  func performGoogleSearch(_ address: String) -> Void { //}, completion: @escaping PlacesCompletion) -> Void {
    //performGoogleSearch("9+Fingal+Street+CRACE+ACT+2911")
    let siteurl = "https://maps.googleapis.com/maps/api/geocode/json?address="
    let urlString = siteurl + address + "&key=" + googleApiKey
    print(urlString)
    
    guard let url = URL(string: urlString) else {
      // completion([])
      print("Guard let fail")
      return
    }
    print(url)
    
    if let task = placesTask2, task.taskIdentifier > 0 && task.state == .running {
      print("task.cancel")
      task.cancel()
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      print("DispatchQueue...")
    }
    
    let temptask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if error != nil {
        print("JSON Error")
      } else {
        if let content = data {
          do
          {
            // now convert json to string
            let myJson = try JSONSerialization.jsonObject(with: content, options:
              JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            //print(myJson)
            // refer https://developers.google.com/maps/documentation/geocoding/intro
            
            // if let results = myJson["results"] as? [[String: Any]] {
            if let results = myJson["results"] as? NSArray {
              print(results.count) // array of 1 set of results
              let geometry = results.value(forKey: "geometry")
              print("geometry: \(geometry)")
              print(type(of: geometry)) // it's an NSSingleObjectArrayI
              
              //let lat = [geometry, objectAtIndex:1]
              //print("lat:\(lat)")
              //print("results:\(results)")
            } else
            {
              print("error parsing JSON as String")
            }
          }
          catch
          {
            // if json conversion to array doesn't work
          }
        }
      }
    }
    temptask.resume()
  }
}












