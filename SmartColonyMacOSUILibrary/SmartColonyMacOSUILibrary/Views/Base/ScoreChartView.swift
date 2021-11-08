//
//  ScoreChartView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.11.21.
//

import SwiftUI
import Charts

class ScoreDataLine {

    let color: NSColor
    let values: [Double]

    init(color: NSColor, values: [Double]) {

        self.color = color
        self.values = values
    }

    func dataEntries() -> [ChartDataEntry] {

        return self.values.enumerated().map { (index, value) in
            return ChartDataEntry(x: Double(index), y: value)
        }
    }
}

class ScoreData {

    var lines: [ScoreDataLine]

    init(lines: [ScoreDataLine]) {

        self.lines = lines
    }
}

struct ScoreChartView: NSViewRepresentable {

    @Binding
    var data: ScoreData

    /*class CustomChartFormatter: AxisValueFormatter {
        var days: [String]

        init(days: [String]) {
            self.days = days
        }

        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return days[Int(value-1)]
        }
    }*/

    init(data: Binding<ScoreData>) {

        self._data = data
    }

    func makeNSView(context: Context) -> LineChartView {

        let chart = LineChartView()

        chart.chartDescription.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = true
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = true
        chart.drawBordersEnabled = false
        chart.legend.form = .none
        chart.xAxis.labelCount = 7
        chart.xAxis.forceLabelsEnabled = false
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1
        //chart.xAxis.valueFormatter = CustomChartFormatter(days: days)
        chart.drawGridBackgroundEnabled = true
        chart.gridBackgroundColor = .black.withAlphaComponent(0.5)

        chart.data = addData()

        return chart
    }

    func updateNSView(_ nsView: LineChartView, context: Context) {

        nsView.data = addData()
    }

    func addData() -> LineChartData {

        let dataSets = self.data.lines.map {
            generateLineChartDataSet(
                dataSetEntries: $0.dataEntries(),
                color: $0.color,
                fillColor: NSColor.clear
            )
        }

        return LineChartData(dataSets: dataSets)
    }

    func generateLineChartDataSet(dataSetEntries: [ChartDataEntry], color: NSColor, fillColor: NSColor) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: dataSetEntries, label: "")
        dataSet.colors = [color]
        dataSet.mode = .stepped
        dataSet.circleRadius = 1
        dataSet.circleHoleColor = color
        dataSet.fill = ColorFill(color: fillColor)
        dataSet.drawFilledEnabled = false
        dataSet.setCircleColor(NSColor.clear)
        dataSet.lineWidth = 2
        dataSet.valueTextColor = color
        dataSet.valueFont = NSFont(name: "Avenir", size: 12)!
        dataSet.drawValuesEnabled = false
        return dataSet
    }
}
