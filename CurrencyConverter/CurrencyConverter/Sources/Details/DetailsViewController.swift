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
    
    func setChartData(xValues: [String], yValues: [Double], name: String, coef: Double) {
        self.chartView.setData(xValues: xValues, yValues: yValues, name: name, coef: coef)
    }
    
    func updateChart() {
        let coef = self.presenter.getCoefOfChange()
        self.chartView.updateYValus(coef: coef)
        self.chartView.drawLineChart()
    }
    
    func setButtonHandler(handler: @escaping (() -> Void)) {
        self.detailsView.setupHandler(handler: handler)
    }
    
}

private extension DetailsViewController {
    private func configuration() {
        self.view.backgroundColor = Constants.backgroundColor
        self.view.addSubview(self.detailsView)
        self.detailsView.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(Constants.topOffset)
            make.left.equalToSuperview().inset(Constants.leftInset)
            make.right.equalToSuperview().inset(Constants.rightInset)
            make.height.equalTo(Constants.detailsHeight)
        }
        
        self.view.addSubview(self.chartView)
        self.chartView.snp.makeConstraints { make in
            make.top.equalTo(self.detailsView.snp.bottom).offset(Constants.spaceBetween)
            make.left.equalToSuperview().inset(Constants.leftInset)
            make.right.equalToSuperview().inset(Constants.rightInset)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
        self.updateChart()
    }
}

extension DetailsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        let newCount = self.presenter.changeSecondCount(value: self.detailsView.getFirstCount())
        self.detailsView.setSecondCount(count: newCount)
        let coef = self.presenter.getCoefOfChange()
        self.chartView.updateYValus(coef: coef)
        
    }
}

private enum Constants {
    static let backgroundColor = UIColor.systemBackground
    
    static let leftInset = 10
    static let rightInset = 10
    static let topOffset = 10
    static let spaceBetween = 30
    static let bottomInset = 50
    
    static let detailsHeight = 190
    
}

