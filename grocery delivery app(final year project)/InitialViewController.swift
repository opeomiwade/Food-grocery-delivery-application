//
//  InitialViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 23/11/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore


var loginused = " "
class InitialViewController: UIViewController{
    
    //MARK: VARIABLES AND OUTLETS
    var provider = OAuthProvider(providerID: "twitter.com")
    var userEmail : String?
    var userId = ""
    
    //MARK: VIEWDIDLOAD()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: IBACTIONS
    @IBAction func twitter(_ sender: Any) {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print(error!)
                print(error!.localizedDescription)
                // Handle error.
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { [self] authResult, error in
                    if authResult?.user == nil {
                        // Handle error.
                        print("error \(error?.localizedDescription ?? "")")
                    }
                    
                    else{
                        providerName = "twitter"
                        let userData = InitialViewController.getUserInfo(authResult: authResult!)
                        userId = authResult!.user.uid
                        print(userData.userId)
                        print(authResult!.user.uid)
                        if userData.email != "nil"{
                            self.userEmail = userData.email
                        }
                        let db = Firestore.firestore()
                        let docRef = db.collection("users").document(userData.userId)
                        docRef.getDocument { document, error in
                            if document!.exists{
                                currentUserInfo = (document?.data())!
                            }
                            
                            else{
                                db.collection("users").document(userData.userId).setData(["email" : userData.email, "password" : "twitter password not stored to protect google account", "userId" : userData.userId, "name" : userData.name]) { error in
                                    
                                    if let error = error {
                                        print("Error writing document: \(error.localizedDescription)")
                                    }
                                    
                                    else {
                                        print("Document successfully written!")
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    self.performSegue(withIdentifier: "extprovidertoinfo", sender: nil)
                }
            }
        }
    }
    
    @IBAction func google(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {  [unowned self] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            
            // ...
            Auth.auth().signIn(with: credential){ [self]authResult, error in
                if let error = error{
                    print(error.localizedDescription)
                }
                
                //User signed in with google account,add user details to firestore database.
                else{
                    providerName = "google"
                    let userData = InitialViewController.getUserInfo(authResult: authResult!)
                    userId = authResult!.user.uid
                    if userData.email != "nil"{
                        self.userEmail = userData.email
                    }
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(userData.userId)
                    docRef.getDocument { document, error in
                        if document!.exists{
                            currentUserInfo = (document?.data())!
                        }
                        
                        else{
                            db.collection("users").document(userData.userId).setData(["email" : userData.email, "password" : "google password not stored to protect google account", "userId" : userData.userId, "name" : userData.name ]) {err in
                                if let err = err {
                                    print("Error writing document: \(err.localizedDescription)")
                                }
                                
                                else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                    
                }
                
                //print(currentUserInfo)
                self.performSegue(withIdentifier: "extprovidertoinfo", sender: nil)
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func apple(_ sender: Any) {
    }
    
    
    //MARK: SEGUE METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "extprovidertoinfo"){
            let ViewController = segue.destination as! GetinfoIViewController
            if let email = userEmail{
                ViewController.email = email
                ViewController.userID = userId
                
            }
            
            else{
                ViewController.userID = userId
            }
        }
        
    }
    
    
    //MARK: MY METHOD
    
    public static func getUserInfo(authResult: AuthDataResult) -> userInfo {
        //print(authResult.user.providerData[0])
        let userData = userInfo(name: authResult.user.displayName ?? "", email: authResult.user.email ?? "nil", userId: authResult.user.uid, photoUrl: authResult.user.providerData[0].photoURL ,phoneNumber: authResult.user.providerData[0].phoneNumber ?? " ", providerID: authResult.user.providerID)
        
        return userData
    }
    
    
    @IBAction func unwindToinitial(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
}

struct userInfo {
    let name : String
    let email : String
    let userId : String
    let photoUrl : URL?
    let phoneNumber : String?
    let providerID : String?
}



