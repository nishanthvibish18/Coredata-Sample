//
//  ViewController.swift
//  CoredataSample
//
//  Created by Nishanth on 09/07/24.
//

import UIKit

class ViewController: UIViewController {

    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var studentDetails = [StudentDetails]()
    
    @IBOutlet weak var studentMarkTextFld: UITextField!
    @IBOutlet weak var studentAgeTxtFld: UITextField!
    @IBOutlet weak var studentDepartmentTextField: UITextField!
    @IBOutlet weak var studentRollNumberTextField: UITextField!
    @IBOutlet weak var studentnameTextFld: UITextField!
    @IBOutlet weak var studentListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
   
        let studetnDetails = StudentDetails(context: appContext)
        studetnDetails.name = self.studentnameTextFld.text
        studetnDetails.age = self.studentAgeTxtFld.text
        studetnDetails.rollnumber = self.studentRollNumberTextField.text
        studetnDetails.department = self.studentDepartmentTextField.text
        studetnDetails.marks = self.studentMarkTextFld.text
        saveData(studentDetails: studetnDetails)
    }
    
    
   
}
extension ViewController{
    func loadData(){
        do{
            self.studentDetails = try appContext.fetch(StudentDetails.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.studentnameTextFld.text = ""
                 self.studentAgeTxtFld.text  = ""
                self.studentRollNumberTextField.text  = ""
                 self.studentDepartmentTextField.text  = ""
                 self.studentMarkTextFld.text = ""
                self.studentListTableView.reloadData()
            }
        }
        catch{
            print("error")
        }
    }
    
    
    
    func saveData(studentDetails: StudentDetails){
        
        do{
            try appContext.save()
            loadData()
        }
        catch{
            print("error")
        }
    }
    
    
    func updateData(studentDetails: StudentDetails,mark: String){
        studentDetails.marks = mark
        do{
            try appContext.save()
            loadData()
        }
        catch{
            print("error")
        }
    }
    
    func deleteItem(studentDetails: StudentDetails){
        appContext.delete(studentDetails)
        do{
            try appContext.save()
            self.loadData()
        }
        catch{
            print("error")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentListTableViewCell", for: indexPath) as? studentListTableViewCell else {return UITableViewCell.init()}
        let data = self.studentDetails[indexPath.row]
        cell.studentNameLabel.text = data.name
        cell.studentAgeLabel.text = data.age
        cell.studentDepartmentLabel.text = data.department
        cell.studentRegNameLabel.text = data.rollnumber
        cell.studentMarkLabel.text = data.marks
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexItem = self.studentDetails[indexPath.row]
        
        let alert = UIAlertController(title: "Alert", message: "Update Or delete data", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] _ in
            guard let firstText = alert.textFields?.first, let texts = firstText.text, !texts.isEmpty else{return}
                
            self?.updateData(studentDetails: indexItem, mark: texts)
        
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            
            self?.deleteItem(studentDetails: indexItem)
        }))
        self.present(alert, animated: true)
    }
}
