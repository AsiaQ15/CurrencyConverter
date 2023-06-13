//
//  MainScreenTableViewCell.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 04.06.2023.
//

import UIKit
import SnapKit

final class MainScreenTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MainScreenViewCell"
    
    private let viewCell = UIView()
    private let image = UIImageView()
    private let labelName = UILabel()
    private let labelCost = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayName(name: String) {
        self.labelName.text = name
    }
    
    func displayCost(cost: String) {
        self.labelCost.text = cost
    }
    
    func displayImage(image: UIImage) {
        self.image.image = image
    }
    
}

private extension MainScreenTableViewCell {
    
    private func configuration() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.contentView.addSubview(viewCell)
        setShadow()
        self.viewCell.backgroundColor = Constants.ViewCell.backgroundColor
        self.viewCell.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.cellInset)
            make.bottom.equalToSuperview().inset(Constants.cellInset)
            make.right.equalToSuperview().inset(Constants.cellInset)
            make.left.equalToSuperview().inset(Constants.cellInset)
        }
        
        self.viewCell.addSubview(image)
        self.image.frame = CGRect(x: 0, y: 0, width: Constants.widthImage, height: Constants.heightImage)
        self.image.layer.cornerRadius = min(self.image.frame.width, self.image.frame.height) / 2
        self.image.layer.masksToBounds = true
        self.image.layer.borderWidth = Constants.borderWidth
        self.image.layer.borderColor = Constants.borderColor
        self.image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.left.equalToSuperview().inset(Constants.leftInset)
            make.width.equalTo(Constants.widthImage)
            make.height.equalTo(Constants.heightImage)
        }
        
        self.viewCell.addSubview(labelName)
        self.labelName.backgroundColor = Constants.LabelName.backgroundColor
        self.labelName.font = Constants.LabelName.textFont
        self.labelName.textAlignment = Constants.LabelName.textAlignment
        self.labelName.layer.cornerRadius = Constants.cornerRadius
        self.labelName.layer.borderWidth = Constants.borderWidth
        self.labelName.layer.borderColor = Constants.borderColor
        self.labelName.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.leftInset)
            make.top.equalToSuperview().inset(Constants.topInset)
            make.width.equalTo(Constants.widthLable)
            make.height.equalTo(Constants.heightLable)
        }
        
        self.viewCell.addSubview(labelCost)
        self.labelCost.backgroundColor = Constants.LabelCost.backgroundColor
        self.labelCost.textColor = Constants.LabelCost.textColor
        self.labelCost.font = Constants.LabelCost.textFont
        self.labelCost.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.leftInset)
            make.top.equalTo(self.labelName.snp.bottom).offset(Constants.topInset)
            make.width.equalTo(Constants.widthLable)
            make.height.equalTo(Constants.heightLable)
        }
    }
    
    private func setShadow() {
        self.viewCell.layer.cornerRadius = Constants.cornerRadius
        self.viewCell.layer.borderWidth = Constants.borderWidth
        self.viewCell.layer.borderColor = Constants.borderColor
        self.viewCell.layer.shadowOpacity = Constants.shadowOpacity
        self.viewCell.layer.shadowOffset = Constants.shadowOffset
        self.viewCell.layer.shadowRadius = Constants.shadowRadius
        self.viewCell.layer.shadowColor = Constants.borderColor
        self.viewCell.layer.masksToBounds = false
    }
    
}

private enum Constants {
    enum ViewCell {
        static let backgroundColor = UIColor.systemBackground
    }
    
    enum LabelName {
        static let backgroundColor = UIColor.systemBackground
        static let textFont = Fonts.mainText
        static let textAlignment = NSTextAlignment.center
    }
    
    enum LabelCost {
        static let backgroundColor = UIColor.systemBackground
        static let textColor = UIColor.systemBlue
        static let textFont = Fonts.title3
    }
    
    enum Image {
        static let content = UIControl.ContentMode.scaleAspectFit
    }
    
    static let borderColor = UIColor.systemGray2.cgColor
    static let borderWidth = CGFloat(1)
    static let cornerRadius = CGFloat(8)
    static let shadowRadius = CGFloat(3)
    static let shadowOpacity = Float(0.5)
    static let shadowOffset = CGSize(width: 1.0, height: 1.0)

    static let heightLable = 30
    static let widthLable = 250
    
    static let heightImage = 80
    static let widthImage = 80
    
    static let leftInset = 10
    static let rightInset = 10
    static let topInset = 10
    
    static let cellInset = 5
    
}

