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
  
  struct Building {
    var UPNo: String
    var Name: String
    var Address: String
    var Suburb: String
    var Lat: Double
    var Long: Double
  }
  
  var UnitPlans: [Building] = []
  
  private let locationManager = CLLocationManager()
  // use dataProvider (defined in GoogleDataProvider.swift) to make calls to the Google Places Web API
  private let dataProvider = GoogleDataProvider()
  // use searchRadius to determine how far from the user’s location (in meters) to search for places
  private let searchRadius: Double = 1000
  
  // viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UnitPlans.append(Building(UPNo: "UP1", Name: "Adam's Court", Address: "127 Rivett Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.248492, Long: 149.164605))
    UnitPlans.append(Building(UPNo: "UP2", Name: "", Address: "133 Rivett Street*, 131 Rivett Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.248667, Long: 149.163889))
    UnitPlans.append(Building(UPNo: "UP3", Name: "3 Davies Place", Address: "3 Davies Place TORRENS 2607", Suburb: "TORRENS", Lat: -35.374375, Long: 149.088346))
    UnitPlans.append(Building(UPNo: "UP4", Name: "", Address: "32 Gatton Street FARRER 2607", Suburb: "FARRER", Lat: -35.374758, Long: 149.102674))
    UnitPlans.append(Building(UPNo: "UP5", Name: "", Address: "120 Grayson Street*, 122 Grayson Street*, 114 Grayson Street*, 116 Grayson Street*, 130 Grayson Street*, 118 Grayson Street*, 112 Grayson Street*, 128 Grayson Street*, 124 Grayson Street*, 110 Grayson Street*, 126 Grayson Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.25041, Long: 149.164542))
    UnitPlans.append(Building(UPNo: "UP6", Name: "", Address: "34 Gatton Street FARRER 2607", Suburb: "FARRER", Lat: -35.374964, Long: 149.102853))
    UnitPlans.append(Building(UPNo: "UP7", Name: "", Address: "84 Macgregor Street DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.315694, Long: 149.108173))
    UnitPlans.append(Building(UPNo: "UP8", Name: "", Address: "92 Hodgson Crescent PEARCE 2607", Suburb: "PEARCE", Lat: -35.364563, Long: 149.081442))
    UnitPlans.append(Building(UPNo: "UP9", Name: "Chauvel Court", Address: "14 Chauvel Street CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.290481, Long: 149.154101))
    UnitPlans.append(Building(UPNo: "UP10", Name: "", Address: "6 Irvine Street*, 111 Knox Street*, 109 Knox Street* WATSON 2602", Suburb: "WATSON", Lat: -35.241525, Long: 149.161299))
    UnitPlans.append(Building(UPNo: "UP11", Name: "", Address: "9 Farrer Place* FARRER 2607", Suburb: "FARRER", Lat: -35.375397, Long: 149.102083))
    UnitPlans.append(Building(UPNo: "UP12", Name: "", Address: "19 Devonport Street, 1 Derwent Street LYONS 2606", Suburb: "LYONS", Lat: -35.339847, Long: 149.076412))
    UnitPlans.append(Building(UPNo: "UP13", Name: "Goliath Court", Address: "41 David Street O'CONNOR 2602", Suburb: "O'CONNOR", Lat: -35.264381, Long: 149.123139))
    UnitPlans.append(Building(UPNo: "UP14", Name: "", Address: "96 Newcastle Street*, 9 Collie Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.328089, Long: 149.178342))
    UnitPlans.append(Building(UPNo: "UP15", Name: "", Address: "14 Jalanga Place ARANDA 2614", Suburb: "ARANDA", Lat: -35.257393, Long: 149.079498))
    UnitPlans.append(Building(UPNo: "UP16", Name: "Hillcrest Street", Address: "78 Macgregor Street DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.316069, Long: 149.107336))
    UnitPlans.append(Building(UPNo: "UP17", Name: "", Address: "8 Longerenong Street FARRER 2607", Suburb: "FARRER", Lat: -35.3753, Long: 149.102875))
    UnitPlans.append(Building(UPNo: "UP18", Name: "", Address: "3 Nuyts Street RED HILL 2603", Suburb: "RED HILL", Lat: -35.339998, Long: 149.130839))
    UnitPlans.append(Building(UPNo: "UP19", Name: "", Address: "32 Grayson Street*, 36 Grayson Street*, 52 Grayson Street*, 34 Grayson Street*, 46 Grayson Street*, 50 Grayson Street*, 42 Grayson Street*, 44 Grayson Street*, 38 Grayson Street*, 40 Grayson Street*, 48 Grayson Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.250608, Long: 149.166694))
    UnitPlans.append(Building(UPNo: "UP20", Name: "", Address: "80 Macgregor Street*, 6 Chermside Street* DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.317989, Long: 149.100101))
    UnitPlans.append(Building(UPNo: "UP21", Name: "", Address: "1 Davies Place TORRENS 2607", Suburb: "TORRENS", Lat: -35.374223, Long: 149.087955))
    UnitPlans.append(Building(UPNo: "UP22", Name: "", Address: "11 Earle Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.247544, Long: 149.121942))
    UnitPlans.append(Building(UPNo: "UP23", Name: "Farrer Court", Address: "190 Beasley Street*, 4 Lambrigg Street*, 188B Beasley Street*, 8 Lambrigg Street*, 2A Lambrigg Street*, 2 Lambrigg Street*, 192A Beasley Street*, 188A Beasley Street*, 190A Beasley Street*, 6A Lambrigg Street*, 8A Lambrigg Street*, 6 Lambrigg Street*, 192 Beasley Street*, 4A Lambrigg Street* FARRER 2607", Suburb: "FARRER", Lat: -35.364474, Long: 149.090877))
    UnitPlans.append(Building(UPNo: "UP24", Name: "", Address: "12 Jalanga Crescent ARANDA 2614", Suburb: "ARANDA", Lat: -35.257204, Long: 149.079565))
    UnitPlans.append(Building(UPNo: "UP25", Name: "", Address: "70 Hodgson Crescent PEARCE 2607", Suburb: "PEARCE", Lat: -35.362856, Long: 149.081616))
    UnitPlans.append(Building(UPNo: "UP26", Name: "", Address: "11 Lambrigg Street*, 13 Lambrigg Street*, 198A Beasley Street*, 198 Beasley Street*, 3 Lambrigg Street*, 7 Lambrigg Street*, 196A Beasley Street*, 5 Lambrigg Street*, 196 Beasley Street*, 15 Lambrigg Street*, 9 Lambrigg Street*, 194 Beasley Street*, 1 Lambrigg Street*, 194A Beasley Street* FARRER 2607", Suburb: "FARRER", Lat: -35.372135, Long: 149.09738))
    UnitPlans.append(Building(UPNo: "UP27", Name: "", Address: "60 Grayson Street*, 66 Grayson Street*, 74 Grayson Street*, 56 Grayson Street*, 62 Grayson Street*, 64 Grayson Street*, 68 Grayson Street*, 80 Grayson Street*, 70 Grayson Street*, 58 Grayson Street*, 72 Grayson Street*, 78 Grayson Street*, 54 Grayson Street*, 82 Grayson Street*, 76 Grayson Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.250407, Long: 149.165939))
    UnitPlans.append(Building(UPNo: "UP28", Name: "", Address: "10 Irvine Street, 8 Irvine Street WATSON 2602", Suburb: "WATSON", Lat: -35.238787, Long: 149.156254))
    UnitPlans.append(Building(UPNo: "UP29", Name: "The Terrace", Address: "1 Garran Place GARRAN 2605", Suburb: "GARRAN", Lat: -35.342203, Long: 149.107361))
    UnitPlans.append(Building(UPNo: "UP30", Name: "Grayson Street - Hackett", Address: "102 Grayson Street*, 98 Grayson Street*, 88 Grayson Street*, 106 Grayson Street*, 100 Grayson Street*, 94 Grayson Street*, 92 Grayson Street*, 84 Grayson Street*, 108 Grayson Street*, 104 Grayson Street*, 96 Grayson Street*, 86 Grayson Street*, 90 Grayson Street* HACKETT 2602", Suburb: "HACKETT", Lat: -35.250436, Long: 149.165022))
    UnitPlans.append(Building(UPNo: "UP31", Name: "", Address: "30 Chappell Street LYONS 2606", Suburb: "LYONS", Lat: -35.344931, Long: 149.081565))
    UnitPlans.append(Building(UPNo: "UP32", Name: "", Address: "11 Tryon Street HACKETT 2602", Suburb: "HACKETT", Lat: -35.248909, Long: 149.164984))
    UnitPlans.append(Building(UPNo: "UP34", Name: "", Address: "52 Deloraine Street, 30 Glenorchy Street LYONS 2606", Suburb: "LYONS", Lat: -35.33745, Long: 149.077694))
    UnitPlans.append(Building(UPNo: "UP35", Name: "De Graaf Gardens", Address: "15 Hyndes Crescent*, 17 Hyndes Crescent*, 11 Hyndes Crescent*, 61 De Graaff Street*, 13 Hyndes Crescent*, 21 Hyndes Crescent*, 19 Hyndes Crescent* HOLDER 2611", Suburb: "HOLDER", Lat: -35.334524, Long: 149.044041))
    UnitPlans.append(Building(UPNo: "UP36", Name: "Torrens Court", Address: "1 Basedow Street TORRENS 2607", Suburb: "TORRENS", Lat: -35.373944, Long: 149.087649))
    UnitPlans.append(Building(UPNo: "UP37", Name: "", Address: "62 Wattle Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.253711, Long: 149.126719))
    UnitPlans.append(Building(UPNo: "UP38", Name: "", Address: "45 Eggleston Crescent CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.35107, Long: 149.075264))
    UnitPlans.append(Building(UPNo: "UP39", Name: "", Address: "3 Garran Place GARRAN 2605", Suburb: "GARRAN", Lat: -35.34251, Long: 149.107427))
    UnitPlans.append(Building(UPNo: "UP40", Name: "", Address: "10 Edmondson Street*, 2 Edmondson Street*, 8 Edmondson Street*, 73 Blamey Crescent*, 4 Edmondson Street*, 71 Blamey Crescent*, 69 Blamey Crescent*, 12 Edmondson Street*, 6 Edmondson Street* CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.285527, Long: 149.152358))
    UnitPlans.append(Building(UPNo: "UP41", Name: "", Address: "6 Marrawah Street LYONS 2606", Suburb: "LYONS", Lat: -35.33837, Long: 149.082519))
    UnitPlans.append(Building(UPNo: "UP42", Name: "", Address: "4 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.363987, Long: 149.097253))
    UnitPlans.append(Building(UPNo: "UP43", Name: "", Address: "26 Burara Crescent*, 95 Nemarang Crescent*, 97 Nemarang Crescent*, 16 Burara Crescent*, 20 Burara Crescent*, 22 Burara Crescent*, 24 Burara Crescent*, 18 Burara Crescent* WARAMANGA 2611", Suburb: "WARAMANGA", Lat: -35.351761, Long: 149.060616))
    UnitPlans.append(Building(UPNo: "UP44", Name: "", Address: "8 Corinna Street*, 6 Corinna Street, 2 Corinna Street, 4 Corinna Street LYONS 2606", Suburb: "LYONS", Lat: -35.343895, Long: 149.082037))
    UnitPlans.append(Building(UPNo: "UP45", Name: "Birrell Court", Address: "5 Carroll Street, 9 Wark Street, 7 Wark Street HUGHES 2605", Suburb: "HUGHES", Lat: -35.332708, Long: 149.090882))
    UnitPlans.append(Building(UPNo: "UP47", Name: "", Address: "14 Burara Crescent*, 6 Burara Crescent*, 10 Burara Crescent*, 2 Burara Crescent*, 8 Burara Crescent*, 43 Damala Street*, 4 Burara Crescent*, 12 Burara Crescent* WARAMANGA 2611", Suburb: "WARAMANGA", Lat: -35.35158, Long: 149.060402))
    UnitPlans.append(Building(UPNo: "UP48", Name: "Hackett Court", Address: "127 Madigan Street HACKETT 2602", Suburb: "HACKETT", Lat: -35.253044, Long: 149.160583))
    UnitPlans.append(Building(UPNo: "UP49", Name: "", Address: "113 Knox Street* WATSON 2602", Suburb: "WATSON", Lat: -35.239859, Long: 149.156326))
    UnitPlans.append(Building(UPNo: "UP50", Name: "", Address: "18 Glenmaggie Street DUFFY 2611", Suburb: "DUFFY", Lat: -35.336079, Long: 149.033339))
    UnitPlans.append(Building(UPNo: "UP51", Name: "", Address: "8 Beetaloo Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.244841, Long: 149.041179))
    UnitPlans.append(Building(UPNo: "UP52", Name: "", Address: "8 Giles Street GRIFFITH 2603", Suburb: "GRIFFITH", Lat: -35.318426, Long: 149.138156))
    UnitPlans.append(Building(UPNo: "UP53", Name: "Knox and Antill Streets - Watson", Address: "156 Knox Street*, 257 Antill Street* WATSON 2602", Suburb: "WATSON", Lat: -35.243241, Long: 149.159839))
    UnitPlans.append(Building(UPNo: "UP54", Name: "", Address: "5 Garran Place GARRAN 2605", Suburb: "GARRAN", Lat: -35.342871, Long: 149.107472))
    UnitPlans.append(Building(UPNo: "UP55", Name: "", Address: "6 Beetaloo Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.245312, Long: 149.041004))
    UnitPlans.append(Building(UPNo: "UP56", Name: "154-164 Drake Brockman Drive Holt", Address: "162A Drake-Brockman Drive*, 154 Drake-Brockman Drive*, 160A Drake-Brockman Drive*, 158 Drake-Brockman Drive*, 158A Drake-Brockman Drive*, 156 Drake-Brockman Drive*, 160 Drake-Brockman Drive*, 164 Drake-Brockman Drive*, 164A Drake-Brockman Drive*, 162 Drake-Brockman Drive* HOLT 2615", Suburb: "HOLT", Lat: -35.230441, Long: 149.011592))
    UnitPlans.append(Building(UPNo: "UP57", Name: "", Address: "24 Frencham Street* DOWNER 2602", Suburb: "DOWNER", Lat: -35.245516, Long: 149.145922))
    UnitPlans.append(Building(UPNo: "UP58", Name: "Lyndon Court", Address: "135 Blamey Crescent* CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.290435, Long: 149.153165))
    UnitPlans.append(Building(UPNo: "UP59", Name: "", Address: "25 Mackennal Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.248251, Long: 149.122138))
    UnitPlans.append(Building(UPNo: "UP60", Name: "", Address: "32 Springvale Drive HAWKER 2614", Suburb: "HAWKER", Lat: -35.246652, Long: 149.042864))
    UnitPlans.append(Building(UPNo: "UP61", Name: "", Address: "47 Hampton Circuit YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.311115, Long: 149.109894))
    UnitPlans.append(Building(UPNo: "UP62", Name: "", Address: "35 Lochbuy Street* MACQUARIE 2614", Suburb: "MACQUARIE", Lat: -35.255619, Long: 149.064776))
    UnitPlans.append(Building(UPNo: "UP63", Name: "", Address: "7 Hyndes Crescent HOLDER 2611", Suburb: "HOLDER", Lat: -35.335125, Long: 149.045009))
    UnitPlans.append(Building(UPNo: "UP64", Name: "", Address: "30 Gatton Street FARRER 2607", Suburb: "FARRER", Lat: -35.374475, Long: 149.102494))
    UnitPlans.append(Building(UPNo: "UP65", Name: "Blamey Court", Address: "137 Blamey Crescent CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.290852, Long: 149.15299))
    UnitPlans.append(Building(UPNo: "UP66", Name: "", Address: "6 Lachlan Street*, 75 Redfern Street*, 77 Blackman Crescent*, 8 Lachlan Street*, 2 Lachlan Street*, 4 Lachlan Street*, 75 Blackman Crescent*, 79 Blackman Crescent* MACQUARIE 2614", Suburb: "MACQUARIE", Lat: -35.255085, Long: 149.064085))
    UnitPlans.append(Building(UPNo: "UP67", Name: "", Address: "69 Mockridge Crescent*, 75 Mockridge Crescent*, 71 Mockridge Crescent*, 4 Griffiths Street*, 65 Mockridge Crescent*, 67 Mockridge Crescent*, 6 Griffiths Street*, 73 Mockridge Crescent*, 2 Griffiths Street* HOLT 2615", Suburb: "HOLT", Lat: -35.229899, Long: 149.011505))
    UnitPlans.append(Building(UPNo: "UP68", Name: "", Address: "30 River Street* OAKS ESTATE 2620", Suburb: "OAKS ESTATE", Lat: -35.3395, Long: 149.228392))
    UnitPlans.append(Building(UPNo: "UP69", Name: "", Address: "30 Dickson Place*, 38 Dickson Place*, 34 Dickson Place*, 42 Dickson Place*, 32 Dickson Place*, 36 Dickson Place*, 40 Dickson Place* DICKSON 2602", Suburb: "DICKSON", Lat: -35.250479, Long: 149.139486))
    UnitPlans.append(Building(UPNo: "UP70", Name: "", Address: "108 Bunda Street*, 106 Bunda Street*, 30 Garema Place* CITY 2601", Suburb: "CITY", Lat: -35.278415, Long: 149.132748))
    UnitPlans.append(Building(UPNo: "UP72", Name: "", Address: "22 Discovery Street, 28 Discovery Street RED HILL 2603", Suburb: "RED HILL", Lat: -35.341096, Long: 149.133962))
    UnitPlans.append(Building(UPNo: "UP73", Name: "", Address: "6 Trickett Street*, 2 Trickett Street*, 6A Trickett Street*, 4 Trickett Street* HOLT 2615", Suburb: "HOLT", Lat: -35.229684, Long: 149.01063))
    UnitPlans.append(Building(UPNo: "UP74", Name: "", Address: "2 Araluen Street FISHER 2611", Suburb: "FISHER", Lat: -35.361124, Long: 149.05565))
    UnitPlans.append(Building(UPNo: "UP75", Name: "", Address: "1 Fisher Square* FISHER 2611", Suburb: "FISHER", Lat: -35.361713, Long: 149.056779))
    UnitPlans.append(Building(UPNo: "UP76", Name: "", Address: "26 Torrens Place*, 28 Torrens Place*, 24 Torrens Place*, 32 Torrens Place* TORRENS 2607", Suburb: "TORRENS", Lat: -35.373193, Long: 149.087325))
    UnitPlans.append(Building(UPNo: "UP77", Name: "", Address: "153 Murranji Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.246793, Long: 149.04192))
    UnitPlans.append(Building(UPNo: "UP78", Name: "", Address: "3 Keith Street*, 22 Petre Street* SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.234349, Long: 149.040392))
    UnitPlans.append(Building(UPNo: "UP79", Name: "", Address: "179 Melrose Drive LYONS 2606", Suburb: "LYONS", Lat: -35.34644, Long: 149.082467))
    UnitPlans.append(Building(UPNo: "UP80", Name: "", Address: "33E Marshall Street*, 33A Marshall Street*, 33B Marshall Street*, 33C Marshall Street*, 33D Marshall Street* FARRER 2607", Suburb: "FARRER", Lat: -35.374588, Long: 149.101461))
    UnitPlans.append(Building(UPNo: "UP81", Name: "", Address: "35 Marshall Street FARRER 2607", Suburb: "FARRER", Lat: -35.374787, Long: 149.101385))
    UnitPlans.append(Building(UPNo: "UP82", Name: "", Address: "5 Hyndes Crescent HOLDER 2611", Suburb: "HOLDER", Lat: -35.33555, Long: 149.045482))
    UnitPlans.append(Building(UPNo: "UP83", Name: "", Address: "49 Lambrigg Street* FARRER 2607", Suburb: "FARRER", Lat: -35.37495, Long: 149.100745))
    UnitPlans.append(Building(UPNo: "UP84", Name: "", Address: "32C Marshall Street*, 32E Marshall Street*, 32A Marshall Street*, 32B Marshall Street*, 32D Marshall Street* FARRER 2607", Suburb: "FARRER", Lat: -35.374713, Long: 149.101024))
    UnitPlans.append(Building(UPNo: "UP85", Name: "", Address: "44 Spafford Crescent FARRER 2607", Suburb: "FARRER", Lat: -35.375078, Long: 149.103257))
    UnitPlans.append(Building(UPNo: "UP86", Name: "", Address: "1 Southwell Street*, 9 Southwell Street*, 5 Southwell Street*, 3 Southwell Street*, 7 Southwell Street* WEETANGERA 2614", Suburb: "WEETANGERA", Lat: -35.251823, Long: 149.047668))
    UnitPlans.append(Building(UPNo: "UP87", Name: "Weetangera Gardens", Address: "15 Southwell Street*, 19 Southwell Street*, 27 Southwell Street*, 25 Southwell Street*, 29 Southwell Street*, 17 Southwell Street*, 31 Southwell Street*, 33 Southwell Street*, 23 Southwell Street*, 13 Southwell Street*, 21 Southwell Street*, 11 Southwell Street* WEETANGERA 2614", Suburb: "WEETANGERA", Lat: -35.247446, Long: 149.046249))
    UnitPlans.append(Building(UPNo: "UP88", Name: "", Address: "24 Gillespie Street*, 26 Gillespie Street*, 30 Gillespie Street*, 18 Gillespie Street*, 22 Gillespie Street*, 20 Gillespie Street*, 28 Gillespie Street*, 32 Gillespie Street* WEETANGERA 2614", Suburb: "WEETANGERA", Lat: -35.246423, Long: 149.046888))
    UnitPlans.append(Building(UPNo: "UP89", Name: "", Address: "20 Blamey Crescent, 86 Anzac Park CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.28725, Long: 149.152257))
    UnitPlans.append(Building(UPNo: "UP90", Name: "", Address: "173 Monaro Crescent RED HILL 2603", Suburb: "RED HILL", Lat: -35.341063, Long: 149.132207))
    UnitPlans.append(Building(UPNo: "UP91", Name: "", Address: "27 Coxen Street HUGHES 2605", Suburb: "HUGHES", Lat: -35.335259, Long: 149.092455))
    UnitPlans.append(Building(UPNo: "UP92", Name: "", Address: "89 Allan Street CURTIN 2605", Suburb: "CURTIN", Lat: -35.324814, Long: 149.084442))
    UnitPlans.append(Building(UPNo: "UP93", Name: "", Address: "3 Walsh Place, 5 Walsh Place CURTIN 2605", Suburb: "CURTIN", Lat: -35.324993, Long: 149.085579))
    UnitPlans.append(Building(UPNo: "UP94", Name: "", Address: "12 Walsh Place, 8 Walsh Place, 14 Walsh Place, 16 Walsh Place, 10 Walsh Place CURTIN 2605", Suburb: "CURTIN", Lat: -35.325389, Long: 149.08541))
    UnitPlans.append(Building(UPNo: "UP95", Name: "", Address: "2 Walsh Place, 4 Walsh Place, 6 Walsh Place CURTIN 2605", Suburb: "CURTIN", Lat: -35.324994, Long: 149.084479))
    UnitPlans.append(Building(UPNo: "UP97", Name: "", Address: "4 Clianthus Street, 18 Correa Street, 10 Correa Street, 16 Correa Street, 14 Correa Street, 49 Brigalow Street, 8 Correa Street, 39 Brigalow Street, 47 Brigalow Street, 43 Brigalow Street, 2 Clianthus Street, 12 Correa Street, 45 Brigalow Street, 41 Brigalow Street O'CONNOR 2602", Suburb: "O'CONNOR", Lat: -35.251783, Long: 149.122309))
    UnitPlans.append(Building(UPNo: "UP98", Name: "", Address: "30 Lyell Street*, 145 Newcastle Street*, Newcastle Street*, 147 Newcastle Street, 143 Newcastle Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.328389, Long: 149.178705))
    UnitPlans.append(Building(UPNo: "UP99", Name: "", Address: "30 Springvale Drive HAWKER 2614", Suburb: "HAWKER", Lat: -35.246371, Long: 149.043508))
    UnitPlans.append(Building(UPNo: "UP100", Name: "", Address: "3 Waddell Place CURTIN 2605", Suburb: "CURTIN", Lat: -35.325295, Long: 149.080604))
    UnitPlans.append(Building(UPNo: "UP101", Name: "", Address: "25 Mcginness Street, 124 Ross Smith Crescent, 2 Keith Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.232849, Long: 149.0423))
    UnitPlans.append(Building(UPNo: "UP102", Name: "", Address: "3 Bonrook Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.245099, Long: 149.042438))
    UnitPlans.append(Building(UPNo: "UP103", Name: "", Address: "26 Springvale Drive HAWKER 2614", Suburb: "HAWKER", Lat: -35.245664, Long: 149.043694))
    UnitPlans.append(Building(UPNo: "UP104", Name: "", Address: "110 Davenport Street DICKSON 2602", Suburb: "DICKSON", Lat: -35.251817, Long: 149.140329))
    UnitPlans.append(Building(UPNo: "UP105", Name: "Wirreanda", Address: "78 Hodgson Crescent PEARCE 2607", Suburb: "PEARCE", Lat: -35.363611, Long: 149.081484))
    UnitPlans.append(Building(UPNo: "UP106", Name: "", Address: "4 Beetaloo Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.245746, Long: 149.040931))
    UnitPlans.append(Building(UPNo: "UP107", Name: "", Address: "6 Maclaurin Crescent CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.350901, Long: 149.084062))
    UnitPlans.append(Building(UPNo: "UP108", Name: "99 Canberra Avenue Griffith", Address: "99 Canberra Avenue GRIFFITH 2603", Suburb: "GRIFFITH", Lat: -35.32138, Long: 149.144174))
    UnitPlans.append(Building(UPNo: "UP109", Name: "", Address: "7 Medley Street CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.353407, Long: 149.084582))
    UnitPlans.append(Building(UPNo: "UP110", Name: "Fullagar Crs & Pennefather St - Higgins", Address: "35 Fullagar Crescent*, 43 Fullagar Crescent*, 41 Fullagar Crescent*, 37 Fullagar Crescent*, 39 Fullagar Crescent*, 45 Fullagar Crescent*, 144 Pennefather Street* HIGGINS 2615", Suburb: "HIGGINS", Lat: -35.230194, Long: 149.028126))
    UnitPlans.append(Building(UPNo: "UP111", Name: "", Address: "53 Fullagar Crescent*, 123 Pennefather Street*, 17 Cantor Crescent*, 127 Pennefather Street*, 19 Cantor Crescent*, 47 Fullagar Crescent*, 21 Cantor Crescent*, 121 Pennefather Street*, 125 Pennefather Street*, 49 Fullagar Crescent*, 51 Fullagar Crescent* HIGGINS 2615", Suburb: "HIGGINS", Lat: -35.230527, Long: 149.022997))
    UnitPlans.append(Building(UPNo: "UP112", Name: "", Address: "80 Newcastle Street*, 82 Newcastle Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.328389, Long: 149.178705))
    UnitPlans.append(Building(UPNo: "UP113", Name: "", Address: "34 Geelong Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.33081, Long: 149.171623))
    UnitPlans.append(Building(UPNo: "UP114", Name: "", Address: "108 Davenport Street DICKSON 2602", Suburb: "DICKSON", Lat: -35.251929, Long: 149.140629))
    UnitPlans.append(Building(UPNo: "UP115", Name: "", Address: "120 Lambrigg Street FARRER 2607", Suburb: "FARRER", Lat: -35.379257, Long: 149.108237))
    UnitPlans.append(Building(UPNo: "UP116", Name: "Wybalena Grove", Address: "50 Wybalena Grove COOK 2614", Suburb: "COOK", Lat: -35.262272, Long: 149.071769))
    UnitPlans.append(Building(UPNo: "UP117", Name: "4 Keith Street Scullin", Address: "4 Keith Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.233974, Long: 149.041835))
    UnitPlans.append(Building(UPNo: "UP118", Name: "", Address: "112 Macfarland Crescent PEARCE 2607", Suburb: "PEARCE", Lat: -35.363117, Long: 149.080903))
    UnitPlans.append(Building(UPNo: "UP119", Name: "", Address: "81 Crozier Circuit*, 79 Crozier Circuit*, 85 Crozier Circuit*, 87 Crozier Circuit*, 83 Crozier Circuit* KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.389257, Long: 149.043617))
    UnitPlans.append(Building(UPNo: "UP120", Name: "Clayton Court", Address: "3 Carroll Street*, 7 Coxen Street*, 1 Carroll Street* HUGHES 2605", Suburb: "HUGHES", Lat: -35.333042, Long: 149.09073))
    UnitPlans.append(Building(UPNo: "UP121", Name: "", Address: "21 Boult Place*, 33 Boult Place*, 19 Boult Place*, 17 Boult Place*, 35 Boult Place*, 25 Boult Place*, 29 Boult Place*, 23 Boult Place*, 31 Boult Place*, 27 Boult Place* MELBA 2615", Suburb: "MELBA", Lat: -35.20928, Long: 149.048542))
    UnitPlans.append(Building(UPNo: "UP122", Name: "Brindabella Gardens", Address: "11 Mather Street*, 6 Conder Street*, 8 Conder Street*, 12 Conder Street*, 20 Conder Street*, 18 Conder Street*, 1 Mather Street*, 4 Conder Street*, 14 Conder Street*, 16 Conder Street*, 2 Conder Street*, 10 Conder Street*, 15 Mather Street*, 3 Mather Street*, 7 Mather Street*, 5 Mather Street*, 9 Mather Street*, 13 Mather Street* WESTON 2611", Suburb: "WESTON", Lat: -35.340898, Long: 149.057627))
    UnitPlans.append(Building(UPNo: "UP123", Name: "", Address: "15 Dundas Court* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.353596, Long: 149.089308))
    UnitPlans.append(Building(UPNo: "UP124", Name: "", Address: "9 Devonport Street, 3 Port Arthur Street LYONS 2606", Suburb: "LYONS", Lat: -35.339847, Long: 149.076412))
    UnitPlans.append(Building(UPNo: "UP125", Name: "Parkview Court", Address: "7 Devonport Street LYONS 2606", Suburb: "LYONS", Lat: -35.339983, Long: 149.076261))
    UnitPlans.append(Building(UPNo: "UP126", Name: "", Address: "4 Geelong Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.332487, Long: 149.167536))
    UnitPlans.append(Building(UPNo: "UP127", Name: "", Address: "156 Monaro Crescent RED HILL 2603", Suburb: "RED HILL", Lat: -35.34028, Long: 149.131287))
    UnitPlans.append(Building(UPNo: "UP128", Name: "", Address: "48 Gillespie Street*, 42 Gillespie Street*, 44 Gillespie Street*, 40 Gillespie Street*, 34 Gillespie Street*, 46 Gillespie Street*, 50 Gillespie Street*, 36 Gillespie Street*, 38 Gillespie Street* WEETANGERA 2614", Suburb: "WEETANGERA", Lat: -35.247705, Long: 149.046646))
    UnitPlans.append(Building(UPNo: "UP129", Name: "", Address: "2 Teague Street*, 10 Teague Street*, 16 Teague Street*, 22 Teague Street*, 160 Dexter Street*, 166 Dexter Street*, 156 Dexter Street*, 14 Teague Street*, 4 Teague Street*, 6 Teague Street*, 162 Dexter Street*, 24 Teague Street*, 158 Dexter Street*, 8 Teague Street*, 168 Dexter Street*, 12 Teague Street*, 164 Dexter Street*, 18 Teague Street*, 20 Teague Street*, 154 Dexter Street* COOK 2614", Suburb: "COOK", Lat: -35.255245, Long: 149.071349))
    UnitPlans.append(Building(UPNo: "UP130", Name: "", Address: "9 Tristania Street RIVETT 2611", Suburb: "RIVETT", Lat: -35.343559, Long: 149.046854))
    UnitPlans.append(Building(UPNo: "UP131", Name: "", Address: "3G Tristania Street*, 3L Tristania Street*, 3F Tristania Street*, 1C Tristania Street*, 3M Tristania Street*, 3C Tristania Street*, 1A Tristania Street*, 1D Tristania Street*, 3B Tristania Street*, 3D Tristania Street*, 3E Tristania Street*, 3H Tristania Street*, 3K Tristania Street*, 3 Carbeen Street*, 1B Tristania Street*, 3A Tristania Street*, 3J Tristania Street*, 1 Carbeen Street* RIVETT 2611", Suburb: "RIVETT", Lat: -35.341934, Long: 149.045892))
    UnitPlans.append(Building(UPNo: "UP132", Name: "", Address: "45 Catchpole Street*, 47 Catchpole Street*, 41 Catchpole Street*, 43 Catchpole Street*, 39 Catchpole Street* MACQUARIE 2614", Suburb: "MACQUARIE", Lat: -35.251274, Long: 149.069242))
    UnitPlans.append(Building(UPNo: "UP133", Name: "", Address: "18 Whyalla Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.333008, Long: 149.176598))
    UnitPlans.append(Building(UPNo: "UP135", Name: "", Address: "7 Mcgee Place PEARCE 2607", Suburb: "PEARCE", Lat: -35.36416, Long: 149.081024))
    UnitPlans.append(Building(UPNo: "UP137", Name: "", Address: "20 Kembla Street*, 22 Kembla Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.324622, Long: 149.17707))
    UnitPlans.append(Building(UPNo: "UP138", Name: "", Address: "106 Maryborough Street*, 8 Gladstone Street*, 67 Kembla Street*, 73 Kembla Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.323309, Long: 149.17382))
    UnitPlans.append(Building(UPNo: "UP139", Name: "", Address: "Gwydir Square*, 4 Gwydir Square*, 6 Gwydir Square* KALEEN 2617", Suburb: "KALEEN", Lat: -35.234098, Long: 149.102939))
    UnitPlans.append(Building(UPNo: "UP140", Name: "", Address: "22 Dundas Court PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.353975, Long: 149.087722))
    UnitPlans.append(Building(UPNo: "UP141", Name: "", Address: "43 Anderson Street CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.350053, Long: 149.083823))
    UnitPlans.append(Building(UPNo: "UP147", Name: "", Address: "2 Primmer Court* KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.38018, Long: 149.05727))
    UnitPlans.append(Building(UPNo: "UP148", Name: "", Address: "13 Boult Place*, 15 Boult Place*, 11 Boult Place*, 3 Boult Place*, 9 Boult Place*, 1 Boult Place*, 5 Boult Place*, 7 Boult Place* MELBA 2615", Suburb: "MELBA", Lat: -35.209365, Long: 149.048853))
    UnitPlans.append(Building(UPNo: "UP149", Name: "", Address: "106 Gladstone Street*, 108 Gladstone Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.323481, Long: 149.181296))
    UnitPlans.append(Building(UPNo: "UP150", Name: "", Address: "5 Tristania Street RIVETT 2611", Suburb: "RIVETT", Lat: -35.342036, Long: 149.047321))
    UnitPlans.append(Building(UPNo: "UP151", Name: "", Address: "4 Hodgson Place PEARCE 2607", Suburb: "PEARCE", Lat: -35.364255, Long: 149.082881))
    UnitPlans.append(Building(UPNo: "UP152", Name: "", Address: "18 Kembla Street*, 14 Kembla Street*, 16 Kembla Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.324622, Long: 149.17707))
    UnitPlans.append(Building(UPNo: "UP153", Name: "Fitzroy Gardens", Address: "104 Dexter Street*, 110 Dexter Street*, 90 Dexter Street*, 80 Dexter Street*, 102 Dexter Street*, 112 Dexter Street*, 82 Dexter Street*, 84 Dexter Street*, 106 Dexter Street*, 78 Dexter Street*, 96 Dexter Street*, 114 Dexter Street*, 88 Dexter Street*, 76 Dexter Street*, 94 Dexter Street*, 108 Dexter Street*, 86 Dexter Street*, 98 Dexter Street*, 100 Dexter Street*, 92 Dexter Street* COOK 2614", Suburb: "COOK", Lat: -35.258409, Long: 149.070165))
    UnitPlans.append(Building(UPNo: "UP154", Name: "The Hermitage", Address: "17 Medley Street, Medley Street CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.354705, Long: 149.085106))
    UnitPlans.append(Building(UPNo: "UP155", Name: "", Address: "44 Boult Place*, 36 Boult Place*, 38 Boult Place*, 42 Boult Place*, 40 Boult Place* MELBA 2615", Suburb: "MELBA", Lat: -35.208796, Long: 149.048645))
    UnitPlans.append(Building(UPNo: "UP156", Name: "", Address: "48 Dexter Street*, 34 Dexter Street*, 40 Dexter Street*, 30 Dexter Street*, 32 Dexter Street*, 44 Dexter Street*, 42 Dexter Street*, 26 Dexter Street*, 38 Dexter Street*, 36 Dexter Street*, 46 Dexter Street*, 28 Dexter Street* COOK 2614", Suburb: "COOK", Lat: -35.257033, Long: 149.068522))
    UnitPlans.append(Building(UPNo: "UP157", Name: "Caranda Park", Address: "28 Bourne Street, 42 Bourne Street, 15 Dugdale Street, 17 Dugdale Street, 27 Dugdale Street, 3 Dugdale Street, 5 Dugdale Street, 9 Dugdale Street, 52 Bourne Street, 36 Bourne Street, 11 Dugdale Street, 26 Bourne Street, 44 Bourne Street, 6 Bourne Street, 13 Dugdale Street, 7 Dugdale Street, 22 Bourne Street, 30 Bourne Street, 38 Bourne Street, 40 Bourne Street, 10 Bourne Street, 1 Dugdale Street, 12 Bourne Street, 25 Dugdale Street, 21 Dugdale Street, 54 Bourne Street, 14 Bourne Street, 24 Bourne Street, 50 Bourne Street, 16 Bourne Street, 32 Bourne Street, 46 Bourne Street, 8 Bourne Street, 19 Dugdale Street, 23 Dugdale Street, 20 Bourne Street, 34 Bourne Street, 48 Bourne Street, 18 Bourne Street COOK 2614", Suburb: "COOK", Lat: -35.259823, Long: 149.071168))
    UnitPlans.append(Building(UPNo: "UP158", Name: "", Address: "39 Fitchett Street GARRAN 2605", Suburb: "GARRAN", Lat: -35.341427, Long: 149.095616))
    UnitPlans.append(Building(UPNo: "UP159", Name: "", Address: "5 Teague Street*, 176 Dexter Street*, 3 Teague Street*, 178 Dexter Street*, 1 Teague Street* COOK 2614", Suburb: "COOK", Lat: -35.25486, Long: 149.072394))
    UnitPlans.append(Building(UPNo: "UP160", Name: "", Address: "48 Boult Place*, 54 Boult Place*, 52 Boult Place*, 46 Boult Place*, 50 Boult Place* MELBA 2615", Suburb: "MELBA", Lat: -35.20891, Long: 149.048955))
    UnitPlans.append(Building(UPNo: "UP161", Name: "Dexter/Teague Street Cook", Address: "44 Teague Street*, 144 Dexter Street*, 42 Teague Street*, 32 Teague Street*, 36 Teague Street*, 140 Dexter Street*, 28 Teague Street*, 38 Teague Street*, 138 Dexter Street*, 34 Teague Street*, 142 Dexter Street*, 30 Teague Street*, 40 Teague Street* COOK 2614", Suburb: "COOK", Lat: -35.256359, Long: 149.071858))
    UnitPlans.append(Building(UPNo: "UP162", Name: "", Address: "5 Fitchett Street GARRAN 2605", Suburb: "GARRAN", Lat: -35.343195, Long: 149.098727))
    UnitPlans.append(Building(UPNo: "UP163", Name: "", Address: "51 Dugdale Street*, 63 Dugdale Street*, 67 Dugdale Street*, 45 Dugdale Street*, 49 Dugdale Street*, 53 Dugdale Street*, 47 Dugdale Street*, 41 Dugdale Street*, 61 Dugdale Street*, 43 Dugdale Street*, 69 Dugdale Street*, 55 Dugdale Street*, 57 Dugdale Street*, 59 Dugdale Street*, 65 Dugdale Street* COOK 2614", Suburb: "COOK", Lat: -35.258065, Long: 149.071685))
    UnitPlans.append(Building(UPNo: "UP164", Name: "Chelsea Grove", Address: "48 Charteris Crescent CHIFLEY 2606", Suburb: "CHIFLEY", Lat: -35.352313, Long: 149.084496))
    UnitPlans.append(Building(UPNo: "UP165", Name: "", Address: "61 Mcnamara Street*, 47 Mcnamara Street*, 25 Mcnamara Street*, 65 Mcnamara Street*, 45 Mcnamara Street*, 67 Mcnamara Street*, 55 Mcnamara Street*, 39 Mcnamara Street*, 49 Mcnamara Street*, 27 Mcnamara Street*, 29 Mcnamara Street*, 31 Mcnamara Street*, 59 Mcnamara Street*, 37 Mcnamara Street*, 41 Mcnamara Street*, 51 Mcnamara Street*, 33 Mcnamara Street*, 35 Mcnamara Street*, 57 Mcnamara Street*, 21 Mcnamara Street*, 23 Mcnamara Street*, 53 Mcnamara Street*, 63 Mcnamara Street*, 43 Mcnamara Street* PEARCE 2607", Suburb: "PEARCE", Lat: -35.356335, Long: 149.086039))
    UnitPlans.append(Building(UPNo: "UP166", Name: "", Address: "5 Neworra Place*, 17 Neworra Place*, 53 Canopus Crescent*, 57 Canopus Crescent*, 65 Canopus Crescent*, 7 Neworra Place*, 13 Neworra Place*, 1 Neworra Place*, 55 Canopus Crescent*, 61 Canopus Crescent*, 9 Neworra Place*, 51 Canopus Crescent*, 63 Canopus Crescent*, 73 Canopus Crescent*, 67 Canopus Crescent*, 69 Canopus Crescent*, 23 Neworra Place*, 3 Neworra Place*, 19 Neworra Place*, 21 Neworra Place*, 59 Canopus Crescent*, 11 Neworra Place*, 15 Neworra Place*, 75 Canopus Crescent*, 71 Canopus Crescent* GIRALANG 2617", Suburb: "GIRALANG", Lat: -35.212294, Long: 149.096144))
    UnitPlans.append(Building(UPNo: "UP167", Name: "", Address: "129 Gladstone Street*, 131 Gladstone Street* FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.323006, Long: 149.182858))
    UnitPlans.append(Building(UPNo: "UP168", Name: "", Address: "5 Howitt Street, 45 Eyre Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.318265, Long: 149.145338))
    UnitPlans.append(Building(UPNo: "UP169", Name: "", Address: "20 Mcelhone Court*, 4 Mcelhone Court*, 8 Mcelhone Court*, 14 Mcelhone Court*, 16 Mcelhone Court*, 18 Mcelhone Court*, 6 Mcelhone Court*, 2 Mcelhone Court*, 10 Mcelhone Court*, 12 Mcelhone Court* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.243764, Long: 149.068334))
    UnitPlans.append(Building(UPNo: "UP170", Name: "", Address: "2 Hodgson Place PEARCE 2607", Suburb: "PEARCE", Lat: -35.364719, Long: 149.082197))
    UnitPlans.append(Building(UPNo: "UP171", Name: "", Address: "3 Mcelhone Court*, 1 Mcelhone Court*, 21 Mcelhone Court*, 7 Mcelhone Court*, 9 Mcelhone Court*, 15 Mcelhone Court*, 11 Mcelhone Court*, 13 Mcelhone Court*, 19 Mcelhone Court*, 5 Mcelhone Court*, 17 Mcelhone Court* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.243915, Long: 149.068962))
    UnitPlans.append(Building(UPNo: "UP172", Name: "Cabena Court", Address: "16 Cabena Court*, 4 Cabena Court*, 2 Cabena Court*, 6 Cabena Court*, 8 Cabena Court*, 10 Cabena Court*, 12 Cabena Court*, 14 Cabena Court* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.244499, Long: 149.068649))
    UnitPlans.append(Building(UPNo: "UP173", Name: "Kailine Court", Address: "6 Dexter Street, 10 Dexter Street, 16 Dexter Street, 2 Dexter Street, 12 Dexter Street, 24 Dexter Street, 4 Dexter Street, 14 Dexter Street, 8 Dexter Street, 20 Dexter Street, 22 Dexter Street, 18 Dexter Street COOK 2614", Suburb: "COOK", Lat: -35.256397, Long: 149.068287))
    UnitPlans.append(Building(UPNo: "UP174", Name: "88-100 Bourne Street Cook", Address: "92 Bourne Street*, 96 Bourne Street*, 100 Bourne Street*, 88 Bourne Street*, 90 Bourne Street*, 94 Bourne Street*, 98 Bourne Street* COOK 2614", Suburb: "COOK", Lat: -35.258529, Long: 149.070912))
    UnitPlans.append(Building(UPNo: "UP175", Name: "", Address: "14 Marr Street*, 1 Biddlecombe Street* PEARCE 2607", Suburb: "PEARCE", Lat: -35.359327, Long: 149.087099))
    UnitPlans.append(Building(UPNo: "UP176", Name: "", Address: "22 Mcelhone Court*, 26 Mcelhone Court*, 28 Mcelhone Court*, 30 Mcelhone Court*, 38 Mcelhone Court*, 32 Mcelhone Court*, 40 Mcelhone Court*, 24 Mcelhone Court*, 34 Mcelhone Court*, 36 Mcelhone Court* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.243866, Long: 149.068299))
    UnitPlans.append(Building(UPNo: "UP177", Name: "Giralang Parklands", Address: "35 Kootingal Street*, 37 Kootingal Street*, 4 Warring Place*, 10 Warring Place*, 43 Kootingal Street*, 47 Kootingal Street*, 8 Warring Place*, 22 Warring Place*, 24 Warring Place*, 39 Kootingal Street*, 28 Warring Place*, 45 Kootingal Street*, 49 Kootingal Street*, 12 Warring Place*, 14 Warring Place*, 16 Warring Place*, 20 Warring Place*, 41 Kootingal Street*, 18 Warring Place*, 26 Warring Place*, 30 Warring Place*, 53 Kootingal Street*, 51 Kootingal Street*, 2 Warring Place*, 32 Warring Place*, 6 Warring Place* GIRALANG 2617", Suburb: "GIRALANG", Lat: -35.213439, Long: 149.097016))
    UnitPlans.append(Building(UPNo: "UP178", Name: "", Address: "110 Batchelor Street*, 104 Batchelor Street*, 108 Batchelor Street*, 112 Batchelor Street*, 106 Batchelor Street* TORRENS 2607", Suburb: "TORRENS", Lat: -35.372155, Long: 149.086993))
    UnitPlans.append(Building(UPNo: "UP179", Name: "", Address: "1 Sexton Street COOK 2614", Suburb: "COOK", Lat: -35.256319, Long: 149.068881))
    UnitPlans.append(Building(UPNo: "UP180", Name: "", Address: "5 Watling Place WESTON 2611", Suburb: "WESTON", Lat: -35.343065, Long: 149.053671))
    UnitPlans.append(Building(UPNo: "UP181", Name: "", Address: "8 Jalanga Crescent ARANDA 2614", Suburb: "ARANDA", Lat: -35.256689, Long: 149.07876))
    UnitPlans.append(Building(UPNo: "UP182", Name: "", Address: "7 Watling Place WESTON 2611", Suburb: "WESTON", Lat: -35.343555, Long: 149.053484))
    UnitPlans.append(Building(UPNo: "UP183", Name: "118-134 Dexter Street Cook", Address: "134 Dexter Street*, 122 Dexter Street*, 118 Dexter Street*, 124 Dexter Street*, 128 Dexter Street*, 126 Dexter Street*, 120 Dexter Street*, 132 Dexter Street*, 130 Dexter Street* COOK 2614", Suburb: "COOK", Lat: -35.257242, Long: 149.071491))
    UnitPlans.append(Building(UPNo: "UP184", Name: "", Address: "40 Marr Street*, 43 Pethebridge Street*, 41 Pethebridge Street* PEARCE 2607", Suburb: "PEARCE", Lat: -35.359427, Long: 149.089109))
    UnitPlans.append(Building(UPNo: "UP185", Name: "Timbarra", Address: "74 Dexter Street*, 52 Dexter Street*, 68 Dexter Street*, 70 Dexter Street*, 58 Dexter Street*, 62 Dexter Street*, 66 Dexter Street*, 54 Dexter Street*, 56 Dexter Street*, 50 Dexter Street*, 60 Dexter Street*, 64 Dexter Street*, 72 Dexter Street* COOK 2614", Suburb: "COOK", Lat: -35.257699, Long: 149.068893))
    UnitPlans.append(Building(UPNo: "UP187", Name: "", Address: "17 Mather Street WESTON 2611", Suburb: "WESTON", Lat: -35.340188, Long: 149.057419))
    UnitPlans.append(Building(UPNo: "UP188", Name: "", Address: "18 Currie Crescent KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.314673, Long: 149.139108))
    UnitPlans.append(Building(UPNo: "UP189", Name: "", Address: "70 Bourne Street COOK 2614", Suburb: "COOK", Lat: -35.259236, Long: 149.06948))
    UnitPlans.append(Building(UPNo: "UP190", Name: "", Address: "2A Farrer Place, 2D Farrer Place, 2C Farrer Place, 2 Farrer Place, 2B Farrer Place FARRER 2607", Suburb: "FARRER", Lat: -35.375023, Long: 149.101421))
    UnitPlans.append(Building(UPNo: "UP191", Name: "Aspen Ridge", Address: "44 Blackham Street, 16 Blandon Place, 33 Goddard Crescent, 14 Blandon Place, 31 Goddard Crescent, 32 Blackham Street, 38 Blackham Street, 42 Blackham Street, 19 Goddard Crescent, 25 Goddard Crescent, 34 Blackham Street, 4 Blandon Place, 6 Blandon Place, 15 Goddard Crescent, 29 Goddard Crescent, 26 Blackham Street, 28 Blackham Street, 21 Goddard Crescent, 27 Goddard Crescent, 30 Blackham Street, 36 Blackham Street, 40 Blackham Street, 17 Goddard Crescent, 23 Goddard Crescent HOLT 2615", Suburb: "HOLT", Lat: -35.223102, Long: 149.027697))
    UnitPlans.append(Building(UPNo: "UP192", Name: "", Address: "27 Mackennal Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.247819, Long: 149.12238))
    UnitPlans.append(Building(UPNo: "UP193", Name: "", Address: "90 Giles Street, 5 Howitt Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.315968, Long: 149.14027))
    UnitPlans.append(Building(UPNo: "UP194", Name: "", Address: "28 Springvale Drive HAWKER 2614", Suburb: "HAWKER", Lat: -35.246017, Long: 149.04356))
    UnitPlans.append(Building(UPNo: "UP195", Name: "", Address: "271 Antill Street*, 157 Knox Street* WATSON 2602", Suburb: "WATSON", Lat: -35.232997, Long: 149.16569))
    UnitPlans.append(Building(UPNo: "UP196", Name: "", Address: "12 Martin Street CURTIN 2605", Suburb: "CURTIN", Lat: -35.32644, Long: 149.084871))
    UnitPlans.append(Building(UPNo: "UP197", Name: "Blackwood Terrace - Holder", Address: "90 Blackwood Terrace HOLDER 2611", Suburb: "HOLDER", Lat: -35.334592, Long: 149.048637))
    UnitPlans.append(Building(UPNo: "UP198", Name: "", Address: "55 Townsville Street, 53 Townsville Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.330345, Long: 149.183712))
    UnitPlans.append(Building(UPNo: "UP199", Name: "Willemsen Close", Address: "18 Marr Street*, 21 Pethebridge Street*, 25 Pethebridge Street*, 21 Biddlecombe Street*, 28 Marr Street*, 29 Pethebridge Street*, 33 Pethebridge Street*, 27 Pethebridge Street*, 26 Marr Street*, 35 Pethebridge Street*, 23 Pethebridge Street*, 30 Marr Street* PEARCE 2607", Suburb: "PEARCE", Lat: -35.361157, Long: 149.086298))
    UnitPlans.append(Building(UPNo: "UP200", Name: "", Address: "1 Cantor Crescent HIGGINS 2615", Suburb: "HIGGINS", Lat: -35.232993, Long: 149.027625))
    UnitPlans.append(Building(UPNo: "UP201", Name: "", Address: "14 Darling Street, 11 Bourke Street BARTON 2600", Suburb: "BARTON", Lat: -35.310203, Long: 149.132279))
    UnitPlans.append(Building(UPNo: "UP202", Name: "Argyle Square Stage 1", Address: "11 Doonkuna Street, 3 Allambee Street REID 2612", Suburb: "REID", Lat: -35.279979, Long: 149.139359))
    UnitPlans.append(Building(UPNo: "UP203", Name: "", Address: "196 Gladstone Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.329934, Long: 149.184565))
    UnitPlans.append(Building(UPNo: "UP204", Name: "", Address: "200 Gladstone Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.330355, Long: 149.184268))
    UnitPlans.append(Building(UPNo: "UP205", Name: "", Address: "49 Townsville Street, 51 Townsville Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.329988, Long: 149.183659))
    UnitPlans.append(Building(UPNo: "UP206", Name: "", Address: "143 Carruthers Street, 145 Carruthers Street, 1 Mcculloch Street, 141 Carruthers Street CURTIN 2605", Suburb: "CURTIN", Lat: -35.323975, Long: 149.08134))
    UnitPlans.append(Building(UPNo: "UP207", Name: "", Address: "3 Sexton Street COOK 2614", Suburb: "COOK", Lat: -35.255951, Long: 149.070637))
    UnitPlans.append(Building(UPNo: "UP208", Name: "", Address: "53 Elimatta Street BRADDON 2612", Suburb: "BRADDON", Lat: -35.277378, Long: 149.139496))
    UnitPlans.append(Building(UPNo: "UP209", Name: "", Address: "41 Gardiner Street DOWNER 2602", Suburb: "DOWNER", Lat: -35.245097, Long: 149.146669))
    UnitPlans.append(Building(UPNo: "UP210", Name: "", Address: "114 Blamey Crescent* CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.289922, Long: 149.152461))
    UnitPlans.append(Building(UPNo: "UP211", Name: "", Address: "116 Blamey Crescent CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.29026, Long: 149.152281))
    UnitPlans.append(Building(UPNo: "UP212", Name: "", Address: "14 Currie Crescent KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.315374, Long: 149.139499))
    UnitPlans.append(Building(UPNo: "UP213", Name: "", Address: "1 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.363037, Long: 149.097737))
    UnitPlans.append(Building(UPNo: "UP214", Name: "", Address: "12 Currie Crescent KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.316051, Long: 149.139166))
    UnitPlans.append(Building(UPNo: "UP215", Name: "Woodland Park", Address: "7 Goddard Crescent*, 9 Goddard Crescent*, 9 Paterick Place*, 22 Blackham Street*, 14 Blackham Street*, 18 Blackham Street*, 3 Goddard Crescent*, 5 Goddard Crescent*, 20 Blackham Street*, 11 Goddard Crescent*, 3 Paterick Place*, 7 Paterick Place*, 16 Blackham Street*, 1 Goddard Crescent*, 1 Paterick Place*, 5 Paterick Place*, 12 Blackham Street* HOLT 2615", Suburb: "HOLT", Lat: -35.223419, Long: 149.028534))
    UnitPlans.append(Building(UPNo: "UP216", Name: "", Address: "40 Jewell Close*, 34 Jewell Close*, 38 Jewell Close*, 33 Sulman Place*, 26 Jewell Close*, 32 Jewell Close*, 31 Sulman Place*, 28 Jewell Close*, 35 Sulman Place*, 30 Jewell Close*, 36 Jewell Close* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.352201, Long: 149.095312))
    UnitPlans.append(Building(UPNo: "UP217", Name: "", Address: "1 Evergood Close WESTON 2611", Suburb: "WESTON", Lat: -35.34397, Long: 149.056339))
    UnitPlans.append(Building(UPNo: "UP218", Name: "", Address: "1 Cabarita Terrace*, 3 Cabarita Terrace* O'MALLEY 2606", Suburb: "O'MALLEY", Lat: -35.350136, Long: 149.110731))
    UnitPlans.append(Building(UPNo: "UP219", Name: "Somerset Park", Address: "8 Walhallow Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.243689, Long: 149.041011))
    UnitPlans.append(Building(UPNo: "UP220", Name: "", Address: "52A Forbes Street, Forbes Street TURNER 2612", Suburb: "TURNER", Lat: -35.263251, Long: 149.130467))
    UnitPlans.append(Building(UPNo: "UP221", Name: "Argyle Square Stage 2", Address: "1 Allambee Street REID 2612", Suburb: "REID", Lat: -35.278985, Long: 149.137611))
    UnitPlans.append(Building(UPNo: "UP222", Name: "The Crescent", Address: "2 Sexton Street COOK 2614", Suburb: "COOK", Lat: -35.257364, Long: 149.07))
    UnitPlans.append(Building(UPNo: "UP223", Name: "43 Gardiner Street", Address: "43 Gardiner Street DOWNER 2602", Suburb: "DOWNER", Lat: -35.244921, Long: 149.146584))
    UnitPlans.append(Building(UPNo: "UP224", Name: "", Address: "27 Catchpole Street*, 29 Catchpole Street*, 35 Catchpole Street*, 33 Catchpole Street*, 37 Catchpole Street*, 31 Catchpole Street* MACQUARIE 2614", Suburb: "MACQUARIE", Lat: -35.251274, Long: 149.069242))
    UnitPlans.append(Building(UPNo: "UP225", Name: "", Address: "2 Postle Circuit HOLT 2615", Suburb: "HOLT", Lat: -35.221289, Long: 149.022101))
    UnitPlans.append(Building(UPNo: "UP226", Name: "", Address: "41 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.24214, Long: 149.041456))
    UnitPlans.append(Building(UPNo: "UP227", Name: "", Address: "22 English Court*, 38 English Court*, 36 English Court*, 26 English Court*, 28 English Court*, 32 English Court*, 24 English Court*, 40 English Court*, 42 English Court*, 34 English Court*, 30 English Court* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.353454, Long: 149.098212))
    UnitPlans.append(Building(UPNo: "UP228", Name: "Alpine Grove", Address: "26 Eungella Street* DUFFY 2611", Suburb: "DUFFY", Lat: -35.339377, Long: 149.031725))
    UnitPlans.append(Building(UPNo: "UP229", Name: "", Address: "47 Foxall Street* HOLDER 2611", Suburb: "HOLDER", Lat: -35.337253, Long: 149.051116))
    UnitPlans.append(Building(UPNo: "UP230", Name: "", Address: "63 Melba Street DOWNER 2602", Suburb: "DOWNER", Lat: -35.242953, Long: 149.142905))
    UnitPlans.append(Building(UPNo: "UP231", Name: "", Address: "2-6 Avoca Place FISHER 2611", Suburb: "FISHER", Lat: -35.360901, Long: 149.05603))
    UnitPlans.append(Building(UPNo: "UP232", Name: "", Address: "16 Woolls Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.309878, Long: 149.092685))
    UnitPlans.append(Building(UPNo: "UP233", Name: "", Address: "87 Barnet Close*, 89 Barnet Close*, 93 Barnet Close*, 67 Barnet Close*, 83 Barnet Close*, 101 Barnet Close*, 71 Barnet Close*, 99 Barnet Close*, 73 Barnet Close*, 95 Barnet Close*, 107 Barnet Close*, 75 Barnet Close*, 85 Barnet Close*, 91 Barnet Close*, 105 Barnet Close*, 69 Barnet Close*, 81 Barnet Close* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.352247, Long: 149.097447))
    UnitPlans.append(Building(UPNo: "UP234", Name: "", Address: "31 Foxall Street HOLDER 2611", Suburb: "HOLDER", Lat: -35.336383, Long: 149.050564))
    UnitPlans.append(Building(UPNo: "UP235", Name: "", Address: "6 Heard Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.366314, Long: 149.096463))
    UnitPlans.append(Building(UPNo: "UP236", Name: "", Address: "10 Jinka Street*, 14 Jinka Street*, 26 Jinka Street*, 12 Jinka Street*, 36 Jinka Street*, 24 Jinka Street*, 32 Jinka Street*, 16 Jinka Street*, 20 Jinka Street*, 30 Jinka Street*, 18 Jinka Street*, 22 Jinka Street*, 28 Jinka Street*, 34 Jinka Street* HAWKER 2614", Suburb: "HAWKER", Lat: -35.242159, Long: 149.039784))
    UnitPlans.append(Building(UPNo: "UP237", Name: "", Address: "63 Pearson Street HOLDER 2611", Suburb: "HOLDER", Lat: -35.340939, Long: 149.047853))
    UnitPlans.append(Building(UPNo: "UP238", Name: "", Address: "5 English Court*, 14 The Verge*, 17 English Court*, 3 English Court*, 8 The Verge*, 15 English Court*, 11 English Court*, 6 The Verge*, 10 The Verge*, 7 English Court*, 9 English Court*, 115 Butters Drive*, 2 The Verge*, 18 The Verge*, 4 The Verge*, 21 English Court*, 12 The Verge*, 16 The Verge*, 13 English Court*, 19 English Court* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.353204, Long: 149.09599))
    UnitPlans.append(Building(UPNo: "UP239", Name: "", Address: "13 Schomburgk Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.309379, Long: 149.093386))
    UnitPlans.append(Building(UPNo: "UP240", Name: "", Address: "30 Eungella Street DUFFY 2611", Suburb: "DUFFY", Lat: -35.338698, Long: 149.031304))
    UnitPlans.append(Building(UPNo: "UP241", Name: "Chave Street", Address: "26 Chave Street HOLT 2615", Suburb: "HOLT", Lat: -35.223066, Long: 149.023912))
    UnitPlans.append(Building(UPNo: "UP242", Name: "", Address: "25 Nathan Street, 51 Newdegate Street DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.314551, Long: 149.098994))
    UnitPlans.append(Building(UPNo: "UP243", Name: "", Address: "27 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.241601, Long: 149.040705))
    UnitPlans.append(Building(UPNo: "UP244", Name: "", Address: "21 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.241597, Long: 149.039482))
    UnitPlans.append(Building(UPNo: "UP245", Name: "", Address: "7 Clode Place MACGREGOR 2615", Suburb: "MACGREGOR", Lat: -35.211103, Long: 149.012798))
    UnitPlans.append(Building(UPNo: "UP246", Name: "Argyle Square Stage 3", Address: "1 Kogarah Lane, 3 Kogarah Lane REID 2612", Suburb: "REID", Lat: -35.279219, Long: 149.137063))
    UnitPlans.append(Building(UPNo: "UP247", Name: "", Address: "59 Townsville Street, 57 Townsville Street, 61 Townsville Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.330647, Long: 149.183898))
    UnitPlans.append(Building(UPNo: "UP248", Name: "", Address: "3 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.242986, Long: 149.038855))
    UnitPlans.append(Building(UPNo: "UP249", Name: "", Address: "7 Keith Street*, 11 Petre Street* SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.234366, Long: 149.041056))
    UnitPlans.append(Building(UPNo: "UP250", Name: "", Address: "15 Hargrave Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.229357, Long: 149.040934))
    UnitPlans.append(Building(UPNo: "UP251", Name: "", Address: "12 Araluen Street FISHER 2611", Suburb: "FISHER", Lat: -35.360709, Long: 149.056714))
    UnitPlans.append(Building(UPNo: "UP252", Name: "Mountview Estate", Address: "22 Namatjira Drive WESTON 2611", Suburb: "WESTON", Lat: -35.341015, Long: 149.05605))
    UnitPlans.append(Building(UPNo: "UP253", Name: "", Address: "78 Goodwin Place LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.250882, Long: 149.133059))
    UnitPlans.append(Building(UPNo: "UP254", Name: "", Address: "8 Watling Place WESTON 2611", Suburb: "WESTON", Lat: -35.343174, Long: 149.052797))
    UnitPlans.append(Building(UPNo: "UP255", Name: "", Address: "16 Sexton Street COOK 2614", Suburb: "COOK", Lat: -35.256706, Long: 149.071051))
    UnitPlans.append(Building(UPNo: "UP257", Name: "19 Schomburgk Street Yarralumla", Address: "19 Schomburgk Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.308199, Long: 149.093875))
    UnitPlans.append(Building(UPNo: "UP258", Name: "The Havens", Address: "42 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.242642, Long: 149.041356))
    UnitPlans.append(Building(UPNo: "UP259", Name: "", Address: "54B Forbes Street, Forbes Street TURNER 2612", Suburb: "TURNER", Lat: -35.262546, Long: 149.130592))
    UnitPlans.append(Building(UPNo: "UP260", Name: "", Address: "28 Gosse Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.313489, Long: 149.141754))
    UnitPlans.append(Building(UPNo: "UP261", Name: "The Pines", Address: "20 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.249755, Long: 149.133081))
    UnitPlans.append(Building(UPNo: "UP262", Name: "", Address: "29 Hargrave Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.229603, Long: 149.043045))
    UnitPlans.append(Building(UPNo: "UP263", Name: "Ashleigh Grove", Address: "33 Hargrave Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.230311, Long: 149.043981))
    UnitPlans.append(Building(UPNo: "UP264", Name: "", Address: "30 Chinner Crescent MELBA 2615", Suburb: "MELBA", Lat: -35.210076, Long: 149.049121))
    UnitPlans.append(Building(UPNo: "UP265", Name: "", Address: "21 Hargrave Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.229482, Long: 149.042162))
    UnitPlans.append(Building(UPNo: "UP266", Name: "The Terrace", Address: "27 Giles Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.315741, Long: 149.139906))
    UnitPlans.append(Building(UPNo: "UP267", Name: "", Address: "18 Jaeger Circuit BRUCE 2617", Suburb: "BRUCE", Lat: -35.249582, Long: 149.086103))
    UnitPlans.append(Building(UPNo: "UP268", Name: "", Address: "20 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.249755, Long: 149.133081))
    UnitPlans.append(Building(UPNo: "UP269", Name: "", Address: "6 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.36599, Long: 149.09769))
    UnitPlans.append(Building(UPNo: "UP270", Name: "", Address: "8 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.366373, Long: 149.097469))
    UnitPlans.append(Building(UPNo: "UP271", Name: "", Address: "21 Barlow Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.228989, Long: 149.037619))
    UnitPlans.append(Building(UPNo: "UP272", Name: "", Address: "31 Barlow Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.229352, Long: 149.039214))
    UnitPlans.append(Building(UPNo: "UP273", Name: "", Address: "11 Howitt Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.316065, Long: 149.144354))
    UnitPlans.append(Building(UPNo: "UP274", Name: "", Address: "2 Gosse Street* KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.313169, Long: 149.140506))
    UnitPlans.append(Building(UPNo: "UP275", Name: "", Address: "57 Tasmania Circle, 59 Tasmania Circle, 106 Arthur Circle, 108 Arthur Circle, 61 Tasmania Circle, 102 Arthur Circle, 104 Arthur Circle, 63 Tasmania Circle, 100 Arthur Circle, 98 Arthur Circle FORREST 2603", Suburb: "FORREST", Lat: -35.317777, Long: 149.124348))
    UnitPlans.append(Building(UPNo: "UP276", Name: "", Address: "36 Shackleton Circuit MAWSON 2607", Suburb: "MAWSON", Lat: -35.364885, Long: 149.101281))
    UnitPlans.append(Building(UPNo: "UP277", Name: "", Address: "1 Jardine Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.313432, Long: 149.140434))
    UnitPlans.append(Building(UPNo: "UP278", Name: "", Address: "22 Namatjira Drive WESTON 2611", Suburb: "WESTON", Lat: -35.341015, Long: 149.05605))
    UnitPlans.append(Building(UPNo: "UP279", Name: "Cervo Village", Address: "15 Vansittart Crescent KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.396704, Long: 149.064331))
    UnitPlans.append(Building(UPNo: "UP280", Name: "Brindabella Court", Address: "47 Ashby Circuit*, 53 Ashby Circuit* KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.396369, Long: 149.064568))
    UnitPlans.append(Building(UPNo: "UP281", Name: "", Address: "1 Pinkerton Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.397642, Long: 149.06456))
    UnitPlans.append(Building(UPNo: "UP282", Name: "", Address: "24 Telopea Park* KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.313807, Long: 149.139657))
    UnitPlans.append(Building(UPNo: "UP283", Name: "", Address: "5 Mckay Gardens TURNER 2612", Suburb: "TURNER", Lat: -35.273601, Long: 149.12761))
    UnitPlans.append(Building(UPNo: "UP284", Name: "", Address: "12 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.251151, Long: 149.132759))
    UnitPlans.append(Building(UPNo: "UP285", Name: "", Address: "12 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.251151, Long: 149.132759))
    UnitPlans.append(Building(UPNo: "UP286", Name: "", Address: "1 Mawson Place MAWSON 2607", Suburb: "MAWSON", Lat: -35.365332, Long: 149.093639))
    UnitPlans.append(Building(UPNo: "UP287", Name: "Bellevue Terrace", Address: "31 Moyes Crescent HOLT 2615", Suburb: "HOLT", Lat: -35.222393, Long: 149.023603))
    UnitPlans.append(Building(UPNo: "UP288", Name: "", Address: "55 Jemalong Street*, 97 Jemalong Street*, 57 Jemalong Street*, 73 Jemalong Street*, 85 Jemalong Street*, 83 Jemalong Street*, 91 Jemalong Street*, 77 Jemalong Street*, 71 Jemalong Street*, 67 Jemalong Street*, 79 Jemalong Street*, 95 Jemalong Street*, 93 Jemalong Street*, 65 Jemalong Street*, 87 Jemalong Street*, 59 Jemalong Street*, 81 Jemalong Street*, 89 Jemalong Street*, 75 Jemalong Street*, 63 Jemalong Street*, 69 Jemalong Street*, 61 Jemalong Street* DUFFY 2611", Suburb: "DUFFY", Lat: -35.336653, Long: 149.030846))
    UnitPlans.append(Building(UPNo: "UP289", Name: "", Address: "28-30 Dundas Court PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.354014, Long: 149.087547))
    UnitPlans.append(Building(UPNo: "UP290", Name: "Stanley Park", Address: "59 Pinkerton Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.399185, Long: 149.06448))
    UnitPlans.append(Building(UPNo: "UP291", Name: "", Address: "43 Kirkland Circuit MACGREGOR 2615", Suburb: "MACGREGOR", Lat: -35.209225, Long: 149.012225))
    UnitPlans.append(Building(UPNo: "UP292", Name: "", Address: "10 Ashby Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.395648, Long: 149.065724))
    UnitPlans.append(Building(UPNo: "UP293", Name: "Mountbatten Park", Address: "65 Musgrave Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.302577, Long: 149.105216))
    UnitPlans.append(Building(UPNo: "UP294", Name: "", Address: "39 Gardiner Street*, 3 Cadell Street* DOWNER 2602", Suburb: "DOWNER", Lat: -35.246714, Long: 149.149365))
    UnitPlans.append(Building(UPNo: "UP295", Name: "", Address: "9 Murdoch Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.250882, Long: 149.133059))
    UnitPlans.append(Building(UPNo: "UP296", Name: "", Address: "22 Howie Court*, 12 Howie Court*, 14 Howie Court*, 20 Howie Court*, 5 Disney Court*, 13 Disney Court*, 6 Howie Court*, 18 Howie Court*, 1 Disney Court*, 19 Disney Court*, 15 Disney Court*, 16 Howie Court*, 28 Howie Court*, 9 Disney Court*, 17 Disney Court*, 7 Disney Court*, 4 Howie Court*, 11 Disney Court*, 2 Howie Court*, 30 Howie Court*, 10 Howie Court*, 24 Howie Court*, 3 Disney Court*, 8 Howie Court*, 26 Howie Court* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.243721, Long: 149.069924))
    UnitPlans.append(Building(UPNo: "UP297", Name: "", Address: "75 Pinkerton Circuit*, 77 Pinkerton Circuit*, 81 Pinkerton Circuit*, 83 Pinkerton Circuit*, 69 Pinkerton Circuit*, 73 Pinkerton Circuit*, 67 Pinkerton Circuit*, 71 Pinkerton Circuit* KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.398108, Long: 149.064464))
    UnitPlans.append(Building(UPNo: "UP298", Name: "Alpo Court", Address: "108 Herron Crescent LATHAM 2615", Suburb: "LATHAM", Lat: -35.210666, Long: 149.027069))
    UnitPlans.append(Building(UPNo: "UP299", Name: "", Address: "79 Collings Street PEARCE 2607", Suburb: "PEARCE", Lat: -35.357282, Long: 149.086812))
    UnitPlans.append(Building(UPNo: "UP300", Name: "", Address: "9 Murdoch Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.250882, Long: 149.133059))
    UnitPlans.append(Building(UPNo: "UP301", Name: "", Address: "58 Bennelong Crescent MACQUARIE 2614", Suburb: "MACQUARIE", Lat: -35.249293, Long: 149.059048))
    UnitPlans.append(Building(UPNo: "UP302", Name: "", Address: "61 Ashby Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.394919, Long: 149.064892))
    UnitPlans.append(Building(UPNo: "UP303", Name: "", Address: "14 Kemble Court, 13 Brookes Street, 16 Kemble Court MITCHELL 2911", Suburb: "MITCHELL", Lat: -35.219437, Long: 149.139991))
    UnitPlans.append(Building(UPNo: "UP304", Name: "Dma Professional Offices", Address: "2 Wales Street*, 55 Lathlain Street* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.242684, Long: 149.062003))
    UnitPlans.append(Building(UPNo: "UP305", Name: "", Address: "28 Black Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.302502, Long: 149.103703))
    UnitPlans.append(Building(UPNo: "UP306", Name: "Scullin Gardens", Address: "93 Chewings Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.232349, Long: 149.047951))
    UnitPlans.append(Building(UPNo: "UP307", Name: "", Address: "9 Brookes Street, 12 Kemble Court, 10 Kemble Court MITCHELL 2911", Suburb: "MITCHELL", Lat: -35.219804, Long: 149.140434))
    UnitPlans.append(Building(UPNo: "UP309", Name: "Frencham Court", Address: "28 Frencham Street DOWNER 2602", Suburb: "DOWNER", Lat: -35.244829, Long: 149.146025))
    UnitPlans.append(Building(UPNo: "UP310", Name: "", Address: "94 Giles Street, 47 Eyre Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.31431, Long: 149.143574))
    UnitPlans.append(Building(UPNo: "UP311", Name: "", Address: "1 Batchelor Street*, 5 Beasley Street* TORRENS 2607", Suburb: "TORRENS", Lat: -35.365199, Long: 149.09043))
    UnitPlans.append(Building(UPNo: "UP312", Name: "", Address: "25 Giles Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.31583, Long: 149.139422))
    UnitPlans.append(Building(UPNo: "UP313", Name: "", Address: "26 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.249267, Long: 149.132989))
    UnitPlans.append(Building(UPNo: "UP314", Name: "", Address: "27 Moyes Crescent, 19 Moyes Crescent, 29 Moyes Crescent, 23 Moyes Crescent, 21 Moyes Crescent, 17 Moyes Crescent, 25 Moyes Crescent, 49 Postle Circuit HOLT 2615", Suburb: "HOLT", Lat: -35.222421, Long: 149.022613))
    UnitPlans.append(Building(UPNo: "UP315", Name: "The Pines", Address: "26 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.249267, Long: 149.132989))
    UnitPlans.append(Building(UPNo: "UP317", Name: "Valley View Park", Address: "27 Gaunson Crescent WANNIASSA 2903", Suburb: "WANNIASSA", Lat: -35.393816, Long: 149.099191))
    UnitPlans.append(Building(UPNo: "UP318", Name: "60 Dalley Crescent Latham", Address: "2 Stumm Place*, 60 Dalley Crescent* LATHAM 2615", Suburb: "LATHAM", Lat: -35.217662, Long: 149.03324))
    UnitPlans.append(Building(UPNo: "UP319", Name: "", Address: "24 Blamey Place CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.289572, Long: 149.154457))
    UnitPlans.append(Building(UPNo: "UP320", Name: "", Address: "14 Lonsdale Street BRADDON 2612", Suburb: "BRADDON", Lat: -35.274186, Long: 149.132925))
    UnitPlans.append(Building(UPNo: "UP321", Name: "", Address: "29 Wollongong Street*, 25 Wollongong Street*, 31 Wollongong Street*, 1 Kembla Street*, 27 Wollongong Street*, 3 Kembla Street, 5 Kembla Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.326101, Long: 149.178623))
    UnitPlans.append(Building(UPNo: "UP322", Name: "The Pines", Address: "26 Oliver Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.249267, Long: 149.132989))
    UnitPlans.append(Building(UPNo: "UP323", Name: "", Address: "10 Kennedy Street KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.316911, Long: 149.14069))
    UnitPlans.append(Building(UPNo: "UP324", Name: "", Address: "51 Hampton Circuit YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.311072, Long: 149.109083))
    UnitPlans.append(Building(UPNo: "UP325", Name: "", Address: "84 Bourne Street*, 74 Bourne Street*, 78 Bourne Street*, 82 Bourne Street*, 80 Bourne Street*, 86 Bourne Street*, 76 Bourne Street* COOK 2614", Suburb: "COOK", Lat: -35.258937, Long: 149.070806))
    UnitPlans.append(Building(UPNo: "UP326", Name: "", Address: "80 Marr Street PEARCE 2607", Suburb: "PEARCE", Lat: -35.364332, Long: 149.08898))
    UnitPlans.append(Building(UPNo: "UP327", Name: "", Address: "2 English Court*, 8 English Court*, 10 English Court*, 4 English Court*, 6 English Court* PHILLIP 2606", Suburb: "PHILLIP", Lat: -35.353325, Long: 149.09845))
    UnitPlans.append(Building(UPNo: "UP328", Name: "", Address: "61 Wollongong Street, 55 Wollongong Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.324185, Long: 149.179234))
    UnitPlans.append(Building(UPNo: "UP329", Name: "", Address: "17 Pinkerton Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.397752, Long: 149.065546))
    UnitPlans.append(Building(UPNo: "UP330", Name: "", Address: "2 Trenerry Street* WESTON 2611", Suburb: "WESTON", Lat: -35.341019, Long: 149.052005))
    UnitPlans.append(Building(UPNo: "UP331", Name: "", Address: "21 Mcginness Street SCULLIN 2614", Suburb: "SCULLIN", Lat: -35.234151, Long: 149.042462))
    UnitPlans.append(Building(UPNo: "UP332", Name: "", Address: "64 Knox Street WATSON 2602", Suburb: "WATSON", Lat: -35.23758, Long: 149.152657))
    UnitPlans.append(Building(UPNo: "UP333", Name: "", Address: "2 Marr Street PEARCE 2607", Suburb: "PEARCE", Lat: -35.358681, Long: 149.086948))
    UnitPlans.append(Building(UPNo: "UP334", Name: "Lakeland Court", Address: "49 Pinkerton Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.399583, Long: 149.065452))
    UnitPlans.append(Building(UPNo: "UP335", Name: "", Address: "3 Lane-Poole Place*, 5 Lane-Poole Place*, 7 Lane-Poole Place* YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.306886, Long: 149.091618))
    UnitPlans.append(Building(UPNo: "UP336", Name: "", Address: "5 Ware Place*, 7 Ware Place*, 1 Ware Place*, 3 Ware Place* BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.247433, Long: 149.06873))
    UnitPlans.append(Building(UPNo: "UP337", Name: "Chalet Court", Address: "124 De Burgh Street LYNEHAM 2602", Suburb: "LYNEHAM", Lat: -35.253177, Long: 149.132781))
    UnitPlans.append(Building(UPNo: "UP338", Name: "", Address: "48 Mannheim Street, 48A Mannheim Street, 48B Mannheim Street KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.384045, Long: 149.072216))
    UnitPlans.append(Building(UPNo: "UP339", Name: "", Address: "9 Jinka Street HAWKER 2614", Suburb: "HAWKER", Lat: -35.242542, Long: 149.039309))
    UnitPlans.append(Building(UPNo: "UP340", Name: "Shackleton Park", Address: "72 Shackleton Circuit MAWSON 2607", Suburb: "MAWSON", Lat: -35.368376, Long: 149.104254))
    UnitPlans.append(Building(UPNo: "UP341", Name: "", Address: "10 Vanzetti Crescent KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.392195, Long: 149.07234))
    UnitPlans.append(Building(UPNo: "UP342", Name: "", Address: "71 Constitution Avenue CAMPBELL 2612", Suburb: "CAMPBELL", Lat: -35.291318, Long: 149.145216))
    UnitPlans.append(Building(UPNo: "UP344", Name: "", Address: "25 Pinkerton Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.398072, Long: 149.066405))
    UnitPlans.append(Building(UPNo: "UP345", Name: "Rinegolde Park", Address: "103 Canberra Avenue GRIFFITH 2603", Suburb: "GRIFFITH", Lat: -35.321588, Long: 149.144774))
    UnitPlans.append(Building(UPNo: "UP346", Name: "", Address: "48 Dalley Crescent LATHAM 2615", Suburb: "LATHAM", Lat: -35.219178, Long: 149.031313))
    UnitPlans.append(Building(UPNo: "UP347", Name: "35 Ashby Circuit", Address: "35 Ashby Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.397054, Long: 149.066042))
    UnitPlans.append(Building(UPNo: "UP348", Name: "", Address: "19 Ashby Circuit KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.396093, Long: 149.067021))
    UnitPlans.append(Building(UPNo: "UP349", Name: "", Address: "22 Thesiger Court DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.317362, Long: 149.09608))
    UnitPlans.append(Building(UPNo: "UP350", Name: "", Address: "51 Musgrave Street YARRALUMLA 2600", Suburb: "YARRALUMLA", Lat: -35.302821, Long: 149.10487))
    UnitPlans.append(Building(UPNo: "UP351", Name: "", Address: "31 Disney Court BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.244273, Long: 149.070344))
    UnitPlans.append(Building(UPNo: "UP352", Name: "Argyle Square Stage 4", Address: "37 Currong Street South REID 2612", Suburb: "REID", Lat: -35.279947, Long: 149.137589))
    UnitPlans.append(Building(UPNo: "UP353", Name: "", Address: "26 Sandford Street* MITCHELL 2911", Suburb: "MITCHELL", Lat: -35.220468, Long: 149.141089))
    UnitPlans.append(Building(UPNo: "UP354", Name: "", Address: "38 Thesiger Court* DEAKIN 2600", Suburb: "DEAKIN", Lat: -35.316361, Long: 149.096257))
    UnitPlans.append(Building(UPNo: "UP355", Name: "", Address: "23 Darling Street* BARTON 2600", Suburb: "BARTON", Lat: -35.31035, Long: 149.135756))
    UnitPlans.append(Building(UPNo: "UP356", Name: "", Address: "30 Primmer Court KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.380313, Long: 149.057998))
    UnitPlans.append(Building(UPNo: "UP357", Name: "", Address: "10 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.366926, Long: 149.097802))
    UnitPlans.append(Building(UPNo: "UP358", Name: "", Address: "6 Bonrook Street*, HAWKER 2614", Suburb: "HAWKER", Lat: -35.244896, Long: 149.042938))
    UnitPlans.append(Building(UPNo: "UP359", Name: "Blue Range Park", Address: "32 Bunbury Street STIRLING 2611", Suburb: "STIRLING", Lat: -35.346702, Long: 149.051567))
    UnitPlans.append(Building(UPNo: "UP360", Name: "", Address: "184 Gladstone Street*, 186 Gladstone Street FYSHWICK 2609", Suburb: "FYSHWICK", Lat: -35.329225, Long: 149.184699))
    UnitPlans.append(Building(UPNo: "UP361", Name: "", Address: "20 Fitzherbert Place*, 24 Fitzherbert Place* BRUCE 2617", Suburb: "BRUCE", Lat: -35.251148, Long: 149.082638))
    UnitPlans.append(Building(UPNo: "UP362", Name: "", Address: "5 Primmer Court* KAMBAH 2902", Suburb: "KAMBAH", Lat: -35.379903, Long: 149.057723))
    UnitPlans.append(Building(UPNo: "UP363", Name: "26 Disney Court", Address: "26 Disney Court BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.244586, Long: 149.070495))
    UnitPlans.append(Building(UPNo: "UP365", Name: "", Address: "2 Playfair Place BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.244289, Long: 149.071488))
    UnitPlans.append(Building(UPNo: "UP366", Name: "The Crest", Address: "12 Wilkins Street MAWSON 2607", Suburb: "MAWSON", Lat: -35.367545, Long: 149.09795))
    UnitPlans.append(Building(UPNo: "UP367", Name: "", Address: "22 Leichhardt Street GRIFFITH 2603", Suburb: "GRIFFITH", Lat: -35.318911, Long: 149.142094))
    UnitPlans.append(Building(UPNo: "UP368", Name: "", Address: "25 Crick Place BELCONNEN 2617", Suburb: "BELCONNEN", Lat: -35.245921, Long: 149.072276))
    UnitPlans.append(Building(UPNo: "UP369", Name: "Quadrant", Address: "8 Howitt Street* KINGSTON 2604", Suburb: "KINGSTON", Lat: -35.315483, Long: 149.143216))
    UnitPlans.append(Building(UPNo: "UP3964", Name: "Greenleigh Park", Address: "21 Samaria Street CRACE 2911", Suburb: "CRACE", Lat: -35.202486, Long: 149.108423))
    UnitPlans.append(Building(UPNo: "UP3983", Name: "Cassula Villas", Address: "35 Laird Crescent FORDE 2914", Suburb: "FORDE", Lat: -35.156806, Long: 149.151566))
    UnitPlans.append(Building(UPNo: "UP4001", Name: "Abena Apartments", Address: "47 Abena Avenue CRACE 2911", Suburb: "CRACE", Lat: -35.2013, Long: 149.106737))
    UnitPlans.append(Building(UPNo: "UP4139", Name: "Azura Villas", Address: "8 Henry Kendall Street FRANKLIN 2913", Suburb: "FRANKLIN", Lat: -35.196795, Long: 149.149473))
    UnitPlans.append(Building(UPNo: "CT2", Name: "CT2 6-34 Chance St", Address: "6-36 Chance Street CRACE 2911", Suburb: "CRACE", Lat: -35.199899, Long: 149.104289))
    
    for UP in UnitPlans {
      print("\(UP.UPNo) \(UP.Name) \(UP.Suburb) Lat: \(UP.Lat) Lng: \(UP.Long) \(UP.Address) ")
    }

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
      self.dataProvider.performGoogleSearch("9+Fingal+Street+CRACE+ACT+2911")
      
      // MARK: UNIT PLANS
      //
      // add LMM Solutions office location as a (normal) google maps Red Pin
      // refer developers.google.com/maps/documentation/ios-sdk/marker
      //
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: -35.205422, longitude: 149.114447)
      //marker.icon = GMSMarker.markerImage(with: .black)
      //marker.iconView = false
      marker.icon = UIImage(named: "lmm-pin")
      marker.title = "LMM Solutions"
      marker.snippet = "is awesome!"
      marker.opacity = 0.6
      marker.isFlat = false
      marker.appearAnimation = .pop
      marker.map = self.mapView
      
      for UP in self.UnitPlans {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: UP.Lat, longitude: UP.Long)
        marker.icon = UIImage(named: "units_plan_pin")
        marker.title = UP.UPNo + " " + UP.Name
        marker.snippet = UP.Address
        marker.map = self.mapView
        print("Adding pin for \(UP.UPNo) - \(UP.Name) \(UP.Suburb) Lat: \(UP.Lat) Lng: \(UP.Long) \(UP.Address) ")
      }

    }
  }
  
  // MARK LOOKUP ADDRESS - NEEDS ALAMOFIRE BUT NEEDS REWRITE
//  func getAddress(address:String){
//    
//    let key : String = "YOUR_GOOGLE_API_KEY"
//    let postParameters:[String: Any] = [ "address": address,"key":key]
//    let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
//    
//    Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
//      
//      if let receivedResults = response.result.value
//      {
//        let resultParams = JSON(receivedResults)
//        print(resultParams) // RESULT JSON
//        print(resultParams["status"]) // OK, ERROR
//        print(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue) // approximately latitude
//        print(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue) // approximately longitude
//      }
//    }
//  }

  @IBAction func refreshPlaces(_ sender: Any) {
    fetchNearbyPlaces(coordinate: mapView.camera.target)

  }
}

// MARK: ADDRESS LOOKUP
//func performGoogleSearch(for string: String) {
//  string = nil
//  tableView.reloadData()
//
//  var components = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
//  let key = URLQueryItem(name: "key", value: "...") // use your key
//  let address = URLQueryItem(name: "address", value: string)
//  components.queryItems = [key, address]
//
//  let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
//    guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
//      print(String(describing: response))
//      print(String(describing: error))
//      return
//    }
//
//    guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//      print("not JSON format expected")
//      print(String(data: data, encoding: .utf8) ?? "Not string?!?")
//      return
//    }
//
//    guard let results = json["results"] as? [[String: Any]],
//      let status = json["status"] as? String,
//      status == "OK" else {
//        print("no results")
//        print(String(describing: json))
//        return
//    }
//
//    DispatchQueue.main.async {
//      // now do something with the results, e.g. grab `formatted_address`:
//      let strings = results.flatMap { $0["formatted_address"] as? String }
//      ...
//    }
//  }
//
//  task.resume()
//}

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
    //mapView.mapType = kGMSTypeSatellite // is not available on Goole maps sdk for IOS
  
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

































