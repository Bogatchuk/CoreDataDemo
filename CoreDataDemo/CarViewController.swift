//
//  CarViewController.swift
//  CoreDataDemo
//
//  Created by Roma Bogatchuk on 22.11.2022.
//

import UIKit
import CoreData

class CarViewController: UIViewController {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCar: Car!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var carSemented: UISegmentedControl!
    @IBOutlet weak var myChoisImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFile()
        
        let fetchRequest = Car.fetchRequest()
        let mark = carSemented.titleForSegment(at: 0)
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        do{
            let result = try context.fetch(fetchRequest)
            selectedCar = result.first
            insertDataFrom(selectedCar: selectedCar)
        }catch{
            
        }
    }
    
    func insertDataFrom(selectedCar: Car) {
        carImage.image = UIImage(data: selectedCar.imageData! as Data)
        markLabel.text = selectedCar.mark
        modelLabel.text = selectedCar.model
        myChoisImage.isHidden = !(selectedCar.myChoice)
        ratingLabel.text = "Rating: \(selectedCar.rating) / 10.0"
        numberOfTripsLabel.text = "Number of trips: \(selectedCar.timesDriven)"
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        lastTimeStartedLabel.text = "Last time started: \(df.string(from: selectedCar.lastStarted! as Date))"
        carSemented.backgroundColor =  selectedCar.tintColor as? UIColor
        
        
    }
    
    func getDataFromFile(){
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do{
            let count = try context.count(for: fetchRequest)
            records = count
        }catch{
            print(error.localizedDescription)
        }
        
        guard records == 0 else {return}
        
        let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
        
        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            
            let carDictionary = dictionary as! NSDictionary
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as? NSNumber as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as? NSNumber as! Int16
            car.myChoice = ((carDictionary["myChoice"] as? NSNumber) != nil)
            
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = image!.pngData()
            car.imageData = imageData as Data?
            
            let colorDictionary = carDictionary["tintColor"] as? NSDictionary
            car.tintColor = getColor(colorDictionary: colorDictionary!)
            
        }
    }
    
    func getColor(colorDictionary: NSDictionary) -> UIColor {
        let red = colorDictionary["red"] as! CGFloat
        let green = colorDictionary["green"] as! CGFloat
        let blue = colorDictionary["blue"] as! CGFloat
        print(CGFloat(red))
        print(green)
        print(blue)
        return UIColor(red: red /  255, green:  green / 255, blue: blue / 255, alpha: 1)
    }
    
    @IBAction func segmentedPressed(_ sender: UISegmentedControl) {
        let fetchRequest = Car.fetchRequest()
        let mark = sender.titleForSegment(at: sender.selectedSegmentIndex)
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        do{
            let result = try context.fetch(fetchRequest)
            selectedCar = result.first
            insertDataFrom(selectedCar: selectedCar)
        }catch{
            
        }
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        let timesDriven = selectedCar.timesDriven
        selectedCar.timesDriven = timesDriven + 1
        selectedCar.lastStarted = Date()
        
        do{
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        }catch{
            print("lolo")
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        let ac = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {
          action in
          
          let textField = ac.textFields?[0]
          self.update(rating: textField!.text!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        ac.addTextField {
          textField in
          textField.keyboardType = .numberPad
        }
        
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    func update(rating: String) {
      selectedCar.rating = Double(rating)!
      
      do {
        try context.save()
        insertDataFrom(selectedCar: selectedCar)
      } catch {

        let ac = UIAlertController(title: "Wrong value", message: "Wrong input", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
          print("---------------")
        print(error.localizedDescription)
      }
    }
  }







