//
//  ViewController.swift
//  BioreactorController
//
//  Created by Martí Serra Vivancos on 05/12/15.
//  Copyright © 2015 MartiSerra. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, ORSSerialPortDelegate {

    @IBOutlet weak var currentTempLabel: NSTextField!
    @IBOutlet weak var currentPhLabel: NSTextField!
    @IBOutlet weak var currentStirringLabel: NSTextField!
    
    @IBOutlet weak var desiredTempField: NSTextField!
    @IBOutlet weak var desiredPhField: NSTextField!
    @IBOutlet weak var desiredStirringField: NSTextField!
    
    @IBOutlet weak var statusTempLabel: NSTextField!
    @IBOutlet weak var statusPhLabel: NSTextField!
    @IBOutlet weak var statusStirringLabel: NSTextField!
    
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()

    
    var serialPort: ORSSerialPort?
    
    var inputValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        serialPort = ORSSerialPort(path: "/dev/tty.uart-84FF49F37B4E051B")
        serialPort!.baudRate = 9600
        serialPort!.delegate = self
        serialPort!.open()
        
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        print("Serial port was lost: \(serialPort)")
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port was opened: \(serialPort)")
    }
    
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        if (NSString(data:data, encoding:NSUTF8StringEncoding) == "\n") {
            
            var valueArray = inputValue.characters.split{$0 == " "}.map(String.init)
            inputValue = ""
            
            switch valueArray[0] {
            case "RT":
                currentTempLabel.stringValue = valueArray[1]
                break
            
            case "RP":
                currentPhLabel.stringValue = valueArray[1]
                break
            case "RS":
                currentStirringLabel.stringValue = valueArray[1]
                break
                
            default:
                print(valueArray[0])
                break
            }
            
        } else {
            inputValue = "\(inputValue)\(NSString(data:data, encoding:NSUTF8StringEncoding)!)"
        }
    }
    
    @IBAction func setNewDesiredValues(sender: AnyObject) {
        desiredPhField.resignFirstResponder()
        desiredTempField.resignFirstResponder()
        desiredStirringField.resignFirstResponder()
        
        let data = desiredTempField.stringValue.dataUsingEncoding(NSUTF16StringEncoding)
        
        if let data = data {
           // print(data)
            serialPort!.sendData(data)
        }
    }
    
    

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

