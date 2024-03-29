//
//  DetailsPresenter.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import Foundation
import UIKit


protocol IDetailsPresenter: AnyObject {
    
    func getVC() -> UIViewController?
    func setData(first: Currency, second: Currency, chartData: ([String],[Double]))
    func changeSecondCount(value: String) -> String
    func getCoefOfChange() -> Double
    
}

final class DetailsPresenter: IDetailsPresenter {
    
    private var detailsView: DetailsViewController?
    private let model = DetailsData()
    private let coordinatingController: ICoordinatingController
    
    init( coordinatingController: ICoordinatingController) {
        self.coordinatingController = coordinatingController
    }
    
    func setData(first: Currency, second: Currency, chartData: ([String],[Double])) {
        model.setData(first: first, second: second, chart: chartData)
        configure()
    }
    
    func configure() {
        detailsView?.setFirst(image: model.getFirstImage(), name: model.getFistName(), cost: model.getFirstCostString())
        detailsView?.setSecond(image: model.getSecondImage(), name: model.getSecondName(), cost: model.getSecondCostString())
        detailsView?.setSecondCount(count: String(model.getSecondCount()))
        detailsView?.setFirstCount(count: String(model.getFirstCount()))
        detailsView?.setName(name: model.getScreenName())
        let dataChart = model.getChartData()
        detailsView?.setChartData(xValues: dataChart.0, yValues: dataChart.1, name: dataChart.2, coef: dataChart.3)
        detailsView?.updateChart()
    }
    
    func getVC() -> UIViewController? {
        return self.detailsView
    }
    
    func changeSecondCount(value: String) -> String {
        String(model.getNewSecondCout(value: Double(value) ?? 0))
    }
    
    func getCoefOfChange() -> Double {
        model.getCoef()
    }
    
    func swap() {
        model.swap()
        configure()
    }
}

extension DetailsPresenter: INavigationItem {
    
    var vc: UIViewController? {
        self.detailsView
    }
    
    func set<Parameters>(parameters: Parameters) {
        guard let data = parameters as? (Currency, Currency, ([String],[Double])) else { return }
        model.setData(first: data.0, second: data.1, chart: data.2)
        configure()
    }

    func setVC(vc: UIViewController?) {
        guard let vcDetails = vc as? DetailsViewController else { return }
        self.detailsView = vcDetails
        self.detailsView?.setButtonHandler(handler: self.swap)
    }
    
}
