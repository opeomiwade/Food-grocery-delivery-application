//
//  favoritesViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 01/02/2023.
//

import UIKit

class favoritesViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var tableData = favoritePlaces
    var dataContent = "Places"
    var name = ""
    
    @IBAction func placesButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.green
        itemsOutlet.backgroundColor = UIColor.white
        dataContent = "Places"
        tableData = favoritePlaces
        myTable.reloadData()
    }
    
    @IBOutlet weak var placesOutlet: UIButton!
    
    
    @IBOutlet weak var itemsOutlet: UIButton!
    
    
    
    @IBAction func itemsButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.green
        placesOutlet.backgroundColor = UIColor.white
        dataContent = "items"
        myTable.reloadData()
    }
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableData = favoritePlaces
        placesOutlet.backgroundColor = UIColor.green
        myTable.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        if(dataContent == "Places"){
            print(tableData.count)
            return tableData.count
        }
        
        else{
            return favoriteDishes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(dataContent == "Places"){
            print(tableData.count)
            print(tableData)
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! favoritesTabTableViewCell
            cell.label.text = tableData[indexPath.row]
            cell.imageOutlet.image = UIImage(named: "restaurant image")
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! favoritesTabTableViewCell
            cell.label.text = "\(favoriteDishes[indexPath.row]["name"] ?? "")\nPrice: \(favoriteDishes[indexPath.row]["price"] ?? "")"
            cell.imageOutlet.setImage(url: URL(string: favoriteDishes[indexPath.row]["ImageUrl"] ?? "")!)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete && dataContent == "Places"){
            favoritePlaces.remove(at: indexPath.row)
            tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        else{
            favoriteDishes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(dataContent == "Places"){
            name = tableData[indexPath.row]
            performSegue(withIdentifier: "favplacetomenu", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favplacetomenu"{
            let ViewController = segue.destination as! MenuViewController
            ViewController.menu = getMenu(name)
            ViewController.restaurantName = name
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(dataContent == "items"){
            let action = UIContextualAction(style: .normal, title: "Add to Cart") { action, view, completionHandler in
                if (!cart.contains(favoriteDishes[indexPath.row])){
                    cart.append(favoriteDishes[indexPath.row])
                    print(cart)
                    quantityArray.append([ favoriteDishes[indexPath.row]["name"] ?? "" : 1])
                    completionHandler(true)
                }
                
                else{
                    var index = 0
                    for item in cart{
                        if(favoriteDishes[index] == item){
                            quantityArray[index].updateValue(quantityArray[index][cart[index]["name"]!]! + 1, forKey: item["name"] ?? "")
                        }
                        index += 1
                    }
                    completionHandler(true)
                }
            }
            action.backgroundColor = .systemBlue
            return UISwipeActionsConfiguration(actions: [action])
        }
        
        else{
            return UISwipeActionsConfiguration()
        }
    }
    
    
    
    func getMenu(_ restaurant: String) -> [[String : String]]{
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
    
    
    
    
}
