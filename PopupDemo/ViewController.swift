//
//  ViewController.swift
//  PopupDemo
//
//  Created by Lucifer on 03/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var popUpButton: UIButton!
    
    
    // MARK: - Declaration
    private var pickerView: UIPickerView?
    private let toolBar = UIToolbar()
    private var alertController = UIAlertController()

    
    var selectedBuildingValue : String = "001"
    var selectedRoomValue : String = "000"
    var flag = 1
    var buildingList = ["100", "200", "300", "400", "500"]
    var roomList = ["000", "001", "002", "003", "004"]
    var isFreeHand : Bool = false
    
    // MARK: - Setup view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Setup view
    func setupView() {
        
    }

    // MARK: - IBAction
    @IBAction func popUpButtonPressed(_ sender: Any) {
        self.isFreeHand = false
        self.flag = 1
        selectedBuildingValue = "001"
        selectedRoomValue = "000"
        self.opemAlert()
    }
    
    @objc private func doneClick() {
        
        self.isFreeHand = false
        self.pickerView?.isHidden = true
        self.toolBar.isHidden = true
        self.alertController.textFields?[0].resignFirstResponder()
        
    }
    
    @objc func selectBuilding() {
        self.isFreeHand = false
        self.toolBar.isHidden = false
        self.pickerView?.isHidden = false
        self.flag = 1
        pickerView?.reloadAllComponents()
        
        self.alertController.textFields?[0].resignFirstResponder()
        self.alertController.textFields?[0].inputView = nil
        self.alertController.textFields?[0].becomeFirstResponder()
    }

    @objc func selectRooms() {
        self.isFreeHand = false
        self.toolBar.isHidden = false
        self.pickerView?.isHidden = false
        self.flag = 2
        pickerView?.reloadAllComponents()
    
        self.alertController.textFields?[0].resignFirstResponder()
        
        self.alertController.textFields?[0].inputView = nil
        self.alertController.textFields?[0].becomeFirstResponder()
    }

    
    @objc private func freehandClick() {
        self.isFreeHand = true
        self.alertController.textFields?[0].resignFirstResponder()
        
        self.alertController.textFields?[0].inputView = nil
        self.alertController.textFields?[0].becomeFirstResponder()

    }
    
    
    // MARK: - Other function
    func opemAlert() {
        self.alertController = UIAlertController(title: "Enter Building / Room", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Building# / Room"
            textField.delegate = self
        
        }
        
        let addNotes = UIAlertAction(title: "Add Notes", style: .default) { (_) in
            print("Add notes")
        }
        
        let selectedBuildingRoom = UIAlertAction(title: "Select/Ch Building-Room", style: .default) { (_) in
            print("Add notes")
        }
        
        let savebutton = UIAlertAction(title: "Save", style: .default) { (_) in
            if let txtField = self.alertController.textFields?.first, let text = txtField.text {
                self.popUpButton.setTitle(text, for: .normal)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addNotes)
        alertController.addAction(selectedBuildingRoom)
        alertController.addAction(savebutton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setPickerView(with textStrg: String?) -> UIPickerView {
        // PickerView
        pickerView = UIPickerView()
        pickerView = UIPickerView(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: UIScreen.main.bounds.width * 0.7))
        pickerView?.backgroundColor = UIColor.white

        // ToolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let buildingButton = UIBarButtonItem(title: "Building", style: .plain, target: self, action: #selector(selectBuilding))
        let roomsButton = UIBarButtonItem(title: "Rooms", style: .plain, target: self, action: #selector(selectRooms))
        let freehandButton = UIBarButtonItem(title: "Free-hand", style: .plain, target: self, action: #selector(freehandClick))
        toolBar.setItems([doneButton, buildingButton, roomsButton, freehandButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.toolBar.isHidden = false
        return pickerView!
    }
}


// MARK: - picker delegate and datasource method
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flag == 1 ? buildingList.count : roomList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if flag == 1 {
            return buildingList[row]
        }
        if flag == 2 {
            return roomList[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if flag == 1 {
            self.selectedBuildingValue = buildingList[row]
            alertController.textFields?[0].text = buildingList[row]

        }
        if flag == 2 {
            self.selectedRoomValue = roomList[row]
            alertController.textFields?[0].text = roomList[row]
        }
        alertController.textFields?[0].text = self.selectedBuildingValue + "/" + self.selectedRoomValue
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

// MARK: - Textfield delegate
extension ViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isFreeHand {
            textField.inputView = nil
            textField.inputView = self.setPickerView(with: textField.text)
            pickerView!.delegate = self
            pickerView!.dataSource = self
            textField.inputAccessoryView = self.toolBar
        }
        
    }
}
