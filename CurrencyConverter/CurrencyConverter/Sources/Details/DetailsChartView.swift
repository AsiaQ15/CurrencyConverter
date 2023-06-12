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
    private var yValues: [Double] = [32 ,425 ,300 ,150.0000001 ,200.234,178.999,78,90,50,10,100,115]
    private var labelName = "RUB/EUR"
    private var value = 1.0
    
    
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
    
    func setData(xValues: [String], yValues: [Double], name: String, coef: Double) {
        self.xValues = xValues
        self.yValues = yValues
        self.labelName = name
    }
    
    func updateYValus(coef: Double) {
        self.value = coef
        print("coef \(coef)")
        //self.yValues = self.yValues.map{ $0 * coef}
        //lineChartView.data?.notifyDataChanged()
        //lineChartView.notifyDataSetChanged()
        self.setCghart()
        self.drawLineChart()
   
        
    }
    
    func drawLineChart() {
        setCghart()
        let yValuesCoef = yValues.map{self.value * $0 }
      
        let max_val = yValuesCoef.max() ?? 0
        let min_val = yValuesCoef.min() ?? 0
      
        removeLimitLine()
//        LineChartData newData = new LineChartData(chart.getLineChartData());
//        newData.getLines().clear();
//        chart.setLineChartData(newData);
        
        self.addLimitLine(max_val, "\( round(10000 * (max_val)) / 10000)", UIColor.red)
        self.addLimitLine(min_val, "\(round(10000 * (min_val)) / 10000)", UIColor.systemGreen)

        lineChartView.xAxis.valueFormatter = VDChartAxisValueFormatter.init(xValues as NSArray)
        //lineChartView.leftAxis.valueFormatter = VDChartAxisValueFormatter.init()
        
        var yDataArray1 = [ChartDataEntry]()
        guard xValues.count > 0 else {return}
        for i in 0...xValues.count-1 {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(yValuesCoef[i]))
            yDataArray1.append(entry)
        }
        print(yDataArray1)
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: labelName)
        set1.colors = [UIColor.darkGray]
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1.0
        set1.valueFormatter = DefaultValueFormatter(decimals: 2)
        let data = LineChartData.init(dataSets: [set1])
        
        let leftAxis = self.lineChartView.leftAxis
//        leftAxis.axisMaximum = max_val + 1
//        leftAxis.axisMinimum = min_val - 1
        leftAxis.calculate(min: max_val + 1, max: min_val - 1)
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .decimal
        valFormatter.maximumFractionDigits = 2
        //valFormatter.currencySymbol = "$"

        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        
        let xAxis = self.lineChartView.xAxis
        xAxis.labelCount = xValues.count
        
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
        //leftAxis.labelCount = 10
        
        
//        leftAxis.labelCount = 16 //The number of Y-axis labels, the value is not necessarily, if forceLabelsEnabled is equal to YES, the specified number of labels is forced to be drawn, but may not be average
//        leftAxis.forceLabelsEnabled = false //Do not force to draw a specified number of labels
//        leftAxis.axisMinimum = 0 //Set the minimum value of the Y axis
//        leftAxis.drawZeroLineEnabled = true //Draw from 0
//        //leftAxis.axisMaximum = 1000 //Set the maximum value of the Y axis
//        leftAxis.inverted = false //Whether to turn the Y axis upside down
//        leftAxis.axisLineWidth = 1.0/UIScreen.main.scale //Set Y axis width
//        leftAxis.axisLineColor = UIColor.cyan//Y axis color
//        //leftAxis.valueFormatter = NumberFormatter()//Custom format
//        //leftAxis.s //Digital suffix unit
//        leftAxis.labelPosition = .outsideChart//label position
//        leftAxis.labelTextColor = UIColor.red//Text color
//        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)//Text font
        

        
        let xAxis = self.lineChartView.xAxis
        xAxis.granularityEnabled = true
        xAxis.labelTextColor = UIColor.black
        xAxis.labelFont = UIFont.systemFont(ofSize: 4.0)
        xAxis.labelPosition = .bottomInside
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
    
//    func stringForValue(_ value: Double,
//                        entry: ChartDataEntry,
//                        dataSetIndex: Int,
//                        viewPortHandler: ViewPortHandler?) -> String {
//        print("stringForValue")
//        let valueWithoutDecimalPart = String(format: "%.0f", value)
//        return "\(valueWithoutDecimalPart)"
//    }
}

//class DigitValueFormatter : NSObject, IValueFormatter {
//
//    func stringForValue(_ value: Double,
//                        entry: ChartDataEntry,
//                        dataSetIndex: Int,
//                        viewPortHandler: ViewPortHandler?) -> String {
//        let valueWithoutDecimalPart = String(format: "%.0f", value)
//        return "\(valueWithoutDecimalPart)"
//    }
//}
//class ChartValueFormatter: NSObject, ValueFormatter {
//    fileprivate var numberFormatter: NumberFormatter?
//
//    convenience init(numberFormatter: NumberFormatter) {
//        self.init()
//        self.numberFormatter = numberFormatter
//    }
//
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        guard let numberFormatter = numberFormatter
//            else {
//                return ""
//        }
//        return numberFormatter.string(for: value)!
//    }
//}
