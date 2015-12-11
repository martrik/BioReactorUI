//
//  ViewController.swift
//  BioreactorController
//
//  Created by Martí Serra Vivancos on 05/12/15.
//  Copyright © 2015 MartiSerra. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, ORSSerialPortDelegate {

    @IBOutlet weak var currentLabel: NSTextField!
    
    @IBOutlet weak var desiredField: NSTextField!
    
    @IBOutlet weak var statusLabel: NSTextField!
   
    
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
            
            if valueArray[0] == "R" {
                currentLabel.stringValue = valueArray[1]
            }
            
        } else {
            inputValue = "\(inputValue)\(NSString(data:data, encoding:NSUTF8StringEncoding)!)"
        }
    }
    
    @IBAction func setNewDesiredValues(sender: AnyObject) {
        desiredField.resignFirstResponder()
        
        let data = desiredField.stringValue.dataUsingEncoding(NSUTF16StringEncoding)
        
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

