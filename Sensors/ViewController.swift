//
//  ViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 08/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var subjectClient = ExperimentClient()
    var model = SubjectExperimentModel()
    
    var selectedRow = 0;
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableVewTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self 
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "normalCell")
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
        
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as! NormalCell
      
        cell.cellTitle?.text = model.getTitle(indexPath: indexPath)
        model.getDetails(indexPath: indexPath, completion: {
            result in
            cell.cellDetails?.text = result
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showSubjectDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let subjectExperementDetailsViewController = segue.destination as! SubjectExperementDetailsViewController
        
        // set a variable in the second view controller with the data to pass
        
        subjectExperementDetailsViewController.settingType = selectedRow
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

