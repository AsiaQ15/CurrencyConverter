//
//  DetailsController.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import UIKit
import SnapKit

final class DetailsViewController: UIViewController {
    
    private let detailsView = DetailsView()
    private let chartView = DetailsChartView()
    private let presenter: PDetailsPresenter
    
    init(presenter: PDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        self.detailsView.setDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFirst(image: UIImage, name: String, cost: String) {
        self.detailsView.setFirst(image: image, name: name, cost: cost)
    }
    
    func setSecond(image: UIImage, name: String, cost: String) {
        self.detailsView.setSecond(image: image, name: name, cost: cost)
    }
    
    func setSecondCount(count: String) {
        self.detailsView.setSecondCount(count: count)
    }
    
    func setFirstCount(count: String) {
        self.detailsView.setFirstCount(count: count)
    }
    
    func setName(name: String) {
        self.navigationItem.title = name
    }
    
    func setChartData(xValues: [String], yValues: [Double], name: String) {
        self.chartView.setData(xValues: xValues, yValues: yValues, name: name)
    }
    
    func updateChart() {
        self.chartView.drawLineChart()
    }
}

private extension DetailsViewController {
    private func configuration() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.detailsView)
        self.detailsView.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(190)
        }
        
        self.view.addSubview(self.chartView)
        self.chartView.snp.makeConstraints { make in
            make.top.equalTo(self.detailsView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(50)
        }
        
     //   setShadow()
        
    }
    
//    private func setShadow() {
//        //print(self.)
//        self.chartView.layer.cornerRadius = 8
//        self.chartView.layer.borderWidth = 1
//        self.chartView.layer.borderColor = UIColor.gray.cgColor
//        self.chartView.layer.shadowOpacity = 0.5
//        self.chartView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        self.chartView.layer.shadowRadius = 3.0
//        self.chartView.layer.shadowColor = UIColor.black.cgColor
//        self.chartView.layer.masksToBounds = false
//    }
}

extension DetailsViewController: UITextFieldDelegate {
    
    // hide key board when the user touches outside keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        let newCount = self.presenter.changeSecondCount(value: self.detailsView.getFirstCount())
        self.detailsView.setSecondCount(count: newCount)
        
    }
    
    // user presses return key
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.detailsView.test()
//        //textField.resignFirstResponder()
//        return true
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if text == "\n" {
//                   self.textView.resignFirstResponder()
//                   return false
//               }
//               return true
//            return Int(string) != nil
//        }
    
}
