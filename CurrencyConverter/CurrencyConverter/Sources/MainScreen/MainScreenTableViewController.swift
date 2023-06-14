//
//  MainScreenTableViewController.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit

final class MainScreenTableViewController: UIViewController {
    
    private var presenter: IMainScreenPresenter
    private let tableView: MainScreenTableView
    private var updateHandler: (() -> Void)?

    init(presenter: IMainScreenPresenter) {
        self.presenter = presenter
        self.tableView = MainScreenTableView(presenter: presenter)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setup(taphandler: self.presenter.openDetails(index:))
        self.tableView.setup(changehandler: self.presenter.changeMainCurrency(index:))
    }
    
    override func loadView() {
        super.loadView()
        configuration()
    }
    
    func setupHandler(handler: @escaping (() -> Void)) {
        self.updateHandler = handler
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
   
    @objc func leftHandAction() {
        guard let action = self.updateHandler else { return }
        action()
    }
    
}

private extension MainScreenTableViewController {
    
    private func configuration() {
        self.navigationItem.title = "Конвертер валют"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Обновить",
            style: .plain,
            target: self,
            action: #selector(leftHandAction)
        )
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.height)
            make.width.equalTo(self.view.frame.width)
            
        }
    }
    
}


