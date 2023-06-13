//
//  MainScreenTableView.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit



final class MainScreenTableView: UITableView {

    //private let currency: CurrencyData
    //private let currencyArray = [Currency]()
    private var presenter: PMainScreenPresenter
    private var tapHandler: ((Int) -> Void)?
    private var changeHandler: ((Int) -> Void)?
    
    init(presenter:  PMainScreenPresenter) {
        self.presenter = presenter
        super.init(frame: .zero, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.register(MainScreenTableViewCell.self, forCellReuseIdentifier: MainScreenTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(taphandler: @escaping ((Int) -> Void)) {
        self.tapHandler = taphandler
    }
    
    func setup(changehandler: @escaping ((Int) -> Void)) {
        self.changeHandler = changehandler
    }
    
//    func addNewData(_ url: String) -> Int {
//        self.pictures.addNewPicture(url: url, photo: nil)
//    }
//
//    func deleteErrorLoad(id: Int) {
//        self.pictures.deletePicture(id: id)
//    }
//
//    func updateProgree(id: Int, progress: Float) {
//        self.pictures.setProgress(id: id, progress: progress)
//    }
//
//    func setImage(id: Int, image: UIImage) {
//        self.pictures.setImage(id: id, image: image)
//    }

}

extension MainScreenTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.numberOfCurrency
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.reuseIdentifier, for: indexPath) as? MainScreenTableViewCell else { return UITableViewCell()}
        self.presenter.configure(cell: cell, forRow: indexPath.row)
        //cell.setUp(data: self.currency.getData(indexPath.row))
        //self.currency.getData(indexPath.row)
        return cell
    }
}

extension MainScreenTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.tapHandler?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .normal, title: "Сделать основным") { _,_,_ in
//            self.notes.remove(at: indexPath.row)
//            tableView.reloadData()
            self.changeHandler?(indexPath.row)
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
