//
//  BarGraph+Animations.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-11.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import CorePlot

extension BarGraphView {
    
    func scrollToIndex(index: Int) -> Void {
        if let isScrolling: Bool = self.getObject("isScrolling") {
            if isScrolling {
                return
            }
        }
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace!
        let range = plotSpace?.plotRangeForCoordinate(CPTCoordinate.X)
        let forwards: Bool = range!.locationDouble < Double(index)
        
        if range!.locationDouble.equals(Double(index)) {
            self.setObject(false, key: "isScrolling")
            self.removeObject("index")
            return
        }
        
        self.setObject(true, key: "isScrolling")
        self.setObject(range!.locationDouble, key: "index")
        
        
        NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(scroll), userInfo: ["index": Double(index), "forwards": forwards], repeats: true)
    }
    
    func pulseColour(index: Int) -> Void {
        if let isPulsing: Bool = self.getObject("isPulsing") {
            if isPulsing {
                return
            }
        }
        
        self.setObject(true, key: "isPulsing")
        self.setObject(0, key: "ticks")
        self.setObject(true, key: "pulsed")
        
        let range = NSRange(location: index, length: 1)
        let colour = self.graphBarColors[index]!
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(pulse), userInfo: ["index": index, "range": range, "colour": colour], repeats: true)
    }
    
    @objc private func pulse(timer: NSTimer) -> Void {
        var userInfo = timer.userInfo as! [String: AnyObject]
        let range = userInfo["range"] as! NSRange
        let index = userInfo["index"] as! Int
        let colour = userInfo["colour"] as! UIColor
        let plot = self.hostedGraph?.plotWithIdentifier("BarGraphPlot") as! CPTBarPlot
        
        let ticks: Int = self.getObject("ticks")!
        let pulsed: Bool = self.getObject("pulsed")!
        
        if ticks == 5 {
            timer.invalidate()
            self.graphBarColors[index] = colour
            plot.reloadBarFillsInIndexRange(range)
            self.setObject(0, key: "ticks")
            self.setObject(true, key: "pulsed")
            self.setObject(false, key: "isPulsing")
            return
        }
        
        self.graphBarColors[index] = pulsed ? colour : UIColor.whiteColor().colorWithAlphaComponent(0.7)
        plot.reloadBarFillsInIndexRange(range)
        
        self.setObject(!pulsed, key: "pulsed")
        self.setObject(ticks + 1, key: "ticks")
    }
    
    @objc private func scroll(timer: NSTimer) -> Void {
        let userInfo = timer.userInfo as! [String: AnyObject]
        let index = userInfo["index"] as! Double
        let forwards = userInfo["forwards"] as! Bool
        
        let plotSpace = self.hostedGraph?.defaultPlotSpace!
        let range = plotSpace?.plotRangeForCoordinate(CPTCoordinate.X)?.mutableCopy() as! CPTMutablePlotRange
        range.locationDouble += forwards ? 0.1 : -0.1
        plotSpace?.setPlotRange(range, forCoordinate: CPTCoordinate.X)
        
        if range.locationDouble.equals(index) {
            timer.invalidate()
            
            self.setObject(false, key: "isScrolling")
            self.removeObject("index")
        }
    }
}