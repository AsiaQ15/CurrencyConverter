//
//  DetailsChartView.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 06.06.2023.
//

import UIKit
import Charts
import SnapKit

final class DetailsChartView: UIView {

    private var lineChartView = LineChartView()
    private var xValues = [String]()
    private var yValues = [Double]()
    private var labelName = ""
    private var value = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.backgroundColor
        self.addSubview(self.lineChartView)
        self.lineChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.commonInset)
        }
        self.setCghart()
        self.drawLineChart()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(xValues: [String], yValues: [Double], name: String, coef: Double) {
        self.xValues = xValues
        self.yValues = yValues
        self.labelName = name
    }
    
    func updateYValus(coef: Double) {
        self.value = coef
        self.drawLineChart()
    }
    
    func drawLineChart() {
        let yValuesCoef = yValues.map{self.value * $0 }
      
        let max_val = yValuesCoef.max() ?? 0
        let min_val = yValuesCoef.min() ?? 0
      
        removeLimitLine()
        self.addLimitLine(max_val, "\( round(10000 * (max_val)) / 10000)", Constants.maxColor)
        self.addLimitLine(min_val, "\(round(10000 * (min_val)) / 10000)", Constants.minColor)

        lineChartView.xAxis.valueFormatter = VDChartAxisValueFormatter.init(xValues as NSArray)
        
        var yDataArray1 = [ChartDataEntry]()
        guard xValues.count > 0 else {return}
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(yValuesCoef[i]))
            yDataArray1.append(entry)
        }
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: labelName)
        set1.colors = [Constants.lineColor]
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.0
        let data = LineChartData.init(dataSets: [set1])
        
        let leftAxis = self.lineChartView.leftAxis
        leftAxis.calculate(min: max_val + 1, max: min_val - 1)
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .decimal
        valFormatter.maximumFractionDigits = 2

        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)

        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
        self.lineChartView.doubleTapToZoomEnabled = false
        self.lineChartView.scaleXEnabled = false
        self.lineChartView.scaleYEnabled = false
        
        lineChartView.fitScreen()
        lineChartView.isUserInteractionEnabled = false
    }
    
}

private extension DetailsChartView {
    private func setShadow() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = Constants.borderColor
        self.layer.shadowOpacity = Constants.shadowOpacity
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.shadowRadius = Constants.shadowRadius
        self.layer.shadowColor = Constants.borderColor
        self.layer.masksToBounds = false
    }
    
    private func setCghart() {
        self.lineChartView.backgroundColor = Constants.backgroundColor
        self.lineChartView.doubleTapToZoomEnabled = false
        self.lineChartView.scaleXEnabled = false
        self.lineChartView.scaleYEnabled = false
        
        self.lineChartView.noDataText = "Нет данных"
        self.lineChartView.noDataTextColor = UIColor.gray
        self.lineChartView.noDataFont = UIFont.boldSystemFont(ofSize: 14)
        self.lineChartView.rightAxis.enabled = false
        
        let leftAxis = self.lineChartView.leftAxis
        leftAxis.forceLabelsEnabled = false
        leftAxis.axisLineColor = Constants.lineColor
        leftAxis.labelTextColor = Constants.lineColor
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        leftAxis.labelPosition = .outsideChart
        leftAxis.gridColor = .lightGray
        leftAxis.gridAntialiasEnabled = false
     
        let xAxis = self.lineChartView.xAxis
        xAxis.granularityEnabled = true
        xAxis.labelTextColor = Constants.lineColor
        xAxis.labelFont = UIFont.systemFont(ofSize: 8)
        xAxis.labelPosition = .bottomInside
        xAxis.gridColor = .lightGray
        xAxis.axisLineColor = Constants.lineColor
        
    }
    
    private func addLimitLine(_ value: Double, _ desc: String, _ color: UIColor) {
        let limitLine = ChartLimitLine.init(limit: value, label: desc)
        limitLine.lineWidth = 1
        limitLine.lineColor = color
        limitLine.lineDashLengths = [2.0,2.0]
        limitLine.valueFont = UIFont.systemFont(ofSize: 10.0)
        limitLine.valueTextColor = color
        limitLine.labelPosition = .rightBottom
        self.lineChartView.leftAxis.addLimitLine(limitLine)
        
    }
    
    private func removeLimitLine() {
        for  line in self.lineChartView.leftAxis.limitLines {
            self.lineChartView.leftAxis.removeLimitLine(line)
        }
    }

}

final class VDChartAxisValueFormatter: NSObject, AxisValueFormatter, ValueFormatter{
    
    func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String {
        return String(format:"%.2f%%",value)
    }
    
    var values:NSArray?
    
    override init() {
        super.init()
    }
    init(_ values: NSArray) {
        super.init();
        self.values = values
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if values == nil {
            return "\(value)"
        }
        return values?.object(at: Int(value)) as! String
    }
    
}

private enum Constants {
    static let backgroundColor = UIColor.systemBackground
    
    static let commonInset = 10
    
    static let maxColor = UIColor.systemRed
    static let minColor = UIColor.systemGreen
    static let lineColor = UIColor.systemGray
    
    static let borderColor = UIColor.systemGray2.cgColor
    static let borderWidth = CGFloat(1)
    static let cornerRadius = CGFloat(8)
    static let shadowRadius = CGFloat(3)
    static let shadowOpacity = Float(0.5)
    static let shadowOffset = CGSize(width: 1.0, height: 1.0)
    
//    static let leftInset = 10
//    static let rightInset = 10
//    static let topOffset = 10
//    static let spaceBetween = 30
//    static let bottomInset = 50
//
//    static let detailsHeight = 190
    
}


