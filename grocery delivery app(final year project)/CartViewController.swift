//
//  CartViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 11/01/2023.
//

import UIKit

class CartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    static var fromPayment = false
    
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var secretKeyStruct : CheckoutIntentResponse? = nil
    var points = false
    var discountArr: [Double] = []
    
    @IBAction func checkoutButton(_ sender: Any) {
        startPayment { clientSecret in
            PaymentConfig.shared.paymentIntent = clientSecret
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "carttopay", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! cartTableViewCell
        cell.nameLabel.text = cart[indexPath.row]["name"]!
        cell.amountLabel.text = "X\(String(quantityArray[indexPath.row] [cart[indexPath.row]["name"] ?? ""]!))"
        let priceToPay = CartViewController.priceToPay()
        subtotalLabel.text! = "£\(String(priceToPay[0]/100))0"
        totalLabel.text! = "£\(String(priceToPay[0]/100))0"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            cart.remove(at: indexPath.row)
            quantityArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemTableView.reloadData()
        if(CartViewController.fromPayment == true){
            performSegue(withIdentifier: "carttohome", sender: nil)
        }
    }
    
    
    
    public static func priceToPay() -> [Double]{
        var total: [Double] = []
        var amount = 0.00
        var index = 0
        for number in quantityArray{
            amount = Double(number[cart[index]["name"]!]!) * Double(cart[index]["price"]!)!
            total.insert(amount * 100, at: 0)
            index += 1
        }
        return total
    }
    
    
    @IBAction func unwindTohome(_ unwindSegue: UIStoryboardSegue) {
       _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    private func startPayment(completion: @escaping (String?) -> Void){
        let url = URL(string: "https://tartan-elderly-wandflower.glitch.me/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            print(currentUserInfo["points"] as! Int)
            if((currentUserInfo["points"] as! Int) > 500){
                let discount = (currentUserInfo["points"] as! Int)/500
                let priceToPay = CartViewController.priceToPay()
                let discountedPrice = abs(priceToPay[0] - Double(discount * 100))
                discountArr.insert(discountedPrice, at: 0)
                pointsEarned = (currentUserInfo["points"] as! Int) - discount * 500
                print(pointsEarned)
                request.httpBody = try JSONEncoder().encode(discountArr)
                points = true
            }

            else{
                request.httpBody = try JSONEncoder().encode(CartViewController.priceToPay())
            }
        }

        catch let jsonErr{
            print("Error encoding" , jsonErr)
        }
        
        URLSession.shared.dataTask(with: request ) { (data, response, error) in
            guard let data = data , error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else{
                completion(nil)
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                print(message)
                print(((response as? HTTPURLResponse)!.statusCode))
                return
            }
            do{
                let checkoutIntentResponse = try JSONDecoder().decode(CheckoutIntentResponse.self , from: data)
                completion(checkoutIntentResponse.clientSecret)
            }
            
            catch let jsonErr{
               print("Error decoding" , jsonErr)
            }
            
            
            
        }
        .resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "carttopay"){
            let ViewController = segue.destination as! paymentViewController
            if(points == true){
                ViewController.price = discountArr
            }
            
            else{
                ViewController.price = CartViewController.priceToPay()
            }
            
        }
    }
    
    @IBAction func unwindToCart(_ unwindSegue: UIStoryboardSegue) {
       _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    

}
