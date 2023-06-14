//
//  MainScreenTableView.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit



final class MainScreenTableView: UITableView {

    private var presenter: IMainScreenPresenter
    private var tapHandler: ((Int) -> Void)?
    private var changeHandler: ((Int) -> Void)?
    
    init(presenter:  IMainScreenPresenter) {
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
    
}

extension MainScreenTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.numberOfCurrency
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.reuseIdentifier, for: indexPath) as? MainScreenTableViewCell else { return UITableViewCell()}
        self.presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}

extension MainScreenTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.tapHandler?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .normal, title: "Сделать основным") { _,_,_ in
            self.changeHandler?(indexPath.row)
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

private enum Constants {
    static let heightForRow = CGFloat(115)
}

