//
//  TripMeViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/11/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class TripMeViewController: UIViewController ,UITableViewDelegate {

    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var teble: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var viewIndicator: UIView!

    
    
    let location : Array<String> = ["Krung Thep Mahanakhon","Chainat" ,"Nakhon Sawan" ,"Nonthaburi" ,"Pathum Thani" ,"Ayutthaya","Lopburi","Samut Songkhram","Samut Prakan","Samut Sakhon","Saraburi","Singburi","Ang Thong","Uthai Thani","Kanchanaburi",    "Nakhon Pathom",    "Prachuap Khiri Khan",    "Phetchaburi",    "Ratchaburi",    "Suphanburi",    "Chanthaburi",    "Chachoengsao",    "Chonburi",    "Trat",    "Nakhon Nayok",    "Prachinburi",    "Rayong",    "Sa Kaeo",    "Kalasin",    "Khon Kaen",    "Chaiyaphum",    "Nakhon Phanom",    "Nakhon Ratchasima",    "Buriram",    "Maha Sarakham",    "Mukdahan",    "Yasothon",    "Roi Et",    "Loei",    "Si Sa Ket",    "Sakon Nakhon",    "Surin",    "Nong Khai",    "Nong Bua Lamphu",    "Amnat Charoen",    "Udon Thani",    "Ubon Ratchathani",    "Krabi",    "Chumphon",    "Trang",    "Nakhon Si Thammarat",    "Narathiwat",    "Pattani",    "Phangnga",    "Phatthalung",    "Phuket",    "Yala",    "Ranong",    "Songkhla",    "Satun",    "Surat Thani",    "Kamphaeng Phet",    "Chiang Rai",    "Chiang Mai",    "Tak",    "Nan",    "Phayao",    "Phichit",    "Phitsanulok",    "Phetchabun",    "Phrae",    "Mae Hong Son",    "Lampang",    "Lamphun",    "Sukhothai",    "Uttaradit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickTestRequest(sender: AnyObject) {
        
        var connect = Connection();
        connect.getCategoryTripsMe("phuket",place: 0)
    }
    
    @IBAction func clickSelectLocation(sender: AnyObject) {
        viewPicker.hidden = false
        
    }
    
    @IBAction func clickDonePicker(sender: AnyObject) {
        viewPicker.hidden = true
        
        viewIndicator.hidden = false
        // send request
    }

    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return location[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textLocation.text = location[row]
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
