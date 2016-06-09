//
//  BarGraphView.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-07.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import CorePlot


protocol BarGraphViewDelegate {
    func barSelected(barGraph: BarGraphView, index: UInt) -> Void
}


class BarGraphView : CPTGraphHostingView, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTPlotSpaceDelegate {
    
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
    
    let graphData = OrderedDictionary<String, AnyObject>()
    
    
    
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
        let xMax = 4.0
        let yMax = 10.0
        let barOffset = barWidth / 2.0
        let backgroundColour = CPTColor(CGColor: UIColor.clearColor().CGColor)
        
        self.hostedGraph?.fill = CPTFill(color: backgroundColour)
        self.hostedGraph?.plotAreaFrame?.paddingTop = 30.0
        self.hostedGraph?.plotAreaFrame?.paddingBottom = 10.0
        self.hostedGraph?.plotAreaFrame?.paddingLeft = 35.0
        self.hostedGraph?.plotAreaFrame?.paddingRight = 10.0
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.delegate = self
        plotSpace.allowsUserInteraction = true
        plotSpace.allowsMomentum = true
        plotSpace.allowsMomentumX = true
        plotSpace.allowsMomentumY = false
        
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
        plotSpace.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(Double(self.graphData.count) <= xMax ? xMax : Double(self.graphData.count) - (1.0 - barWidth)))
        
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
    
    func barFillForBarPlot(barPlot: CPTBarPlot, recordIndex idx: UInt) -> CPTFill? {
        func getBarColor(idx: UInt) -> CPTColor {
            /*let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            return CPTColor(componentRed: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)*/
            
            let colour: UIColor = UIColor(hue: CGFloat(idx) / CGFloat(self.graphData.count), saturation: 0.9, brightness: 0.9, alpha: 1.0)
            return CPTColor(CGColor: colour.CGColor)
        }
        
        if (barPlot.identifier as! String) == "BarGraphPlot" {
            return CPTFill(color: getBarColor(idx))
        }
        return CPTFill(color: CPTColor.whiteColor())
    }
    
    func plotSpace(space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, forCoordinate coordinate: CPTCoordinate) -> CPTPlotRange? {
        
        if coordinate == CPTCoordinate.X {
            if newRange.locationDouble < 0.0 {
                return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0.0), lengthDecimal: CPTDecimalFromDouble(Double(newRange.length)))
            }
            
            return CPTPlotRange(locationDecimal: newRange.locationDecimal, lengthDecimal: newRange.lengthDecimal)
        }
        
        return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0.0), lengthDecimal: CPTDecimalFromDouble(10.0))
    }
    
    func plotSpace(space: CPTPlotSpace, willDisplaceBy proposedDisplacementVector: CGPoint) -> CGPoint {
        return CGPoint(x: proposedDisplacementVector.x, y: 0)
    }
    
    func barPlot(plot: CPTBarPlot, barWasSelectedAtRecordIndex idx: UInt) {
        if self.delegate != nil {
            self.delegate!.barSelected(self, index: idx)
        }
    }
    
    func reloadData() {
        let xMin = 0.0
        let yMin = 0.0
        let xMax = 4.0
        let yMax = 10.0
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
        plotSpace.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(Double(self.graphData.count) <= xMax ? xMax : Double(self.graphData.count) - (1.0 - barWidth)))
        
        self.hostedGraph?.reloadData()
    }
}