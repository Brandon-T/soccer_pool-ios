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

class ImageLayer : CPTLayer {
    
    var image: UIImage?
    
    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func renderAsVectorInContext(ctx: CGContext) {
        super.renderAsVectorInContext(ctx)
        
        if let image = self.image {
            CGContextSaveGState(ctx);
            //CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
            //CGContextScaleCTM(ctx, 1.0, 1.0);
            
            
            CGContextDrawImage(ctx, CGRectMake(1.0, 2.0, self.bounds.size.height - 3.0, self.bounds.size.height - 6.0), image.CGImage)
            
            
            CGContextRestoreGState(ctx);
        }
    }
}

class HorizontalBarGraphView : CPTGraphHostingView, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTPlotSpaceDelegate {
    //Constants & Variables
    
    let barWidth = 0.95
    let barOffset = 0.95 / 2.0
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
    let graphBarColors = OrderedDictionary<String, UIColor>()
    let graphImages = OrderedDictionary<String, UIImage>()
    
    
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
        let backgroundColour = CPTColor(CGColor: UIColor.clearColor().CGColor)
        
        self.hostedGraph?.fill = CPTFill(color: backgroundColour)
        self.hostedGraph?.plotAreaFrame?.paddingTop = 30.0
        self.hostedGraph?.plotAreaFrame?.paddingBottom = 0.0
        self.hostedGraph?.plotAreaFrame?.paddingLeft = 30.0
        self.hostedGraph?.plotAreaFrame?.paddingRight = 0.0
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.delegate = self
        plotSpace.allowsUserInteraction = true
        plotSpace.allowsMomentum = true
        plotSpace.allowsMomentumX = true
        plotSpace.allowsMomentumY = false
        
        self.setRanges()
        
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
        self.hostedGraph?.titlePlotAreaFrameAnchor = .Top
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
        yAxis.labelingPolicy = .None
        yAxis.labelingOrigin = 0
        yAxis.orthogonalPosition = 0
        yAxis.majorIntervalLength = 1.0
        yAxis.minorTicksPerInterval = 1
        yAxis.majorGridLineStyle = nil
        yAxis.minorGridLineStyle = nil
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
                return self.graphData[Int(idx)]! + self.calculateImageWidth()
            }
        }
        
        return 0.0
    }
    
    func plotSpace(space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, forCoordinate coordinate: CPTCoordinate) -> CPTPlotRange? {
        
        if coordinate == CPTCoordinate.Y {
            if (newRange.locationDouble > Double(self.graphData.count)) {
                return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(self.graphData.count)), lengthDecimal: newRange.lengthDecimal)
            }
            
            if (newRange.locationDouble < 0.0) {
                return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0.0), lengthDecimal: newRange.lengthDecimal)
            }
            
            return CPTPlotRange(locationDecimal: newRange.locationDecimal, lengthDecimal: newRange.lengthDecimal)
        }
        
        return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0.0), lengthDecimal: CPTDecimalFromDouble(self.calculateXMax()))
    }
    
    func plotSpace(space: CPTPlotSpace, willDisplaceBy proposedDisplacementVector: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: proposedDisplacementVector.y)
    }
    
    func barFillForBarPlot(barPlot: CPTBarPlot, recordIndex idx: UInt) -> CPTFill? {
        if (barPlot.identifier as! String) == "BarGraphPlot" {
            return CPTFill(color: CPTColor(CGColor: self.graphBarColors[Int(idx)]!.CGColor))
        }
        return CPTFill(color: CPTColor.whiteColor())
    }
    
    func reloadData() {
        self.setRanges()
        self.renderAxisLabels()
        self.renderImagesAndPoints()
        self.hostedGraph?.reloadData()
    }
    
    func renderAxisLabels() {
        let yAxis = (self.hostedGraph?.axisSet as! CPTXYAxisSet).yAxis!
        
        var axisLabels = Set<CPTAxisLabel>()
        for i in 0..<self.graphData.count {
            let label = CPTAxisLabel(text: "#\(i + 1)", textStyle: yAxis.labelTextStyle)
            label.tickLocation = NSNumber(double: Double(i) + 0.5)
            label.rotation = 0.0
            label.offset = 5.0
            axisLabels.insert(label)
        }
        
        yAxis.axisLabels = Set(axisLabels.map { $0 })
    }
    
    func renderImagesAndPoints() {
        let plot: CPTPlot = self.hostedGraph!.plotWithIdentifier("BarGraphPlot")!
        plot.removeAllAnnotations()
        
        
        let style = CPTMutableTextStyle()
        style.color = CPTColor.whiteColor()
        style.fontSize = 12.0;
        style.fontName = "Helvetica-Bold";
        style.textAlignment = .Left
        
        let longestTextSize = CPTTextLayer(text: self.calculateLongestName(), style: style).bounds.size
        
        for idx in 0..<self.graphData.count {
            //Anchor Point
            let anchor = [0, idx]
            
            //Annotation For Text
            var firstName = self.graphData.keys[idx]
            if let range = self.graphData.keys[idx].rangeOfString(" ") {
                firstName = self.graphData.keys[idx].substringToIndex(range.startIndex)
            }
            
            
            let textLayer = CPTTextLayer(text: "\(firstName): \(Int(self.graphData[idx]!)) Pts", style: style)
            textLayer.paddingLeft = 45.0
            textLayer.paddingTop = 10.0 * CGFloat(self.barWidth)
            
            let posLayer = ImageLayer(frame: CGRectMake(0, 0, longestTextSize.width * 2, 35.0 * CGFloat(self.barWidth)), image: self.graphImages[idx])
            posLayer.addSublayer(textLayer)
            
            let symbolTextAnnotation = CPTPlotSpaceAnnotation(plotSpace:plot.plotSpace!, anchorPlotPoint:anchor);
            symbolTextAnnotation.contentLayer = posLayer;
            symbolTextAnnotation.displacement = CGPointMake(longestTextSize.width, (-31.0  * CGFloat(self.barWidth)) / 2.0);
            
            plot.addAnnotation(symbolTextAnnotation)
        }
    }
    
    func setRanges() {
        let xMin = 0.0
        let yMin = 0.0
        let xMax = self.calculateXMax()
        let yMax = Double(self.graphData.count)
        
        let xMagnitude = (xMax - xMin)
        let yMagnitude = (yMax - yMin)
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
        
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMagnitude))
        
        plotSpace.globalXRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMagnitude))
        
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0), lengthDecimal: CPTDecimalFromDouble(-15))
        
        plotSpace.globalYRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0), lengthDecimal: CPTDecimalFromDouble(yMagnitude))
    }
    
    func calculateXMax() -> Double {
        let sortedValues = self.graphData.values.values.sort { (first, second) -> Bool in
            return UInt(first) > UInt(second)
        }
        
        let result = 10 * ceil((Double(sortedValues.first ?? 0) / 10.0) + 0.5)
        return result + (result / 10.0)
    }
    
    func calculateLongestName() -> String {
        let sortedKeys = self.graphData.keys.sort { (first, second) -> Bool in
            return first.characters.count > second.characters.count
        }
        return sortedKeys.first!
    }
    
    func calculateImageWidth() -> Double {
        let sortedValues = self.graphData.values.values.sort { (first, second) -> Bool in
            return UInt(first) > UInt(second)
        }
        
        return ceil((Double(sortedValues.first ?? 0) / 10.0) + 0.5) + 0.5
    }
}
