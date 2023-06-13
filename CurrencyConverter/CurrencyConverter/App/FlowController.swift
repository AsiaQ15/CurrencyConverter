//
//  FlowController.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 07.06.2023.
//
import Foundation

final class FlowController {
    let firstPresenter: INavigationItem

    private let coordinatingController: CoordinatingController
    private var modules = [INavigationItem]()
    
    init(coordinatingController: CoordinatingController) {
        self.coordinatingController = coordinatingController
        
        let currencyData = MainScreenModel()
        currencyData.setData(CurrencyConverterData.data.getDataForMainScreen())
        self.firstPresenter = MainScreenPresenter(model: currencyData, coordinatingController: coordinatingController)
        let viewController = MainScreenTableViewController(presenter: firstPresenter as! PMainScreenPresenter)
        firstPresenter.setVC(vc: viewController)
        print(viewController)
        
        self.coordinatingController.register(module: .mainScreenPresener, navItem: self.firstPresenter)
        self.modules.append(self.makeDetailPtesente())

    }
}

extension FlowController {
    func makeDetailPtesente() -> INavigationItem {
        
        let presenterDetails = DetailsPresenter(coordinatingController: coordinatingController)
        let detailsController = DetailsViewController(presenter: presenterDetails)
        presenterDetails.setVC(vc: detailsController)
        
        //let vc = DetailsViewController(coordinatingController: coordinatingController)
        self.coordinatingController.register(module: .detailsPresenter, navItem: presenterDetails)
        
        return presenterDetails
    }
    
}

