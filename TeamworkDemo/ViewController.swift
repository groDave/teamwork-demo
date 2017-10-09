//
//  ViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var projects : Array<TWProject> = []
    
    /** Our Views **/
    var tableView = UITableView()
    
    
    let userProfilePhoto : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 33 //needs to be half of the size of the view for "round"
        view.layer.masksToBounds = true //puts the corner radius into effect
        view.contentMode = .scaleAspectFit
        view.image = UIImage (named: "placeholder.png")
        return view
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let projectsLabel : UILabel = {
        let label = UILabel()
        label.text = "Projects"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let logoutButton : UIButton =
    {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Teamwork Demo"
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        navigationController?.navigationBar.isTranslucent = false
        
        setupViews()
        addUserDetails()
        downloadProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** SETUP VIEWS **/
    
    private func setupViews()
    {
        self.view.addSubview(userProfilePhoto)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(projectsLabel)
        self.view.addSubview(logoutButton)
        
        userProfilePhoto.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(10)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userProfilePhoto.snp.bottom).offset(5)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            make.height.equalTo(30)
        }
        
        projectsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            make.height.equalTo(30)
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-40)
            make.height.equalTo(40)
        }
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.projectsLabel.snp.bottom).offset(5)
            make.bottom.equalTo(logoutButton.snp.top).offset(-10)
        }
        
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: "ProjectCell")
    }
    
    /** TABLE VIEW DELEGATES **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count > 0 ? projects.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectTableViewCell
        cell.twProject = projects[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Tapped with indexPath = \(indexPath)")
        
        let vc = ProjectDetailViewController()
        vc.twProject = projects[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /** USER DETAILS **/
    
    private func addUserDetails()
    {
        RealmManager.shared.user { (user, bool) in
            if(bool){
                self.userProfilePhoto.sd_setImage(with: URL(string: user!.avatarUrl), placeholderImage: UIImage(named: "placeholder.png"))
                self.userNameLabel.text = user!.firstName + " " + user!.lastname
            }
        }
    }
    
    /** DOWNLOAD PROJECTS **/
    
    private func downloadProjects()
    {
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
        
        ApiConfig.shared.projectsForUser { (projects, bool) in
            indicator.stopAnimating()
            if(bool){
                print("projects returned")
                self.projects = projects!
                self.tableView.reloadData()
            } else {
                print("No projects available")
            }
        }
    }
    
    /** LOGOUT **/
    
    func logout()
    {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout? Don't worry - all your data is stored on our servers", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            RealmManager.shared.logout { (bool) in
                if(bool){
                    print("Successful logout")
                    let nav = UINavigationController()
                    let mainVC = LoginViewController()
                    nav.viewControllers = [mainVC]
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.window?.rootViewController = nav
                } else {
                    print("Something went wrong logging out")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
                print("Cancel")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {}
    }
}

