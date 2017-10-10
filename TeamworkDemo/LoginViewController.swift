//
//  LoginViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import SnapKit


class LoginViewController: UIViewController {
    
    /** Our Views **/
    
    let logoView : UIImageView =
    {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = UIImage (named: "teamworklogo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let textFieldEmail : UITextField =
    {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor.white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "Api Key"
        return textField
    }()
    
    let buttonAPIKey : UIButton =
    {
        let button = UIButton()
        button.setTitle("Demo API Key", for: .normal)
        button.backgroundColor = UIColor.hexToUIColor(hex: "#00e158")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let buttonLogin : UIButton =
    {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.hexToUIColor(hex: "#00e158")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    /**  **/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews()
    {
        self.view.addSubview(logoView)
        self.view.addSubview(textFieldEmail)
        self.view.addSubview(buttonAPIKey)
        self.view.addSubview(buttonLogin)
        
        //I use SnapKit for laying out my views: https://github.com/SnapKit/SnapKit
        
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(60)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(60)
        }
        
        textFieldEmail.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.centerY.equalTo(self.view.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        textFieldEmail.setLeftPaddingPoints(10)
        
        buttonAPIKey.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(textFieldEmail.snp.bottom).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        buttonAPIKey.addTarget(self, action: #selector(generateApiKey), for: .touchUpInside)
        
        buttonLogin.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(buttonAPIKey.snp.bottom).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        buttonLogin.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    /** LOGIN **/
    
    func login()
    {
        print("Logging user in")
        self.springButton(button: self.buttonLogin)
        
        if(textFieldEmail.text == ""){
            showSimpleAlert(message: "Oh no. You forgot to enter your API Key. If you don't have one and want to see the demo - just tap Demo API Key")
            return
        }
        
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x:0.0, y:0.0, width:60.0, height:60.0);
        indicator.center = view.center
        indicator.color = UIColor.white
        indicator.backgroundColor = UIColor.gray
        indicator.layer.cornerRadius = 5
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
        
        ApiConfig.shared.authUser(input: textFieldEmail.text!) { (bool) in
            indicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if(bool){
                let nav = UINavigationController()
                let mainVC = ViewController()
                nav.viewControllers = [mainVC]
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = nav
            } else {
                //show error message
                self.showSimpleAlert(message: "Seems your API Key was incorrect. Try again, and if the problem persists contact support@teamwork.com!")
            }
        }
    }
    
    /** GENERATE API KEY **/
    
    func generateApiKey()
    {
        self.springButton(button: self.buttonAPIKey)
        textFieldEmail.text = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"
    }
    
    /** BUTTON ANIM **/
    
    private func springButton(button: UIButton){
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        button.transform = .identity
            },
                       completion: nil)
    
    }
    
    /** SIMPLE ALERT **/
    
    private func showSimpleAlert(message: String){
        let alertController = UIAlertController(title: "Woops!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
