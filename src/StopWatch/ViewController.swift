//
//  ViewController.swift
//  StopWatch
//
//  Created by Reece Carolan on 1/12/20.
//  Copyright © 2020 HelloStudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    ///Label responsible for displaying the main timer
    let primaryTimeLabel = UILabel()
    ///Label responsible for displaying the time relative to the units
    let secondaryTimeLabel = UILabel()
    ///Button that switches between starting and stopping the timer
    let startStopButton = UIButton()
    ///Button that switches between adding a lap and reseting the timer
    let lapResetButton = UIButton(type: .system)
    
    
    
    ///Date when the timer first began. Used to calculate the total time elapsed
    var methodStart = Date()
    ///Time responsible for refreshing the labels
    var timer = Timer()
    ///Total time elapsed since the time started, minus any time it was paused
    var exTime: TimeInterval!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    ///TableView responsible for displaying laps
    var lapsTableView = UITableView()
    ///Switcher for changing how the lap table displays data
    var lapSegment = UISegmentedControl()
    
    ///Array containing lap data. Every item is a double representing the total time elapsed since the timer began, while lap time is claculated from the same array.
    var lapsTotal: [Double] = []
    
    enum unitTypes {
        case seconds
        case minutes
        case hours
    }
    
    ///Units that the secondary time label should be displayed in
    var unitType = unitTypes.seconds
    ///Returns true if lap-related views are visible, and false if they are not
    var isLapViewVisible = false
}

extension ViewController {
    func buildView() {
        UserDefaults.standard.set(false, forKey: "isRunning")
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        
        var timeFontSize: CGFloat

        if UIDevice.current.userInterfaceIdiom == .pad {
            timeFontSize = 72
        } else {
            timeFontSize = 64
        }
        
        let timerBG = UIView()
        timerBG.backgroundColor = UIColor.systemBackground
        timerBG.layer.borderWidth = 0.5
        timerBG.layer.borderColor = UIColor.separator.cgColor
        view.addSubview(timerBG)
        timerBG.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        primaryTimeLabel.textAlignment = .center
        primaryTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeFontSize, weight: .medium)
        primaryTimeLabel.text = "00:00:00"
        primaryTimeLabel.textColor = UIColor.label
        timerBG.addSubview(primaryTimeLabel)
        primaryTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height * 0.05),
            primaryTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primaryTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        secondaryTimeLabel.textAlignment = .center
        secondaryTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .regular)
        secondaryTimeLabel.textColor = UIColor.secondaryLabel
        secondaryTimeLabel.text = "0.000000"
        timerBG.addSubview(secondaryTimeLabel)
        secondaryTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondaryTimeLabel.topAnchor.constraint(equalTo: primaryTimeLabel.bottomAnchor),
            secondaryTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondaryTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timerBG.topAnchor.constraint(equalTo: primaryTimeLabel.topAnchor, constant: -15),
            timerBG.bottomAnchor.constraint(equalTo: secondaryTimeLabel.bottomAnchor, constant: 15),
            timerBG.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerBG.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let units = ["Seconds" , "Minutes", "Hours"]
        let unitSegment = UISegmentedControl(items: units)
        unitSegment.selectedSegmentIndex = 0
        unitSegment.addTarget(self, action: #selector(unitsChanged(sender:)), for: .valueChanged)
        view.addSubview(unitSegment)
        unitSegment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unitSegment.topAnchor.constraint(equalTo: timerBG.bottomAnchor, constant: 20),
            unitSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        
        lapsTableView = UITableView()
        lapsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        lapsTableView.layer.borderWidth = 0.5
        lapsTableView.layer.borderColor = UIColor.separator.cgColor
        lapsTableView.dataSource=self
        lapsTableView.delegate=self
        view.addSubview(lapsTableView)
        lapsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lapsTableView.topAnchor.constraint(greaterThanOrEqualTo: unitSegment.bottomAnchor, constant: 20),
            lapsTableView.topAnchor.constraint(lessThanOrEqualTo: unitSegment.bottomAnchor, constant: 120),
            lapsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            lapsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        lapsTableView.alpha = 0
        
        let lapOptions = ["Total Time" , "Lap Time"]
        lapSegment = UISegmentedControl(items: lapOptions)
        lapSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "lapIndex")
        lapSegment.addTarget(self, action: #selector(lapOptionChanged(sender:)), for: .valueChanged)
        
        view.addSubview(lapSegment)
        lapSegment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lapSegment.topAnchor.constraint(equalTo: lapsTableView.bottomAnchor, constant: 20),
            lapSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        lapSegment.alpha = 0
        
        
        
        lapResetButton.setTitle("Add Lap", for: .normal)
        lapResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        lapResetButton.addTarget(self, action: #selector(lapReset), for: .touchUpInside)
        lapResetButton.isHidden = true
        
        view.addSubview(lapResetButton)
        lapResetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lapResetButton.topAnchor.constraint(equalTo: lapSegment.bottomAnchor, constant: 20),
            lapResetButton.heightAnchor.constraint(equalToConstant: 50),
            lapResetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapResetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
        startStopButton.backgroundColor = UIColor.systemGray5
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(UIColor.label, for: .normal)
        startStopButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        startStopButton.addTarget(self, action: #selector(startStop), for: .touchUpInside)

        view.addSubview(startStopButton)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startStopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startStopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        //Constraints responsible for squishing the button height down as necessary
        let c1 = startStopButton.topAnchor.constraint(greaterThanOrEqualTo: lapResetButton.bottomAnchor, constant: 20)
        c1.priority = .defaultHigh
        c1.isActive = true
        let c2 = startStopButton.heightAnchor.constraint(equalToConstant: 200)
        c2.priority = .defaultHigh
        c2.isActive = true
        let c3 = startStopButton.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        c3.priority = .defaultLow
        c3.isActive = true
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
        
        lapsTableView.reloadData()
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
        secondaryTimeLabel.text = "0.000000"
        primaryTimeLabel.text = "00:00:00"
        
        lapResetButton.isHidden = true
        lapResetButton.setTitle("Add Lap", for: .normal)
        
        lapsTotal.removeAll()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.lapsTableView.alpha = 0.0
            self.lapSegment.alpha = 0.0
        })
        
        lapsTableView.reloadData()
    }
    
    func addLap() {
        if !isLapViewVisible {
            UIView.animate(withDuration: 0.3, animations: {
                self.lapsTableView.alpha = 1.0
                self.lapSegment.alpha = 1.0
            })
        }
        
        let time = getCurrentTime()
        lapsTotal.insert(time, at: 0)
        
        lapsTableView.reloadData()
    }
    
    func start() {
        UserDefaults.standard.set(true, forKey: "isRunning")
        
        if secondaryTimeLabel.text == "0.000000" {
            methodStart = Date()
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
            secondaryTimeLabel.text = String(format: "%f", time)
        } else if (unitType == unitTypes.minutes){
            secondaryTimeLabel.text = String(format: "%f", time / 60)
        } else if (unitType == unitTypes.hours){
            secondaryTimeLabel.text = String(format: "%f", time / 3600)
        }
        
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: Int(time))
        
        primaryTimeLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapsTotal.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let lapIndex = UserDefaults.standard.integer(forKey: "lapIndex")
        var time: Double
        
        if (lapIndex == 0) {
            time = lapsTotal[indexPath.row]
        } else{
            if indexPath.row < (lapsTotal.count - 1) {
                time = lapsTotal[indexPath.row] - lapsTotal[indexPath.row + 1]
            } else {
                time = lapsTotal[indexPath.row]
            }
        }
        
        let seconds = time.truncatingRemainder(dividingBy: 60.0)
        let minutes: Int = (Int(time) / 60) % 60
        
        let lapString = NSMutableAttributedString(string: String(format: "%02i.   %02i:%05.2f", lapsTotal.count - (indexPath.row), minutes, seconds))
        
        
        
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
