//
//  CoordinatingController.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 07.06.2023.
//

import UIKit

protocol INavigationItem: AnyObject {
    
    var vc: UIViewController? { get }
    func set<Parameters>(parameters: Parameters)
    func setVC(vc: UIViewController?)
}

enum NavigationModule {
    
    case mainScreenPresener
    case detailsPresenter
}

protocol ICoordinatingController: AnyObject {
    
    func back(animated: Bool)
    func push<Parameters>(module: NavigationModule, parameters: Parameters, animated: Bool)
    func register(module: NavigationModule, navItem: INavigationItem)
    
}

final class CoordinatingController {
    
    private var modules = [NavigationModule: INavigationItem]()
    private var modulesStack = [INavigationItem]()
    
    func register(module: NavigationModule, navItem: INavigationItem) {
        self.modules[module] = navItem
        if self.modulesStack.isEmpty {
            self.modulesStack.append(navItem)
        }
    }

}

extension CoordinatingController: ICoordinatingController {
    
    func push<Parameters>(module: NavigationModule, parameters: Parameters, animated: Bool) {
        guard let nextModule = self.modules[module] else {
            assertionFailure("Модуль не зарегистрирован")
            return
        }

        if self.modulesStack.last?.vc == nextModule.vc {
            self.modulesStack.removeLast()
        }
        nextModule.set(parameters: parameters)
        
        let navigationController = self.modulesStack.last?.vc?.navigationController
        if let nextVC = nextModule.vc {
            navigationController?.pushViewController(nextVC, animated: animated)
        }
        self.modulesStack.append(nextModule)
    }
    
    func back(animated: Bool) {
        let last = self.modulesStack.popLast()
        
        guard let navigationController = last?.vc?.navigationController else {
            last?.vc?.dismiss(animated: animated)
            return
        }
        navigationController.popViewController(animated: animated)
    }

}

