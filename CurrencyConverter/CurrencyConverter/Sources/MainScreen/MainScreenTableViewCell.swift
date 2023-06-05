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
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(viewCell)
        self.viewCell.backgroundColor = Constants.ViewCell.backgroundColor
        self.viewCell.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.viewCell.addSubview(image)
      
        //self.image.contentMode = Constants.Image.content
        // set the frame of the imageview
        self.image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)

        // set the cornerradius of the imageview to half of the width or height, whichever is smaller
        self.image.layer.cornerRadius = min(self.image.frame.width, self.image.frame.height) / 2

        // set the maskstobounds property of the imageview's layer to true
        self.image.layer.masksToBounds = true
        self.image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.left.equalToSuperview().inset(Constants.leftInset)
            make.width.equalTo(Constants.widthImage)
            make.height.equalTo(Constants.heightImage)
        }
        
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
        static let backgroundColor = UIColor.lightGray//UIColor.jcRed
    }
    
    enum LabelName {
        static let backgroundColor = UIColor.jcRed
        static let textColor = UIColor.white
        static let textFont = Fonts.title3
    }
    
    enum LabelCost {
        static let backgroundColor = UIColor.jcRed
        static let textColor = UIColor.white
        static let textFont = Fonts.title3
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
    static let widthLable = 250
    
    static let heightImage = 80
    static let widthImage = 80
    
    static let leftInset = 10
    static let rightInset = 10
    static let topInset = 10
    
}
