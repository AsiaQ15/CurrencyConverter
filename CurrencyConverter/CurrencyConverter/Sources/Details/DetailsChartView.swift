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
    private var xValues = ["x1","x2","x3","x4","x5","x6","x7","x8","x9","x10","x11","x12"]
    private var yValues: [Double] = [32 ,425 ,300 ,150 ,200,178,78,90,50,10,100,115]
    private var labelName = "RUB/EUR"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.lineChartView)
        self.lineChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        self.setCghart()
        self.drawLineChart()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(xValues: [String], yValues: [Double], name: String) {
        self.xValues = xValues
        self.yValues = yValues
        self.labelName = name
        
        print(self.xValues)
        print(self.yValues)
    }
    
    func drawLineChart() {
        
        let max_val = yValues.max() ?? 0
        let min_val = yValues.min() ?? 0
        self.addLimitLine(max_val, "\(max_val)", UIColor.red)
        self.addLimitLine(min_val, "\(min_val)", UIColor.green)

        lineChartView.xAxis.valueFormatter = VDChartAxisValueFormatter.init(xValues as NSArray)
        lineChartView.leftAxis.valueFormatter = VDChartAxisValueFormatter.init()
        
        var yDataArray1 = [ChartDataEntry]()
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(yValues[i]))
            yDataArray1.append(entry)
        }
        
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: labelName)
        set1.colors = [UIColor.darkGray]
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.0

        let data = LineChartData.init(dataSets: [set1])
        
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
        
        let leftAxis = self.lineChartView.leftAxis
        leftAxis.axisMaximum = max_val + 1
        leftAxis.axisMinimum = min_val - 1
        
        let xAxis = self.lineChartView.xAxis
        xAxis.labelCount = xValues.count + 2

    }
    
}

private extension DetailsChartView {
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
    
    private func setCghart() {
        self.lineChartView.backgroundColor = .white
        self.lineChartView.doubleTapToZoomEnabled = false
        self.lineChartView.scaleXEnabled = false
        self.lineChartView.scaleYEnabled = false
        
        self.lineChartView.noDataText = "Нет данных"
        self.lineChartView.noDataTextColor = UIColor.gray
        self.lineChartView.noDataFont = UIFont.boldSystemFont(ofSize: 14)
        self.lineChartView.rightAxis.enabled = false
        
        let leftAxis = self.lineChartView.leftAxis
        leftAxis.forceLabelsEnabled = false
        leftAxis.axisLineColor = UIColor.black
        leftAxis.labelTextColor = UIColor.black
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        leftAxis.labelPosition = .outsideChart
        leftAxis.gridColor = .lightGray
        leftAxis.gridAntialiasEnabled = false
        leftAxis.labelCount = 10
        
        let xAxis = self.lineChartView.xAxis
        xAxis.granularityEnabled = true
        xAxis.labelTextColor = UIColor.black
        xAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        xAxis.labelPosition = .bottom
        xAxis.gridColor = .lightGray
        xAxis.axisLineColor = UIColor.black
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
    
}


final class VDChartAxisValueFormatter: NSObject, AxisValueFormatter {
    
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

