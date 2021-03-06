//
//  GraphViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 29/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit
import CoreMotion

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var tableView: UITableView!
    
    let homeModel = HomeSettingsModel()
    let motionKit = MotionKit()
    let sensorModel = SensorModel()
    
    var udpClientCloud = Client(type: 1)
    var tcpClientCloud = TCPClient(type: 1)

    let bigFont = Styles.bigFont
    
    @IBOutlet weak var sensorChangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var measurementButton: LocalizedButton!
    @IBOutlet weak var startButton: LocalizedButton!
    @IBOutlet weak var selectedSensorLabel: LocalizedLabel!
    
    fileprivate var sample = 0
    fileprivate var lan = false
    
    var sampleCount:Int{
        get{
            return sample
        }
        set{
            if GlobalVariables.speed <= 0.01{
                sample = newValue % 15
            }else if GlobalVariables.speed < 0.1{
                sample = newValue % 3
            }else{
                sample = 0
            }
            
        }
    }
    
    var selectedSensorToShow:Int{
        get{
            if let selectedSensor = UserDefaults.standard.integer(forKey: "selectedSensor") as Int?{
                return selectedSensor
            }else{
                UserDefaults.standard.set(0, forKey: "selectedSensor")
                UserDefaults.standard.synchronize()
                return 0
            }
        }
        set{
            self.graphView.changeData(sensorModel.graphPoints[newValue])
            UserDefaults.standard.set(newValue, forKey: "selectedSensor")
            UserDefaults.standard.synchronize()
            
        }
    }
    @IBAction func createNewMeasurement(_ sender: Any) {
        if (self.sensorModel.sendingStatus == 0) {
            MeasurementClient().createMeasurement { (Status, Result) in
                if (Status) {
                    self.sensorModel.sendingStatus = 1
                    let title = self.sensorModel.sendingText

                    self.measurementButton.setTitle(title, for: UIControl.State())
                    self.measurementButton.backgroundColor = self.sensorModel.backgroubdColor
                    if let data: NSDictionary = Result {
                        print(data)
                        GlobalVariables.MeasurementID = data.object(forKey: "MeasurementID") as! Int
                    }
                    
                }
            }
        } else {
            self.sensorModel.sendingStatus = 0
            MeasurementClient().updateMeasurement { (status, result) in
                DispatchQueue.main.async{[unowned self] in
                    self.measurementButton.setTitle(self.sensorModel.sendingText, for: UIControl.State())
                    self.measurementButton.backgroundColor = self.sensorModel.backgroubdColor
                }
                
            }
            
            
        }
    }
    
 
    @IBAction func tapped(_ sender: Any) {
        if lan{
            //            Send udp csv
            sensorModel.sendingStatus = (sensorModel.sendingStatus + 1) % 2
            
        }else{
            if GlobalVariables.loggedIn{
                sensorModel.sendingStatus = (sensorModel.sendingStatus + 1) % 2
                
                if sensorModel.sendingStatus == 1 && homeModel.reachable{
                    if homeModel.celular{
                        //                        alert
//                        cellularAlert()
                    }else{
                        
//                        HTTPManager().startSendingUDPData()
                        
                    }
                }else{
                    //                    Show popup to add measure description
//                    alertDescription("Description", message: "Add your message")
                    //                    HTTPManager().stopSendngUDPData()
                }
            }else if sensorModel.sendingStatus == 0 && !homeModel.reachable{ //if status is not sending -> change it to sending and create a new measure
//                lvOfflineManager.newMeasure()
                sensorModel.sendingStatus = (sensorModel.sendingStatus + 1) % 2
                
            }else if sensorModel.sendingStatus == 1 && !homeModel.reachable{
//                offlineManager.updateMeasure()
                sensorModel.sendingStatus = (sensorModel.sendingStatus + 1) % 2
            }else{
                alert(message:NSLocalizedString("You are not logged in", comment: ""), actions:[self.login], titles: ["login"])
            }
        }
        
//        startButton.setTitle(sensorModel.sendingText, for: UIControlState())
//        startButton.backgroundColor = sensorModel.backgroubdColor
        
    }
    
    func login(action: UIAlertAction){
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    func logout(action: UIAlertAction){
        UserClient().logout()
    }
    
    @IBAction func sensorIndexWasChanged(_ sender: AnyObject) {
        selectedSensorToShow = sensorChangeSegmentControl.selectedSegmentIndex
        selectedSensorLabel.text = sensorModel.getName(sensorChangeSegmentControl.selectedSegmentIndex)
        
    }
    
    func alert(message:String, actions:Array<((UIAlertAction) -> Void)>, titles: Array<String>){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        for (index, title) in titles.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: actions[index]))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getRawAcceleration(){
        var time = ""
        var acc:NSDictionary = NSDictionary()
        motionKit.getAccelerometerValues(interval: GlobalVariables.speed) {
            (x, y, z) in
            time = "\(Date().timeIntervalSince1970)"

            acc = ["x": x, "y": y, "z": z, "time":"\(time)",  "sensor": 4 ]
            
            self.sampleCount = self.sampleCount + 1
           
            self.graphView.maxValue = self.sensorModel.maxValues[4]
            
            if self.selectedSensorToShow == 4{
                if self.sampleCount == 0{
                
                    self.graphView.addPoint(x, y: y, z: z)
                    DispatchQueue.main.async{[unowned self] in
                        self.graphView.setNeedsDisplay()
                    }
                    
                }
            }
            
            
        }
    }
    
    func getSensorsData(){
        self.sampleCount = 0
        var acc:NSDictionary = NSDictionary()
        var gyro:NSDictionary = NSDictionary()
        var grav:NSDictionary = NSDictionary()
        var mag:NSDictionary = NSDictionary()
        
        var data:NSArray = NSArray()
        
        var acceleration:CMAcceleration = CMAcceleration()
        var gravity:CMAcceleration = CMAcceleration()
        var rotation:CMRotationRate = CMRotationRate()
        var magnetometer:CMCalibratedMagneticField = CMCalibratedMagneticField()
        
        let freq = GlobalVariables.speed
        var dateSting = ""
        print("Freq \(freq)")
        self.motionKit.getDeviceMotionObject(interval: freq){
            (deviceMotion) -> () in
            
            self.sampleCount = self.sampleCount + 1
            
            dateSting = "\(NSDate().timeIntervalSince1970 * 1000)"
            acceleration = deviceMotion.userAcceleration
            gravity = deviceMotion.gravity
            rotation = deviceMotion.rotationRate
            magnetometer = deviceMotion.magneticField
            
            acc = [
                "x": acceleration.x,
                "y": acceleration.y,
                "z": acceleration.z,
                "timestamp":dateSting,
                "SensorID": 1,
                "measurement": GlobalVariables.MeasurementID,
                "ExperimentID": GlobalVariables.experiment,
                "DeviceID": 2,
                "Frequency": freq
            ]
            gyro = [
                "x": rotation.x,
                "y": rotation.y,
                "z": rotation.z,
                "timestamp":dateSting,
                "SensorID": 2,
                "measurement": GlobalVariables.MeasurementID,
                "ExperimentID": GlobalVariables.experiment,
                "DeviceID": 2,
                "Frequency": freq
            ]
            grav = [
                "x": gravity.x,
                "y": gravity.y,
                "z": gravity.z,
                "timestamp": dateSting,
                "SensorID": 3,
                "measurement": GlobalVariables.MeasurementID,
                "ExperimentID": GlobalVariables.experiment,
                "DeviceID": 2,
                "Frequency": freq
            ]
            mag = [
                "x": magnetometer.field.x,
                "y": magnetometer.field.y,
                "z": magnetometer.field.z,
                "timestamp": dateSting,
                "SensorID": 4,
                "measurement": GlobalVariables.MeasurementID,
                "ExperimentID": GlobalVariables.experiment,
                "DeviceID": 2,
                "Frequency": freq
            ]
            
            data = [acc,gyro,grav,mag]

            if self.sensorModel.sendingStatus == 1{
                    if  GlobalVariables.loggedIn {
                        if GlobalVariables.cloudProtocol == "UDP" {
                            for i in 0 ..< data.count{
                                self.udpClientCloud.send(data[i] as! NSDictionary )
                            }
                        }else{
                            self.tcpClientCloud.sendArray(data)
                        }
                    }
            }
            
            if self.sampleCount == 0{
                self.sensorModel.addPoint([[acc["x"] as! Double, acc["y"] as! Double, acc["z"] as! Double],[gyro["x"] as! Double, gyro["y"] as! Double, gyro["z"] as! Double],[grav["x"] as! Double,  grav["y"] as! Double, grav["z"] as! Double],[mag["x"] as! Double,  mag["y"] as! Double, mag["z"] as! Double]])
                //                    Graph
                self.graphView.maxValue = self.sensorModel.maxValues[self.selectedSensorToShow]
                switch self.selectedSensorToShow{
                case 0:
                    self.graphView.addPoint((acc["x"] as! Double?)!, y: (acc["y"] as! Double?)!, z: (acc["z"] as! Double?)!)
                case 1:
                    self.graphView.addPoint((gyro["x"] as! Double?)!, y: (gyro["y"] as! Double?)!, z: (gyro["z"] as! Double?)!)
                case 2:
                    self.graphView.addPoint((grav["x"] as! Double?)!, y: (grav["y"] as! Double?)!, z: (grav["z"] as! Double?)!)
                case 3:
                    self.graphView.addPoint((mag["x"] as! Double?)!, y: (mag["y"] as! Double?)!, z: (mag["z"] as! Double?)!)
                default:
                    break
                }
                
                if self.selectedSensorToShow != 4{
                    DispatchQueue.main.async{[unowned self] in
                        self.graphView.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    func stopDeviceMotionUpdates(){
        motionKit.stopDeviceMotionUpdates()
    }
    
    func stopRawAccelerationUpdates(){
        motionKit.stopAccelerometerUpdates()
    }
    
    @objc func stopAllUpdates(){
        stopDeviceMotionUpdates()
        stopRawAccelerationUpdates()
    }
    
    func configureSegmentControl(){
        let sensors = sensorModel.getSensorsModel()
        var name = ""
        for  i in 0 ... sensors.count - 1{
            name = sensorModel.getName(i)
            sensorChangeSegmentControl.setTitle(name[0...2], forSegmentAt: i)
        }      
        sensorChangeSegmentControl.selectedSegmentIndex = selectedSensorToShow
        selectedSensorLabel.text = sensorModel.getName(selectedSensorToShow)
        selectedSensorLabel.font = bigFont
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(UINib(nibName: "HomeRightLabel", bundle: nil), forCellReuseIdentifier: "rightLabel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        configureSegmentControl()
        self.getRawAcceleration()
        self.getSensorsData()
        setNotifications()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        initButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initButtons() -> Void {
        measurementButton.setTitle(sensorModel.sendingText, for: UIControl.State())
    }

    func initNavigationBar() {
        self.navigationItem.title = NSLocalizedString("Home", comment: "")
    }
    
    @objc func reloadSettingsTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(GraphViewController.reloadSettingsTable), name: NSNotification.Name(rawValue: HomeModelChangedNotification), object: homeModel)

        NotificationCenter.default.addObserver(self, selector:#selector(GraphViewController.stopAllUpdates), name: UIApplication.willTerminateNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(GraphViewController.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
    }
    
    @objc func appDidBecomeActive(){
        
//        udpClientLocal = Client(type: 0)
        udpClientCloud = Client(type: 1)
        
        //         lvTCPClientLocal = TCPClient(type: 0)
        //         lvTCPClientCloud = TCPClient(type: 1)
        
        self.getRawAcceleration()
        self.getSensorsData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }

}
extension GraphViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return homeModel.getNumberOfSections()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeModel.getNumberOfRowsInSection(section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  HomeCell()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "rightLabel", for: indexPath) as! HomeCell
        cell.dataLabel.text = homeModel.getDataInRows((indexPath as NSIndexPath).section, row: (indexPath as NSIndexPath).row)
        let fonts = homeModel.setFontOfRow(indexPath)
        if fonts[0] is UIFont && fonts[1] is UIColor{
            cell.dataLabel.font = fonts[0] as? UIFont
            cell.dataLabel.textColor = fonts[1] as? UIColor
        }
        cell.accessoryType = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
extension GraphViewController: UITableViewDelegate {
    
    func tableViewLoginClicked(){
        if GlobalVariables.loggedIn{
            alert(message:NSLocalizedString("Do you want to logout?", comment: ""), actions:[self.logout, { action in }], titles: ["logout", "cancel"])
        }else{
            alert(message:NSLocalizedString("You are not logged in", comment: ""), actions:[self.login, { action in }], titles: ["login", "cancel"])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).row{
            
        case 0:
            tableViewLoginClicked()
        default: break
            
        }
        
        tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableView.RowAnimation.fade)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
