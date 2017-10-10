//
//  ProjectDetailViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 09/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var twProject : TWProject?
    var tasks : Array<TWTask> = []
    var tableView = UITableView()
    
    let projectAvatar : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 33 //needs to be half of the size of the view for "round"
        view.layer.masksToBounds = true //puts the corner radius into effect
        view.image = UIImage (named: "placeholder.png")
        return view
    }()
    
    let taskTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Project Tasklist"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let noTasksLabel : UILabel = {
        let label = UILabel()
        label.text = "This project currently has no tasks.\n You're on top of things!"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = twProject?.name
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        navigationController?.navigationBar.isTranslucent = false
        
        
        setupViews()
        downloadTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews()
    {
        self.view.addSubview(projectAvatar)
        self.view.addSubview(taskTitleLabel)
        self.view.addSubview(noTasksLabel)
        
        projectAvatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(10)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        projectAvatar.sd_setImage(with: URL(string: (twProject?.logoUrl)!), placeholderImage: UIImage(named: "placeholder.png"))
        
        taskTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(projectAvatar.snp.bottom).offset(5)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            make.height.equalTo(30)
        }
        
        noTasksLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            make.height.equalTo(50)
        }
        noTasksLabel.isHidden = true
        
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.taskTitleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
    }
    
    
    /** TABLE VIEW DELEGATES **/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count > 0 ? tasks.count : 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        cell.task = tasks[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    /** DOWNLOAD TASKS **/
    
    private func downloadTasks()
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
        
        ApiConfig.shared.downloadTasks(projectID: (twProject?.id)!) { (tasks, bool) in
            indicator.stopAnimating()
            if(bool){
                print("tasks returned")
                
                self.tableView.isHidden = false
                self.noTasksLabel.isHidden = true
                
                self.tasks = tasks!
                self.tableView.reloadData()
            } else {
                print("no tasks - display no tasks view")
                self.tableView.isHidden = true
                self.noTasksLabel.isHidden = false
            }
        }
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
