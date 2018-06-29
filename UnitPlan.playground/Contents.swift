struct Building {
  var UPNo: Int
  var Name: String
  var Address: String
  var Suburb: String
  var Lat: Double
  var Long: Double
}

var UnitPlans: [Building] = []

UnitPlans.append(Building(UPNo: 2, Name: "CT2", Address: "6-36 Chance Street  Crace  Gungahlin  2911", Suburb: "Crace",Lat: 35.199899,Long: 149.104289))
UnitPlans.append(Building(UPNo: 345, Name: "Rinegolde Park", Address: "103 Canberra Avenue Griffith Canberra Central 2603", Suburb: "Griffith", Lat: -35.321588, Long: 149.144774))
UnitPlans.append(Building(UPNo: 359, Name: "Blue Range Park", Address: "32 Bunbury Street  Stirling  Weston Creek  2611", Suburb: "Weston Creek", Lat: -35.346702, Long: 149.051567))
UnitPlans.append(Building(UPNo: 3964, Name: "Greenleigh Park", Address: "21 Samaria Street  Crace  Gungahlin  2911", Suburb: "Crace",Lat: -35.202486,Long: 149.108423))
UnitPlans.append(Building(UPNo: 4001, Name: "Abena Apartments", Address: "47 Abena Avenue  Crace  Gungahlin  2911", Suburb: "Crace",Lat: -35.201300,Long: 149.106737))

for UP in UnitPlans {
  print("UP\(UP.UPNo) \(UP.Name) \(UP.Suburb) Lat: \(UP.Lat) Lng: \(UP.Long) \(UP.Address) ")
}
