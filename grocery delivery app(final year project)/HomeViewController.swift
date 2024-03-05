//
//  HomeViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 24/11/2022.
//

import UIKit
import Parse
import FirebaseCore
import FirebaseFirestore

var favoritePlaces : [String] = []
var favoriteDishes : [[String : String]] = []
var restArray : [[String : String]] = []
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    // tab bar home, image classifier,  favorites and account
    
    
    //MARK: IBOUTLETS AND VARIABLES
    let categories = [["Category":"Restaurant","Image" : "restaurant"],["Category" : "Grocery", "Image" : "grocery"]]
    
    var postCode = "L1 2QW"
    var current = 0
    var favorites = false
    var id = ""
    
    @IBOutlet weak var cartOutlet: UIButton!
    
    @IBAction func cartButton(_ sender: Any) {
        performSegue(withIdentifier: "hometoCart", sender: nil)
    }
    
    @IBAction func pickupButton(_ sender: Any){
        performSegue(withIdentifier: "hometopickup", sender: nil)
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var theSearchBar: UISearchBar!
    var restaurantStruct : restaurants? = nil
    var restaurantArray = [[String : String]()]
    var restaurantStoreNames : [String] = []
    var FilteredData : [String] = []
    var restaurant  = ""
    var category = ""
    
    
    
    //MARK: IBACTIONS
    @IBAction func favoriteButton(_ sender: UIButton) {
        if(!(favoritePlaces.contains(restaurantStoreNames[sender.tag]))){
            sender.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            favoritePlaces.append(restaurantStoreNames[sender.tag])
        }
        
        else{
            sender.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            favoritePlaces = favoritePlaces.filter{$0 != restaurantStoreNames[sender.tag]}
        }
        
        /////////////////////////////////////////////////////////////////////////////////////
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUserInfo["userId"] as! String).setData(["email" : currentUserInfo["email"]!, "name" : currentUserInfo["name"]!,"password" : currentUserInfo["password"]!,"postcode" : currentUserInfo["postcode"] ?? "nil" ,"userId" : currentUserInfo["userId"]!, "orders" : currentUserInfo["orders"] ?? "nil", "points" : pointsEarned, "favoritePlaces": favoritePlaces, "favoriteDishes": favoriteDishes ]){err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            }
            
            else {
                print("Document successfully written!")
            }
            
        }
        
        
        /////////////////////////////////////////////////////////////////////////////////////
        favoritesCollectionView.reloadData()
        restaurantCollectionView.reloadData()
    }
    
    
    @IBAction func favButtonFavCollection(_ sender: UIButton) {
        favoritePlaces = favoritePlaces.filter{$0 != favoritePlaces[sender.tag]}
       
        /////////////////////////////////////////////////////////////////////////////////////
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUserInfo["userId"] as! String).setData(["email" : currentUserInfo["email"]!, "name" : currentUserInfo["name"]!,"password" : currentUserInfo["password"]!,"postcode" : currentUserInfo["postcode"] ?? "nil" ,"userId" : currentUserInfo["userId"]!, "orders" : currentUserInfo["orders"] ?? "nil", "points" : pointsEarned, "favoritePlaces": favoritePlaces, "favoriteDishes": favoriteDishes ]){err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            }
            
            else {
                print("Document successfully written!")
            }
            
        }
        
        
        /////////////////////////////////////////////////////////////////////////////////////
        favoritesCollectionView.reloadData()
        restaurantCollectionView.reloadData()
    }
    
    
    
    
    
   
    //MARK: COLLECTIONVIEW DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == categoryCollectionView){
            return categories.count
        }
        
        else if(collectionView == restaurantCollectionView){
            return FilteredData.count
        }
        
        else{
            return favoritePlaces.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == categoryCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CategoryCollectionViewCell
            cell.label.text = categories[indexPath.row]["Category"]
            cell.imageView.layer.cornerRadius = 10.0
            cell.imageView.image = UIImage(named:categories[indexPath.row]["Image"]!)
            return cell
        }
       
        else if(collectionView == restaurantCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell2", for: indexPath) as! CollectionViewCell
            cell.label.text = FilteredData[indexPath.row]
            cell.imageView.layer.cornerRadius = 10.0
            cell.imageView.image = UIImage(named: "restaurant image")
            cell.favoriteButton.addTarget(self, action: #selector(favoriteButton), for: UIControl.Event.touchUpInside)
            cell.addSubview(cell.favoriteButton)
            cell.favoriteButton.tag = indexPath.row
            
            if(!(favoritePlaces.contains(FilteredData[indexPath.row]))){
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
            else{
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell3", for: indexPath) as! favoritesCollectionViewCell
            cell.imageView.image = UIImage(named: "restaurant image")
            cell.label.text = favoritePlaces[indexPath.row]
            cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.favButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: #selector(favButtonFavCollection), for: UIControl.Event.touchUpInside)
            cell.addSubview(cell.favButton)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == restaurantCollectionView){
            restaurant = FilteredData[indexPath.row]
            performSegue(withIdentifier: "hometomenu", sender: nil)
        }
        
        else if(collectionView == favoritesCollectionView){
            restaurant = favoritePlaces[indexPath.row]
            print(restaurant)
            performSegue(withIdentifier: "hometomenu", sender: nil)
        }
        
        else{
            category = categories[indexPath.row]["Category"]!
            print(category)
            performSegue(withIdentifier: "categorytodetail", sender: nil)
        }
            
       
    }
    
    //MARK: VIEWDIDLOAD, VIEWDIDAPPEAR AND VIEWWILLAPPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("users").document(id).getDocument { document, error in
            if ((document!.exists)){
                currentUserInfo = (document?.data())!
            }
           
            print(currentUserInfo)
        }
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        restaurantCollectionView.reloadData()
        favoritesCollectionView.reloadData()
        if(!cart.isEmpty){
            cartOutlet.setImage(UIImage(systemName: "cart.fill"), for: .normal)
            cartOutlet.isEnabled = true
        }
        
        else{
            cartOutlet.setImage(UIImage(systemName: "cart"), for: .normal)
            cartOutlet.isEnabled = false
        }
        print("viewdidload \(currentUserInfo)")
        CartViewController.fromPayment = false
        favoritesCollectionView.reloadData()
    
    }


    override func viewDidLoad() {
        restaurantCollectionView.reloadData()
        favoritesCollectionView.reloadData()
        super.viewDidLoad()
        categoryCollectionView.reloadData()
        testParseConnection()
        
        titleLabel.text = "Deliver to . \(postCode)"
        print(currentUserInfo)
        
        
        if let url = URL(string:"https://parseapi.back4app.com/classes/restaurants"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KwLoFN7Rik2qadAS6dSpnNIv5E0Qd1Uu0nhvO1dt", forHTTPHeaderField: "X-Parse-Application-Id")
            request.setValue("r5oNJO0EMk916k0Ospp2nUR30vy4O8w24hrAdWZX", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            session.dataTask(with: request) { [self](data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let restaurantList = try decoder.decode(restaurants.self, from: jsonData)
                    self.restaurantStruct = restaurantList
                    DispatchQueue.main.async {
                        self.fillArray()
                        self.restaurantCollectionView.reloadData()
                        self.categoryCollectionView.reloadData()
                    }
                    // get restaurant and store names
                    for anItem in restaurantList.results{
                        if(!(restaurantStoreNames.contains(anItem.restaurant))){
                            restaurantStoreNames.append(anItem.restaurant)
                        }
                    }
                    FilteredData = restaurantStoreNames
                    //print(restaurantStoreNames)
                }
                catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }
            
            .resume()
        }
        
        // Do any additional setup after loading the view.
    }
    
   
    
  
    
    
    //MARK: MY METHODS
    func testParseConnection(){
        let myObj = PFObject(className: "FirstClass")
        myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }
            else{
                print("An error has occurred!")
            }
        }
    }

    func fillArray(){
        var counter = 0
        for anitem in restaurantStruct!.results{
            restaurantArray.insert(["restaurant" : anitem.restaurant, "name" : anitem.name, "description" : anitem.description , "calories" : anitem.calories , "price" : anitem.price , "ImageUrl" : anitem.ImageUrl , "type" : anitem.type, "category" : anitem.category], at: counter)
           
            counter += 1
        }
        restArray = restaurantArray
    }
    
    func getRestaurantMenu( _ restaurant : String) -> [[String : String]]{
        var counter = 0
        var counter2 = 0
        var menu : [[String : String]] = []
        for anitem in restaurantArray{
            if(anitem["restaurant"] == restaurant){
                menu.insert(anitem, at: counter)
                counter += 1
            }
            counter2 += 1
        }
        return menu
    }
    
    func itemsinCatSection(_ category : String ) -> [String]{
        var counter = 0;
        var names : [String] = []
        for anitem in restaurantArray{
            if(anitem["category"]?.lowercased() == category.lowercased() && !(names.contains(anitem["restaurant"]!)) ){
                names.insert(anitem["restaurant"] ?? "", at: counter)
                counter += 1
            }
        }
        
        return names
    }
    
    
    //MARK: SEARCH BAR CONFIG
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (theSearchBar.text == ""){
            FilteredData = restaurantStoreNames
        }
        
        else{
            FilteredData = []
            var i = 0
            for restaurant in restaurantStoreNames{
                if restaurant.lowercased().contains((theSearchBar.text?.lowercased())!) && !(FilteredData.contains(restaurant)){
                    FilteredData.insert(restaurant, at: i)
                    i += 1
                }
            }
        }
        restaurantCollectionView.reloadData()
    }
    
    //MARK: PREPARE FOR SEGUE METHOD
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "hometomenu"){
            let ViewController = segue.destination as! MenuViewController
            print(restaurant)
            ViewController.menu = getRestaurantMenu(restaurant)
            ViewController.restaurantName = restaurant
        }
        
        else if(segue.identifier == "categorytodetail"){
            let ViewController = segue.destination as! restaurantCatViewController
            print(itemsinCatSection(category))
            ViewController.FilteredData = itemsinCatSection(category)
            ViewController.restaurantNames = itemsinCatSection(category)
            ViewController.header = category
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.theSearchBar.endEditing(true)
    }
    
    
    
    
    //MARK: UNWIND SEGUE METHOD
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
       _ = unwindSegue.source
    }
    
    
}




