//
//  ordersViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 20/02/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class ordersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Orders"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderArray = currentUserInfo["orders"] as? NSArray{
            return orderArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! OrderTableViewCell
        let orderArray = currentUserInfo["orders"] as! NSArray
        let itemDict = orderArray[indexPath.row] as! NSDictionary
        cell.foodItem.text = (itemDict["name"] as! String)
        cell.restuarantLabel.text = (itemDict["restaurant"] as! String)
        cell.priceLabel.text = (itemDict["price"] as! String)
        cell.restaurantImage.setImage(url: URL(string: itemDict["ImageUrl"] as! String)!)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("users").document(currentUserInfo["userId"] as! String).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            else{
                currentUserInfo = document!.data()!
                print("document succesfully read")
            }
        }
        myTable.reloadData()
      
    }
    

    

}
