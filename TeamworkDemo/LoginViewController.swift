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
        textField.placeholder = "Email Address or Api Key"
        return textField
    }()
    
    let textFieldPassword : UITextField =
    {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Password"
        return textField
    }()
    
    let buttonLogin : UIButton =
    {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.green
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

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
        self.view.addSubview(textFieldEmail)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(buttonLogin)
        
        //I use SnapKit for laying out my views: https://github.com/SnapKit/SnapKit
        
        textFieldEmail.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.view.snp.top).offset(60)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        
        textFieldPassword.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(textFieldEmail.snp.bottom).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        
        buttonLogin.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(textFieldPassword.snp.bottom).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(45)
        }
        buttonLogin.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    /** LOGIN **/
    func login()
    {
        print("Logging user in")
        buttonLogin.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.buttonLogin.transform = .identity
            },
                       completion: nil)
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
