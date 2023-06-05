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
    //private let searchView = SearchView()
    //private let loadData = PicturesNetwork()

    init(presenter: PMainScreenPresenter,  model: CurrencyData) {
        self.presenter = presenter
        self.tableView = MainScreenTableView(presenter: presenter)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        configuration()
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
    
}

private extension MainScreenTableViewController {
    
    private func configuration() {
//        self.view.addSubview(searchView)
//        self.searchView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.height.equalTo(Constants.searchViewHeight)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//        }
        //self.view = self.tableView
        

        self.navigationItem.title = "Конвертер валют"
      
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
    
//    private func showAlertController(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
}

//private enum Constants {
//    static let searchViewHeight = 160
//}

