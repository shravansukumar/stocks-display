//
//  CakeHistoricalTableViewCell.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 21/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import Charts

class CakeHistoricalTableViewCell: UITableViewCell, ChartViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet var chartView: CandleStickChartView!
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCharts()
    }
    
    // MARK: - Public Methods
     func setupCharts() {
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.chartDescription?.text = "Historical data"
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .horizontal
        chartView.legend.drawInside = true
        chartView.xAxis.removeAllLimitLines()
        
    }
    
    func drawGraph(for stockItems: [StockItem]) {
        var index = 0.0
        let yValues = stockItems.map { (i) -> CandleChartDataEntry in
            
            index += 5
            return CandleChartDataEntry(x: index, shadowH: i.high, shadowL: i.low, open: i.open, close: i.close)
        }
        
        let set1 = CandleChartDataSet(values: yValues, label: "")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = true
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
        
    }
}
