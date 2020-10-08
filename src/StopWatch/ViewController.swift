//
//  ViewController.swift
//  StopWatch
//
//  Created by Reece Carolan on 1/12/20.
//  Copyright © 2020 HelloStudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let timeLabel = UILabel()
    let secondsLabel = UILabel()
    let startStopButton = UIButton()
    var lapResetButton = UIButton()
    
    var methodStart = Date()
    var timer = Timer()
    var exTime: TimeInterval!
    var prevTime = 0.0
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var tableView = UITableView()
    
    var lapsTotal: [Double] = []
    var lapsPrev: [Double] = []
    
    enum unitTypes {
        case seconds
        case minutes
        case hours
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var unitType = unitTypes.seconds
    
    func buildView() {
        UserDefaults.standard.set(false, forKey: "isRunning")
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        
        var topBuffer = 30
        var timeBGHeight = 120
        var lapHeight = 180
        var timeFontSize = 64
        
        print(screenSize.height)
        
        //1080 is iPad 7
        
        if screenSize.height >= 1024 { //iPad Pro 9.7
            topBuffer = 120
            timeBGHeight = 130
            lapHeight = 350
            timeFontSize = 72
        } else if screenSize.height >= 812 { //iPhone 11 Pro
            topBuffer = 80
            timeBGHeight = 130
            lapHeight = 230
            timeFontSize = 72
        }
        
        let timerBG = UIView(frame: CGRect(x: 0, y: topBuffer, width: Int(screenSize.width), height: timeBGHeight))
        timerBG.backgroundColor = UIColor.systemBackground
        timerBG.layer.borderWidth = 0.5
        timerBG.layer.borderColor = UIColor.separator.cgColor
        self.view.addSubview(timerBG)
        
        
        
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(timeFontSize), weight: .medium)
        timeLabel.textColor = UIColor.label
        timeLabel.text = "00:00:00"
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: timeLabel.frame.size.height)
        timeLabel.center.x = timerBG.center.x
        timerBG.addSubview(timeLabel)
        
        secondsLabel.textAlignment = .center
        secondsLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .regular)
        secondsLabel.textColor = UIColor.secondaryLabel
        secondsLabel.text = "0.000000"
        secondsLabel.sizeToFit()
        secondsLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: secondsLabel.frame.size.height)
        secondsLabel.center.x = timerBG.center.x
        timerBG.addSubview(secondsLabel)
        
        let labelHeight = timeLabel.frame.size.height + secondsLabel.frame.size.height
        
        timeLabel.center.y = (timerBG.frame.size.height - labelHeight) / 2 + (timeLabel.frame.size.height / 2)
        secondsLabel.center.y = timeLabel.frame.origin.y + timeLabel.frame.size.height + (secondsLabel.frame.size.height / 2)
        
        
        
        let units = ["Seconds" , "Minutes", "Hours"]
        let unitSegment = UISegmentedControl(items: units)
        unitSegment.center = CGPoint(x: self.view.center.x, y: timerBG.frame.origin.y + timerBG.frame.size.height + (unitSegment.frame.size.height/2) + 20)
        unitSegment.selectedSegmentIndex = 0
        unitSegment.addTarget(self, action: #selector(unitsChanged(sender:)), for: .valueChanged)

        self.view.addSubview(unitSegment)
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: Int(unitSegment.frame.origin.y + unitSegment.frame.size.height + 20), width: Int(screenSize.width), height: lapHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.separator.cgColor
        tableView.dataSource=self
        tableView.delegate=self
        tableView.reloadData()
        
        self.view.addSubview(tableView)
        
        let lapOptions = ["Total Time" , "Lap Time"]
        let lapSegment = UISegmentedControl(items: lapOptions)
        lapSegment.center = CGPoint(x: self.view.center.x, y: tableView.frame.origin.y + tableView.frame.size.height + (unitSegment.frame.size.height/2) + 20)
        lapSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "lapIndex")
        lapSegment.addTarget(self, action: #selector(lapOptionChanged(sender:)), for: .valueChanged)

        self.view.addSubview(lapSegment)
        
        
        
        lapResetButton = UIButton(type: .system)
        lapResetButton.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        lapResetButton.setTitle("Add Lap", for: .normal)
        lapResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        lapResetButton.addTarget(self, action: #selector(lapReset), for: .touchUpInside)
        lapResetButton.center = CGPoint(x: self.view.center.x, y: lapSegment.frame.origin.y + lapSegment.frame.size.height + (lapResetButton.frame.size.height/2))
        lapResetButton.isHidden = true
        
        self.view.addSubview(lapResetButton)
        
        
        
        startStopButton.backgroundColor = UIColor.systemGray5
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(UIColor.label, for: .normal)
        startStopButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        startStopButton.addTarget(self, action: #selector(startStop), for: .touchUpInside)

        self.view.addSubview(startStopButton)
        
        startStopButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        startStopButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    @objc func unitsChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                unitType = unitTypes.seconds
            case 1:
                unitType = unitTypes.minutes
            case 2:
                unitType = unitTypes.hours
            default:
                break
            }
        if UserDefaults.standard.bool(forKey: "isRunning") {
            updateLabelsForSeconds(time: exTime)
        }
    }
    
    @objc func lapOptionChanged(sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "lapIndex")
        
        tableView.reloadData()
    }
    
    @objc func startStop(sender: UIButton!) {
        let isRunning = UserDefaults.standard.bool(forKey: "isRunning")
        
        if isRunning == true {
            stop()
        } else {
            lapResetButton.isHidden = false
            start()
        }
    }
    
    @objc func lapReset(sender: UIButton!) {
        let isRunning = UserDefaults.standard.bool(forKey: "isRunning")
        
        if (isRunning) {
            addLap()
        } else {
            reset()
        }
    }
    
    func reset() {
        secondsLabel.text = "0.000000"
        timeLabel.text = "00:00:00"
        
        lapResetButton.isHidden = true
        lapResetButton.setTitle("Add Lap", for: .normal)
        
        lapsTotal.removeAll()
        lapsPrev.removeAll()
        
        tableView.reloadData()
    }
    
    func addLap() {
        let time = getCurrentTime()
        lapsTotal.insert(time, at: 0)
        
        
        
        let timeDiff = time - prevTime
        lapsPrev.insert(timeDiff, at: 0)
        prevTime = time
        
        tableView.reloadData()
    }
    
    func start() {
        UserDefaults.standard.set(true, forKey: "isRunning")
        
        if secondsLabel.text == "0.000000" {
            methodStart = Date()
            prevTime = 0
        } else {
            methodStart = Date().addingTimeInterval(-1 * exTime)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.0166, target: self, selector: #selector(calculate), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        startStopButton.setTitle("Stop", for: .normal)
        lapResetButton.setTitle("Add Lap", for: .normal)
    }
    
    func stop() {
        UserDefaults.standard.set(false, forKey: "isRunning")
        
        timer.invalidate()
        
        updateLabelsForSeconds(time: getCurrentTime())
        
        startStopButton.setTitle("Start", for: .normal)
        lapResetButton.setTitle("Reset", for: .normal)
    }
    
    func updateLabelsForSeconds(time: Double) {
        if (unitType == unitTypes.seconds){
            secondsLabel.text = String(format: "%f", time)
        } else if (unitType == unitTypes.minutes){
            secondsLabel.text = String(format: "%f", time / 60)
        } else if (unitType == unitTypes.hours){
            secondsLabel.text = String(format: "%f", time / 3600)
        }
        
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: Int(time))
        
        timeLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
    }
    
    func getCurrentTime() -> Double {
        let methodFinish = Date()
        let executionTime: TimeInterval = methodFinish.timeIntervalSince(methodStart)
        exTime = executionTime
        
        return executionTime
    }
    
    @objc func calculate() {
        updateLabelsForSeconds(time: getCurrentTime())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
    }
    
    // MARK: Table Stuff
    // MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapsTotal.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        var lapString = NSMutableAttributedString()
        let lapIndex = UserDefaults.standard.integer(forKey: "lapIndex")
        
        if (lapIndex == 0) {
            let time = lapsTotal[indexPath.row]
            
            let seconds = time.truncatingRemainder(dividingBy: 60.0)
            let minutes: Int = (Int(time) / 60) % 60
            
            lapString = NSMutableAttributedString(string: String(format: "%02i.   %02i:%05.2f", lapsTotal.count - (indexPath.row), minutes, seconds))
        } else{
            let time = lapsPrev[indexPath.row]
            
            let seconds = time.truncatingRemainder(dividingBy: 60.0)
            let minutes: Int = (Int(time) / 60) % 60
            
            lapString = NSMutableAttributedString(string: String(format: "%02i.   %02i:%05.2f", lapsPrev.count - (indexPath.row), minutes, seconds))
        }
        
        let millisecondsRange = NSRange(location: (lapString.length) - 3, length: 3)
        let millisecondsColor = [ NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel ]
        lapString.addAttributes(millisecondsColor, range: millisecondsRange)
        
        let lapRange = NSRange(location: 0, length: 3)
        let lapColor = [ NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel ]
        let lapFont = [ NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .heavy) ]
        lapString.addAttributes(lapColor, range: lapRange)
        lapString.addAttributes(lapFont, range: lapRange)
        
        cell.textLabel?.textColor = UIColor.label
        cell.textLabel!.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        cell.textLabel!.attributedText = lapString
        
        return cell
    }
}
