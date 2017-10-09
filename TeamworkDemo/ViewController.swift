//
//  ViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var projects : Array<TWProject> = []
    
    /** Our Views **/
    var tableView = UITableView()
    
    
    let userProfilePhoto : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 33 //needs to be half of the size of the view for "round"
        view.layer.masksToBounds = true //puts the corner radius into effect
        view.contentMode = .center
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Teamwork Demo"
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        navigationController?.navigationBar.isTranslucent = false
        
        setupViews()
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
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.projectsLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self.view.snp.bottom)
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
    }
    
    /** DOWNLOAD PROJECTS **/
    
    private func downloadProjects()
    {
        ApiConfig.shared.projectsForUser { (projects, bool) in
            if(bool){
                print("projects returned")
                self.projects = projects!
                self.tableView.reloadData()
            } else {
                print("No projects available")
            }
        }
    }
}

