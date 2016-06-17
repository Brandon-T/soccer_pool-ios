//
//  HorizontalBarGraphView.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-16.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import CorePlot

class HorizontalBarGraphView : CPTGraphHostingView, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTPlotSpaceDelegate {
    //Constants & Variables
    
    let barWidth = 0.5
    var delegate: BarGraphViewDelegate?
    
    var title: String {
        get {
            return self.hostedGraph?.title ?? ""
        }
        
        set {
            self.hostedGraph?.title = newValue
        }
    }
    
    let graphData = OrderedDictionary<String, Double>()
    var graphBarColors = OrderedDictionary<String, UIColor>()
    
    
    
    //Functions
    init() {
        super.init(frame: CGRectZero)
        
        self.initControls()
        self.setTheme()
        self.doLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initControls()
        self.setTheme()
        self.doLayout()
    }
    
    func initControls() {
        self.hostedGraph = CPTXYGraph(frame: CGRectZero)
    }
    
    func setTheme() {
        let xMin = 0.0
        let yMin = 0.0
        let xMax = self.calculateXMax()
        let yMax = Double(self.graphData.count)
        let barOffset = barWidth / 2.0
        let backgroundColour = CPTColor(CGColor: UIColor.clearColor().CGColor)
        
        self.hostedGraph?.fill = CPTFill(color: backgroundColour)
        self.hostedGraph?.plotAreaFrame?.paddingTop = 0.0
        self.hostedGraph?.plotAreaFrame?.paddingBottom = 0.0
        self.hostedGraph?.plotAreaFrame?.paddingLeft = 0.0
        self.hostedGraph?.plotAreaFrame?.paddingRight = 0.0
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.delegate = self
        plotSpace.allowsUserInteraction = true
        plotSpace.allowsMomentum = true
        plotSpace.allowsMomentumX = true
        plotSpace.allowsMomentumY = false
        
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMax), lengthDecimal: CPTDecimalFromDouble((yMax - yMin) * -1))
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMax), lengthDecimal: CPTDecimalFromDouble((yMax - yMin) * -1))
        
        //GridLines:
        let majorGridLineStyle = CPTMutableLineStyle()
        let minorGridLineStyle = CPTMutableLineStyle()
        
        majorGridLineStyle.lineWidth = 1.0
        majorGridLineStyle.lineColor = CPTColor.whiteColor()
        minorGridLineStyle.lineWidth = 0.5
        minorGridLineStyle.lineColor = CPTColor.whiteColor().colorWithAlphaComponent(0.5)
        
        //Axis:
        let xAxisTextStyle = CPTMutableTextStyle()
        xAxisTextStyle.fontName = "Arial"
        xAxisTextStyle.fontSize = 11.0
        xAxisTextStyle.color = CPTColor.whiteColor()
        
        let yAxisTextStyle = CPTMutableTextStyle()
        yAxisTextStyle.fontName = "Arial"
        yAxisTextStyle.fontSize = 12.0
        yAxisTextStyle.color = CPTColor.whiteColor()
        
        let axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineColor = CPTColor.whiteColor()
        axisLineStyle.lineWidth = 2.0
        
        
        self.hostedGraph?.title = self.title
        self.hostedGraph?.titleTextStyle = yAxisTextStyle
        self.hostedGraph?.titleDisplacement = CGPoint(x: 0.0, y: 0.0)
        
        
        let xAxis = (self.hostedGraph?.axisSet as! CPTXYAxisSet).xAxis!
        let yAxis = (self.hostedGraph?.axisSet as! CPTXYAxisSet).yAxis!
        
        xAxis.titleOffset = 30.0
        xAxis.labelOffset = 3.0
        xAxis.titleTextStyle = xAxisTextStyle
        xAxis.labelTextStyle = xAxisTextStyle
        xAxis.labelingPolicy = .None
        xAxis.labelingOrigin = 0
        xAxis.orthogonalPosition = 0
        xAxis.majorIntervalLength = 1.0
        xAxis.minorTicksPerInterval = 1
        xAxis.majorGridLineStyle = nil
        xAxis.minorGridLineStyle = nil
        xAxis.majorTickLineStyle = majorGridLineStyle
        xAxis.minorTickLineStyle = minorGridLineStyle
        xAxis.axisConstraints = CPTConstraints(lowerOffset: 0.0)
        xAxis.axisLineStyle = axisLineStyle
        
        yAxis.titleOffset = 40.0
        yAxis.labelOffset = 3.0
        yAxis.titleTextStyle = yAxisTextStyle
        yAxis.labelTextStyle = yAxisTextStyle
        yAxis.labelingPolicy = .Automatic
        yAxis.labelingOrigin = 0
        yAxis.orthogonalPosition = 0
        yAxis.majorIntervalLength = 1.0
        yAxis.minorTicksPerInterval = 1
        yAxis.majorGridLineStyle = majorGridLineStyle
        yAxis.minorGridLineStyle = minorGridLineStyle
        yAxis.majorTickLineStyle = majorGridLineStyle
        yAxis.minorTickLineStyle = minorGridLineStyle
        yAxis.axisConstraints = CPTConstraints(lowerOffset: 0.0)
        yAxis.axisLineStyle = axisLineStyle
        
        
        let plot = CPTBarPlot()
        plot.barsAreHorizontal = true
        plot.delegate = self
        plot.dataSource = self
        plot.barCornerRadius = 5.0
        plot.barWidth = barWidth
        plot.barOffset = barOffset
        
        let barBorderStyle = CPTMutableLineStyle()
        barBorderStyle.lineWidth = 1.0
        barBorderStyle.lineColor = CPTColor.whiteColor()
        
        plot.lineStyle = barBorderStyle
        plot.identifier = "BarGraphPlot"
        
        self.hostedGraph?.addPlot(plot)
    }
    
    func doLayout() {
        self.hostedGraph?.reloadData()
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return UInt(self.graphData.count)
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        if (plot.identifier as! String) == "BarGraphPlot" {
            if fieldEnum == UInt(CPTBarPlotField.BarLocation.rawValue) {
                return Int(idx)
            }
            else if fieldEnum == UInt(CPTBarPlotField.BarTip.rawValue) {
                return self.graphData[Int(idx)]
            }
        }
        
        return 0.0
    }
    
    func plotSpace(space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, forCoordinate coordinate: CPTCoordinate) -> CPTPlotRange? {
        
        if coordinate == CPTCoordinate.Y {
            if newRange.locationDouble > Double(self.graphData.count) {
                return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(self.graphData.count)), lengthDecimal: CPTDecimalFromDouble(Double((Double(self.graphData.count) - 0.0) * -1)))
            }
            
            return CPTPlotRange(locationDecimal: newRange.locationDecimal, lengthDecimal: newRange.lengthDecimal)
        }
        
        return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0.0), lengthDecimal: CPTDecimalFromDouble(Double(self.graphData.count)))
    }
    
    func plotSpace(space: CPTPlotSpace, willDisplaceBy proposedDisplacementVector: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: proposedDisplacementVector.x)
    }
    
    func barFillForBarPlot(barPlot: CPTBarPlot, recordIndex idx: UInt) -> CPTFill? {
        if (barPlot.identifier as! String) == "BarGraphPlot" {
            return CPTFill(color: CPTColor(CGColor: self.graphBarColors[Int(idx)]!.CGColor))
        }
        return CPTFill(color: CPTColor.whiteColor())
    }
    
    func reloadData() {
        let xMin = 0.0
        let yMin = 0.0
        let xMax = self.calculateXMax()
        let yMax = Double(self.graphData.count)
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMax), lengthDecimal: CPTDecimalFromDouble(-(yMax - yMin) - 1))
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMax), lengthDecimal: CPTDecimalFromDouble((yMax - yMin) * -1))
        
        self.hostedGraph?.reloadData()
    }
    
    func calculateXMax() -> Double {
        let sortedValues = self.graphData.values.values.sort { (first, second) -> Bool in
            return UInt(first) > UInt(second)
        }
        
        return 10 * ceil((Double(sortedValues.first ?? 0) / 10.0) + 0.5)
    }
}
