//
//  restaurantCatViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 08/02/2023.
//

import UIKit

class restaurantCatViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var restaurantArr : [[String : String]] = []
    var restaurantNames : [String] = []
    var itemsInSection = 0
    var FilteredData : [String] = []
    var header = ""
    var name = ""
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "cattohome", sender: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBAction func favButton(_ sender: UIButton) {
        if(!(favoritePlaces.contains(FilteredData[sender.tag]))){
            sender.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            favoritePlaces.append(FilteredData[sender.tag])
        }
        
        else{
            sender.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            favoritePlaces = favoritePlaces.filter{$0 != restaurantArr[sender.tag]["restaurant"] ?? ""}
        }
        
        collectionView.reloadData()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilteredData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! categoriesViewCollectionViewCell
        cell.imageView.image = UIImage(named: "restaurant image")
        cell.imageView.layer.cornerRadius = 10.0
        cell.label.text = FilteredData[indexPath.row]
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(favButton), for: .touchUpInside)
        cell.addSubview(cell.favButton)
        
        if(!(favoritePlaces.contains(FilteredData[indexPath.row]))){
            cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        else{
            cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        name = FilteredData[indexPath.row]
        performSegue(withIdentifier: "cattomenu", sender: nil)
    }
    
    func getRestaurantMenu( _ restaurant : String) -> [[String : String]]{
        var counter = 0
        var counter2 = 0
        var menu : [[String : String]] = []
        for anitem in restArray{
            if(anitem["restaurant"] == restaurant){
                menu.insert(anitem, at: counter)
                counter += 1
            }
            counter2 += 1
        }
        return menu
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cattomenu"){
            let ViewController = segue.destination as! MenuViewController
            ViewController.menu = getRestaurantMenu(name)
        }
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (theSearchBar.text == ""){
            FilteredData = restaurantNames
        }
        
        else{
            FilteredData = []
            var i = 0
            for restaurant in restaurantNames{
                if restaurant.lowercased().contains((theSearchBar.text?.lowercased())!) && !(FilteredData.contains(restaurant)){
                    FilteredData.insert(restaurant, at: i)
                    i += 1
                }
            }
        }
        collectionView.reloadData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        headerLabel.text = header
        
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    

    
}
