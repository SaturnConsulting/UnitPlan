//
//  MapViewController.swift
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
import GoogleMaps

class MapViewController: UIViewController {
  
  // outlets
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet private weak var mapCenterPinImage: UIImageView!
  @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
  
  // properties
  private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
  private let locationManager = CLLocationManager()
  // use dataProvider (defined in GoogleDataProvider.swift) to make calls to the Google Places Web API
  private let dataProvider = GoogleDataProvider()
  // use searchRadius to determine how far from the user’s location (in meters) to search for places
  private let searchRadius: Double = 1000
  
  // viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // make MapViewController the delegate of locationManager and request access to the user’s location
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    // make MapViewController the map view’s delegate
    mapView.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navigationController = segue.destination as? UINavigationController,
      let controller = navigationController.topViewController as? TypesTableViewController else {
        return
    }
    controller.selectedTypes = searchedTypes
    controller.delegate = self
  }
  
  private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
    // Creates a GMSGeocoder object to turn a latitude and longitude coordinate into a street address.
    let geocoder = GMSGeocoder()

    // Asks the geocoder to reverse geocode the coordinate passed to the method. It then verifies there is an address in the response of type GMSAddress. This is a model class for addresses returned by the GMSGeocoder
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      self.addressLabel.unlock()
      
      guard let address = response?.firstResult(), let lines = address.lines else {
        return
      }
      
      // Sets the text of the addressLabel to the address returned by the geocoder.
      self.addressLabel.text = lines.joined(separator: "\n")
      
      // Prior to the animation block, add padding to the top and bottom of the map. The top padding equals the view’s top safe area inset, while the bottom padding equals the label’s height
      let labelHeight = self.addressLabel.intrinsicContentSize.height
      self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                          bottom: labelHeight, right: 0)
      
      // Once the address is set, animate the changes in the label’s intrinsic content size.
      UIView.animate(withDuration: 0.25) {
        
        // Update the location pin’s position to match the map’s padding by adjusting its vertical layout constraint
        self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
        self.view.layoutIfNeeded()
      }
    }
  }
  
  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    // Clear the map of all markers.
    mapView.clear()
    
    // Use dataProvider to query Google for nearby places within the searchRadius, filtered to the user’s selected types.
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
      places.forEach {
        // Iterate through the results returned in the completion closure and create a PlaceMarker for each result.
        let marker = PlaceMarker(place: $0)
        // Set the marker’s map. This line of code is what tells the map to render the marker.
        marker.map = self.mapView
      }
    }
  }
  
  @IBAction func refreshPlaces(_ sender: Any) {
    fetchNearbyPlaces(coordinate: mapView.camera.target)
  }
}

// MARK: - TypesTableViewControllerDelegate
extension MapViewController: TypesTableViewControllerDelegate {
  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    
    // user has the ability to change the types of places to display on the map, so you’ll need to update the search results if the selected types change
    fetchNearbyPlaces(coordinate: mapView.camera.target)
  }
}

// MARK: - CLLocationManagerDelegate

// create a MapViewController extension that conforms to CLLocationManagerDelegate.
extension MapViewController: CLLocationManagerDelegate {
  // create a MapViewController extension that conforms to CLLocationManagerDelegate.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // verify the user has granted you permission while the app is in use.
    guard status == .authorizedWhenInUse else {
      return
    }
    
    // Once permissions have been established, ask the location manager for updates on the user’s location.
    locationManager.startUpdatingLocation()
    
    // GMSMapView has two features concerning the user’s location: myLocationEnabled draws a light blue dot where the user is located, while myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  // locationManager(_:didUpdateLocations:) executes when the location manager receives new location data
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    
    // This updates the map’s camera to center around the user’s current location. The GMSCameraPosition class aggregates all camera position parameters and passes them to the map for display
  
  // viewing angles: 0 is straight down, 45 is about right.  However, angle will reset to 0 when locate button pressed.
  // zoom 5 is australia wide, 15 is suburb, 17 is street level, 20 is house
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 45)
  
    // Tell locationManager you’re no longer interested in updates; you don’t want to follow a user around as their initial location is enough for you to work with.
    locationManager.stopUpdatingLocation()
    // user can reasonably expect to see places nearby when the app launches.
    fetchNearbyPlaces(coordinate: location.coordinate)
  }
}

// MARK: - GMSMapViewDelegate
// This will declare that MapViewController conforms to the GMSMapViewDelegate protocol
// Call this method every time the user changes their position on the map.
extension MapViewController: GMSMapViewDelegate {
  
  // This method is called each time the map stops moving and settles in a new position, where you then make a call to reverse geocode the new position and update the addressLabel‘s text
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
  
  // This method is called every time the map starts to move. It receives a Bool that tells you if the movement originated from a user gesture, such as scrolling the map, or if the movement originated from code. You call the lock() on the addressLabel to give it a loading animation.
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    addressLabel.lock()
    
    //  pin needs to re-appear at some point.
    // This checks if the movement originated from a user gesture; if so, it un-hides the location pin using the fadeIn(_:) method. Setting the map’s selectedMarker to nil will remove the currently presented infoView.
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  // This method is called each time the user taps a marker on the map. If you return a view, then it pops up above the marker
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    // You first cast the tapped marker to a PlaceMarker.
    guard let placeMarker = marker as? PlaceMarker else {
      return nil
    }
    // create a MarkerInfoView from its nib. The MarkerInfoView class is a UIView subclass that comes with the starter project for this tutorial.
    guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
      return nil
    }
    
    // apply the place name to the nameLabel.
    infoView.nameLabel.text = placeMarker.place.name
    
    // Check if there’s a photo for the place. If so, add that photo to the info view. If not, add a generic photo instead
    if let photo = placeMarker.place.photo {
      infoView.placePhoto.image = photo
    } else {
      infoView.placePhoto.image = UIImage(named: "generic")
    }
    
    return infoView
  }
  
  
  // make sure the location pin doesn’t cover the info window. This method simply hides the location pin when a marker is tapped. The method returns false to indicate that you don’t want to override the default behavior — to center the map around the marker — when tapping a marker.
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // This method runs when the user taps the Locate button; the map will then center on the user’s location. Returning false again indicates that it does not override the default behavior when tapping the button.
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
}

































