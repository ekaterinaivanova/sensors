//
//  GraphView.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 29/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import UIKit

struct Points
{
    var x:Double
    var y: Double
    var z: Double
}

class GraphView: UIView {
    var isVissible = true
    var logScale = false
    var maxPoints = GlobalVariables.maxGraphPoints
    var maxValue = 1.5
    
    var graphPoints: [Points] = [ Points(x: 0, y: 0, z: 0)]
    
    
    var xColor: UIColor = UIColor.red
    var yColor: UIColor = UIColor.green
    var zColor: UIColor = UIColor.blue
    
    func changeData(_ poitns:[Points]){
        graphPoints = poitns
    }
    
    
    func addPoint(_ x:Double, y:Double, z:Double){
        if graphPoints.count >= maxPoints {
            graphPoints = Array(graphPoints.dropFirst())
        }
        
        graphPoints.append(Points(x: x, y: y, z: z))
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let xAxis = UIBezierPath()
        
        xAxis.move(to: CGPoint(x: 0.0, y: height/2))
        xAxis.addLine(to: CGPoint(x: width, y: height/2))
        xAxis.lineWidth = 1.0
        xAxis.stroke()
        
        
        let columnXPoint = { [unowned self] (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = width / CGFloat((self.maxPoints - 1))
            let x:CGFloat = CGFloat(column) * spacer
            
            return x
        }
        
        
        
        let columnYPoint = { (graphPoint:Points) -> (x:CGFloat, y:CGFloat,z:CGFloat) in
            if !self.logScale{
                let x:CGFloat = height/2 - (height/(2 * CGFloat(self.maxValue)) * CGFloat(graphPoint.x))
                let z:CGFloat = height/2 - (height/(2 * CGFloat(self.maxValue)) * CGFloat(graphPoint.z))
                let y:CGFloat = height/2 - (height/(2 * CGFloat(self.maxValue)) * CGFloat(graphPoint.y))
                return (x,y,z)
            }
            else{
                //TODO
                let x:CGFloat = 0
                let y:CGFloat = 0
                let z:CGFloat = 0
                return (x,y,z)
                
            }
        }
        
        struct GraphPath {
            let xPath = UIBezierPath()
            let yPath = UIBezierPath()
            let zPath = UIBezierPath()
        }
        
        let graphPath = GraphPath()
        
        let next = columnYPoint(graphPoints[0])
        
        graphPath.xPath.move(to: CGPoint(x: columnXPoint(0),y: next.x))
        graphPath.yPath.move(to: CGPoint(x: columnXPoint(0), y: next.y))
        graphPath.zPath.move(to: CGPoint(x: columnXPoint(0), y: next.z))
        
        
        
        for i in 1..<graphPoints.count {
            let nextY = columnYPoint(graphPoints[i])
            let nextX = columnXPoint(i)
            let nextPointX = CGPoint(x:nextX,y:nextY.x)
            let nextPointY = CGPoint(x:nextX,y:nextY.y)
            let nextPointZ = CGPoint(x:nextX,y:nextY.z)
            
            graphPath.xPath.addLine(to: nextPointX)
            graphPath.yPath.addLine(to: nextPointY)
            graphPath.zPath.addLine(to: nextPointZ)
            
            
        }
        
        xColor.setStroke()
        graphPath.xPath.lineWidth = 1.0
        graphPath.xPath.stroke()
        
        yColor.setStroke()
        graphPath.yPath.lineWidth = 1.0
        graphPath.yPath.stroke()
        
        zColor.setStroke()
        graphPath.zPath.lineWidth = 1.0
        graphPath.zPath.stroke()
        
        
    }
    
}
