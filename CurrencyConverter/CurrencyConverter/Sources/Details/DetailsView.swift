//
//  DetailsView.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import UIKit
import SnapKit

final class DetailsView: UIView {

    private var firstImage = UIImageView()
    private var firstLabelName = UILabel()
    private var firstLabelCost = UILabel()
    private var firstCount = UITextField()
    
    private var secondImage = UIImageView()
    private var secondLabelName = UILabel()
    private var secondLabelCost = UILabel()
    private var secondCount = UITextField()
    
    private var button = UIButton()
    private var buttonHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFirst(image: UIImage, name: String, cost: String) {
        self.firstImage.image = image
        self.firstLabelName.text = name
        self.firstLabelCost.text = cost
    }

    func setFirstCount(count: String = "1") {
        self.firstCount.text = count
    }
    
    func setSecond(image: UIImage, name: String, cost: String) {
        self.secondImage.image = image
        self.secondLabelName.text = name
        self.secondLabelCost.text = cost
    }
    
    func setSecondCount(count: String = "1") {
        self.secondCount.text = count
    }
    
    func setDelegate(_ vc: UITextFieldDelegate) {
        self.firstCount.delegate = vc
    }
    
    func getFirstCount() -> String {
        self.firstCount.text ?? "0"
    }
    
    func setupHandler(handler: @escaping (() -> Void)) {
        self.buttonHandler = handler
    }
    
    @objc func buttomAction(sender: UIButton) {
        guard let action = self.buttonHandler else { return }
        action()
    }

}

private extension DetailsView {
    
    private func configuration() {
        self.backgroundColor = .white
        self.setShadow()
        self.addSubview(self.firstImage)
        makeImage(image: &self.firstImage)
        self.firstImage.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightImage)
            make.width.equalTo(Constants.heightImage)
            make.top.equalToSuperview().inset(Constants.topInset)
            make.left.equalToSuperview().inset(Constants.leftInset)
        }
        
        self.addSubview(self.firstCount)
        makeTextField(text: &self.firstCount)
        self.firstCount.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightTextField)
            make.width.equalTo(Constants.withTextField)
            make.top.equalToSuperview().inset(Constants.topInset)
            make.right.equalToSuperview().inset(Constants.rightInset)
        }
        
        self.addSubview(self.firstLabelName)
        makeLabelName(label: &self.firstLabelName)
        self.firstLabelName.snp.makeConstraints { make in
            make.top.equalTo(self.firstImage.snp.top)
            make.left.equalTo(self.firstImage.snp.right).offset(Constants.Spacing.medium)
            make.right.equalTo(self.firstCount.snp.left)
            make.height.equalTo(Constants.heightLabel)
        }
        
        self.addSubview(self.firstLabelCost)
        makeLabelCost(label: &self.firstLabelCost)
        self.firstLabelCost.snp.makeConstraints { make in
            make.top.equalTo(self.firstLabelName.snp.bottom)
            make.left.equalTo(self.firstImage.snp.right).offset(Constants.Spacing.medium)
            make.right.equalTo(self.firstCount.snp.left)
            make.height.equalTo(Constants.heightLabel)
        }
        
        self.addSubview(self.secondImage)
        makeImage(image: &self.secondImage)
        self.secondImage.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightImage)
            make.width.equalTo(Constants.heightImage)
            make.top.equalTo(self.firstImage.snp.bottom).offset(Constants.Spacing.large)
            make.left.equalToSuperview().inset(Constants.leftInset)
        }
        
        self.addSubview(self.secondCount)
        self.secondCount.isEnabled = false
        makeTextField(text: &self.secondCount)
        self.secondCount.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightTextField)
            make.width.equalTo(Constants.withTextField)
            make.top.equalTo(self.firstCount.snp.bottom).offset(Constants.Spacing.large)
            make.right.equalToSuperview().inset(Constants.rightInset)
        }
        
        self.addSubview(self.secondLabelName)
        makeLabelName(label: &self.secondLabelName)
        self.secondLabelName.snp.makeConstraints { make in
            make.top.equalTo(self.secondImage.snp.top)
            make.left.equalTo(self.secondImage.snp.right).offset(Constants.Spacing.medium)
            make.right.equalTo(self.secondCount.snp.left)
            make.height.equalTo(Constants.heightLabel)
        }
        
        self.addSubview(self.secondLabelCost)
        makeLabelCost(label: &self.secondLabelCost)
        self.secondLabelCost.snp.makeConstraints { make in
            make.top.equalTo(self.secondLabelName.snp.bottom)
            make.left.equalTo(self.secondImage.snp.right).offset(Constants.Spacing.medium)
            make.right.equalTo(self.secondCount.snp.left)//inset(Constants.Spacing.small)
            make.height.equalTo(Constants.heightLabel)
        }
        
        self.addSubview(self.button)
        makeButton(button: &self.button)
        self.button.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightbutton)
            make.width.equalTo(Constants.withbutton)
            make.centerX.equalTo(self.firstCount.snp.centerX)
            make.top.equalTo(self.firstCount.snp.bottom).offset(Constants.Spacing.small)
        }

    }
    
    private func makeLabelName(label: inout UILabel) {
        label.backgroundColor = Constants.Label.backgroundColor
        label.font = Constants.Label.maintextFont
        label.textColor = .black
        label.textAlignment = Constants.Label.textAlignment
        label.numberOfLines = Constants.Label.numberOfLines
    }
    
    private func makeLabelCost(label: inout UILabel) {
        label.backgroundColor = Constants.Label.backgroundColor
        label.font = Constants.Label.subtextFont
        label.textColor = .gray
        label.textAlignment = Constants.Label.textAlignment
        label.numberOfLines = Constants.Label.numberOfLines
    }
    
    private func makeImage(image: inout UIImageView) {
        image.frame = CGRect(x: 0, y: 0, width: Constants.heightImage, height: Constants.heightImage)
        image.layer.cornerRadius = min(image.frame.width, image.frame.height) / 2
        image.layer.masksToBounds = true
    }
    
    private func makeTextField(text: inout UITextField) {
        text.textAlignment = Constants.TextField.textAlignment
        text.backgroundColor = Constants.TextField.backgroundColor
        text.font = Constants.TextField.textFont
        text.borderStyle = .line
        text.keyboardType = .decimalPad
    }
    
    private func makeButton(button: inout UIButton) {
        button.setImage(Constants.Button.image, for: .normal)
        button.contentHorizontalAlignment = Constants.Button.contentHorizontalAlignment
        button.contentVerticalAlignment = Constants.Button.contentVerticalAlignment
        button.imageView?.contentMode = Constants.Button.imageViewContentMode
        button.addTarget(self, action: #selector(self.buttomAction(sender:)), for: .touchUpInside)
    }
    
    private func setShadow() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
    
    
}

private enum Constants {
    enum Spacing {
        static let small = 5
        static let medium = 10
        static let large = 50
    }
    
    enum Button {
        static let image = UIImage(systemName: "repeat")
//        static let backgroundColor = UIColor.green
        static let contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        static let contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        static let imageViewContentMode = UIView.ContentMode.scaleAspectFill
//        //static let text = "Загрузить"
//        static let content = UIControl.ContentHorizontalAlignment.center
    }
    enum Label {
        static let backgroundColor = UIColor.white
        static let numberOfLines = 0
        static let textAlignment = NSTextAlignment.left
        static let subtextFont = Fonts.subText
        static let maintextFont = Fonts.mainText
    }
    

    enum TextField {
        static let backgroundColor = UIColor.white
        static let textAlignment = NSTextAlignment.center
        static let textFont = Fonts.mainText
    }

    static let topInset = 20
    static let leftInset = 10
    static let rightInset = 10

    static let heightImage = 50
    static let heightLabel = 25
    static let heightTextField = 50
    static let withTextField = 100
    static let withbutton = 40
    static let heightbutton = 40
    
}

