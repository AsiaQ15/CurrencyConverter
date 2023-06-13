//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let coordinatingController = CoordinatingController()
        let flowControl = FlowController(coordinatingController: coordinatingController)
        print(flowControl.firstPresenter)
        let viewController = flowControl.firstPresenter.vc
        print(viewController)
        let navigationController = UINavigationController(rootViewController: viewController!)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
//        let presenterDetails = DetailsPresenter()
//        let detailsController = DetailsViewController(presenter: presenterDetails)
//        presenterDetails.setVC(view: detailsController)
//
//        //let totaldata = CurrencyConverterData()
//
//        let currencyData = MainScreenModel()
//        currencyData.setData(CurrencyConverterData.data.getDataForMainScreen())
//
//        let presenter = MainScreenPresenter(model: currencyData, presenter: presenterDetails)
//        let viewController = MainScreenTableViewController(presenter: presenter)
//        presenter.setVC(view: viewController)
//
////        let apiData = ConverterAPIDataManager()
////        apiData.updateCost(currancyPair: "RUBEUR")
////        let price = DataPrice()
////        price.loadJson2()
//
//        //presenter.setNextPresenter(presenter: presenterDetails)
//        let navigationController = UINavigationController(rootViewController: viewController)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
//
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }


}

