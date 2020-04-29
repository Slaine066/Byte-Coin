import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}


//MARK: - PickerDataSource
extension ViewController: UIPickerViewDataSource {
    //
    // UIPickerViewDataSource Methods
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Return number of columns in the Picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}


//MARK: - PickerDelegate
extension ViewController: UIPickerViewDelegate {
    //
    // UIPickerViewDelegate Methods
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(coinManager.currencyArray[row])
    }
}


//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, _ exchange: Double, _ currency: String) {
        DispatchQueue.main.async {
            self.exchangeLabel.text = String(format: "%.2f", exchange)
            self.currencyLabel.text = currency
        }
    }
    
    func updateCoinDidFail(_ coinExchange: CoinManager, _ error: Error) {
        print(error)
    }
}
