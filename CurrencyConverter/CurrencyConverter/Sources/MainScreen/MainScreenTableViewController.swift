//
//  MainScreenTableViewController.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit

class MainScreenTableViewController: UIViewController {
    
    private var presenter: PMainScreenPresenter
    private let tableView: MainScreenTableView
    private var updateHandler: (() -> Void)?

    init(presenter: PMainScreenPresenter) {
        self.presenter = presenter
        self.tableView = MainScreenTableView(presenter: presenter)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.tableView.setup{index in
                self.presenter.openDetails(index: index)
            }
//        self.recipeView.setup { index in
//            self.coordinatingController.push(module: .recipeDetailsVC, parameters: self.data.recipes[index], animated: true)
//        }
    }
    
    override func loadView() {
        super.loadView()
        configuration()
    }
    
    func setupHandler(handler: @escaping (() -> Void)) {
        self.updateHandler = handler
    }
    
    func showAlertMessage(titleStr: String, messageStr: String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
        
//    func startLoad() {
//        let newURL = searchView.getText()
//        let newId = self.tableView.addNewData(newURL)
//        self.tableView.reloadData()
//        self.loadData.downloadImage(url: newURL, id: newId)
//    }
//
//    func successLoad(id: Int, image: UIImage) {
//        self.tableView.setImage(id: id, image: image)
//        self.tableView.reloadData()
//    }
//
//    func errorLoad(id: Int) {
//        self.tableView.deleteErrorLoad(id: id)
//        self.showAlertController(
//            title: "Ошибка",
//            message: "Не удалось загрузить изображение")
//        self.tableView.reloadData()
//
//    }
    
//    func progressLoad(id: Int, progress: Float) {
//        self.tableView.updateProgree(id: id, progress: progress)
//        self.tableView.reloadData()
//    }
    
    
    @objc func leftHandAction() {
        guard let action = self.updateHandler else { return }
        action()
    }
    
}

private extension MainScreenTableViewController {
    
    private func configuration() {
        self.navigationItem.title = "Конвертер валют"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Обновить",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(leftHandAction))
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
           // make.top.equalTo(self.topLayoutGuide.snp.bottom)
                //self.topLayoutGuide.snp.top)
            //make.top.equalToSuperview()
          //  make.left.equalToSuperview()
          //  make.right.equalToSuperview()
          //  make.bottom.equalToSuperview()
            make.height.equalTo(self.view.frame.height)
            make.width.equalTo(self.view.frame.width)
            
        }
//        self.searchView.setup(buttonHandler: self.startLoad)
//        self.loadData.setupSuccesshandler(handler: self.successLoad(id:image:))
//        self.loadData.setupErrorhandler(handler: self.errorLoad(id:))
//        self.loadData.setupProgressHandler(handler: self.progressLoad(id:progress:))
    }
    
    
    
    
}

//private enum Constants {
//    static let searchViewHeight = 160
//}

