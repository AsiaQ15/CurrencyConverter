//
//  MainScreenTableViewCell.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit
import SnapKit

class MainScreenTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MainScreenViewCell"
    
    private let viewCell = UIView()
    private let image = UIImageView()
    private let labelName = UILabel()
    private let labelCost = UILabel()
    //private let progress = UIProgressView(progressViewStyle: .bar)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(data: Currency) {
        self.labelName.text = data.name
        self.labelCost.text = String(data.cost)
    }
    
}

private extension MainScreenTableViewCell {
    
    private func configuration() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(viewCell)
        self.viewCell.backgroundColor = Constants.ViewCell.backgroundColor
        self.viewCell.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
//        self.viewCell.addSubview(image)
//        self.image.contentMode = Constants.Image.content
//        self.image.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.right.equalToSuperview()
//            make.left.equalToSuperview()
//        }
        
        self.viewCell.addSubview(labelName)
        self.labelName.backgroundColor = Constants.LabelName.backgroundColor
        self.labelName.backgroundColor = Constants.LabelName.textColor
        self.labelName.font = Constants.LabelName.textFont
        self.labelName.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.leftInset)
            make.top.equalToSuperview().inset(Constants.topInset)
            make.width.equalTo(Constants.widthLable)
            make.height.equalTo(Constants.heightLable)
        }
        
        self.viewCell.addSubview(labelCost)
        self.labelCost.backgroundColor = Constants.LabelCost.backgroundColor
        self.labelCost.backgroundColor = Constants.LabelCost.textColor
        self.labelCost.font = Constants.LabelCost.textFont
        self.labelCost.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.leftInset)
            make.top.equalTo(self.labelName.snp.bottom).offset(Constants.topInset)
            make.width.equalTo(Constants.widthLable)
            make.height.equalTo(Constants.heightLable)
        }
    
    }

}

private enum Constants {

    enum ViewCell {
        static let backgroundColor = UIColor.jcRed
    }
    
    enum LabelName {
        static let backgroundColor = UIColor.jcRed
        static let textColor = UIColor.white
        static let textFont = Fonts.title1
    }
    
    enum LabelCost {
        static let backgroundColor = UIColor.jcRed
        static let textColor = UIColor.white
        static let textFont = Fonts.title1
    }
    
    enum Image {
        static let content = UIControl.ContentMode.scaleAspectFit
    }
    
//    enum Progress {
//        static let progressTintColor = UIColor.green
//        static let trackTintColor = UIColor.lightGray
//        static let font = UIFont.preferredFont(forTextStyle: .title3)
//        static let cornerRadius = CGFloat(5)
//    }

    static let heightLable = 30
    static let widthLable = 200
    
    static let leftInset = 10
    static let rightInset = 10
    static let topInset = 10
    
}
