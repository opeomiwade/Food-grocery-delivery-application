//
//  MenuViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 11/01/2023.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


//MARK: VARIABLES , ACTIONS AND OUTLET

    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backtohome", sender: nil)
    }
    
    @IBOutlet weak var favButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var item : [String : String] = ["":""]
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        if(!(favoritePlaces.contains(restaurantName))){
            sender.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            favoritePlaces.append(restaurantName)
        }
        
        else{
            sender.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            favoritePlaces = favoritePlaces.filter{$0 != restaurantName}
            print(favoritePlaces)
        }
    }
    
    
    
    var menu : [[String : String]] = []
    var sections : [String] = []
    var restaurantName = ""
    
    
    //MARK: VIEWDIDAPPEAR, VIEWDIDLOAD
    override func viewWillAppear(_ animated: Bool) {
        restaurantLabel.text = restaurantName
        if(favoritePlaces.contains(restaurantName)){
            favButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        sections = noOfSections()
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections = noOfSections()
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionHeader = sections[section]
        return noOfRowsInSection(type: sectionHeader)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! menuTableViewCell
        let current = itemsInSection(section: sections[indexPath.section])
        cell.foodImage.layer.masksToBounds = true
        cell.foodImage.layer.cornerRadius = 10.0
        cell.nameLabel.text =  current[indexPath.row]["name"]
        cell.priceLabel.text = "£\(current[indexPath.row]["price"]!)"
        cell.foodImage.setImage(url: URL(string: current[indexPath.row]["ImageUrl"] ?? " ")!)
        cell.descriptionLabel.text = current[indexPath.row]["description"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = itemsInSection(section: sections[indexPath.section])
        item = current[indexPath.row]
        performSegue(withIdentifier: "celltoaddtocart", sender: nil)
        
    }
    
    
    //MARK: MY METHODS
    
    func noOfSections() -> [String]{
        var array : [String] = []
        for anitem in menu{
            if(!(array.contains(anitem["type"] ?? ""))){
                array.append(anitem["type"] ?? "")
            }
        }
        return array
    }
    
    
    func noOfRowsInSection(type : String ) -> Int{
        var array : [[String : String]] = []
        var count = 0
        for anitem in menu{
            if(anitem["type"] ?? "" == type && !(array.contains(anitem))){
                array.append(anitem)
                count += 1
            }
        }
        return count
    }
    
    func itemsInSection(section : String) -> [[String : String]]{
        var array :[[String : String]] = []
        var index = 0
        for anitem in menu{
            if(section == anitem["type"]){
                array.insert(anitem, at: index )
                index += 1
            }
        }
        return array
    }
    
    //MARK: PREPARE FOR SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "celltoaddtocart"){
            let ViewController = segue.destination as! addToCartViewController
            ViewController.itemDictionary = item
        }
    }
}

extension UIImageView{
    func setImage(url : URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
