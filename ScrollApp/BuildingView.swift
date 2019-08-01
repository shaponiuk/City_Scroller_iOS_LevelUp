/*
 * BuildingView.swift
 * Created by Kajetan Dąbrowski on 25/03/2018.
 *
 * iOS Level Up 2018
 * Copyright 2018 DaftMobile Sp. z o. o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or  * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

fileprivate protocol RandomizableRange {
    static var all: [Self] { get }
}

extension RandomizableRange {
    static var random: Self {
        let all = self.all
        assert(!all.isEmpty)
        return all[Int.random(min: 0, max: all.count - 1)]
    }
}

class BuildingView: UIView {

    class func randomBuilding() -> BuildingView {
        let height = CGFloat.random(min: 350, max: maxBuildingHeight)
        let width = CGFloat.random(min: 120, max: 200)
        let windowSize = CGFloat.random(min: 21, max: 30)
        let windowsHorizontnal = Int(width / (windowSize + 20.0))
        let windowsVertical = Int((height - 100.0) / (windowSize + 20.0))

        return BuildingView(
            size: CGSize(width: width, height: height),
            color: UIColor.randomBrightColor(),
            windowSize: CGSize(width: windowSize, height: windowSize),
            windowsVertical: windowsVertical,
            windowsHorizontal: windowsHorizontnal,
            windowStyle: WindowStyle.random,
            floorStyle: FloorStyle.random)
    }

    class var maxBuildingHeight: CGFloat {
        return UIScreen.main.bounds.height + 50.0
    }

    private enum FloorStyle: RandomizableRange {
        case empty
        case none
        case circles

        static var all: [FloorStyle] { return [.empty, .none, .circles] }
    }

    private enum WindowStyle: RandomizableRange {
        case cross
        case empty

        static var all: [BuildingView.WindowStyle] { return [.cross, .empty] }
    }

    private let color: UIColor
    private let buildingSize: CGSize
    private let windowSize: CGSize
    private let windowsVertical: Int
    private let windowsHorizontal: Int
    private let floorStyle: FloorStyle
    private let windowStyle: WindowStyle
    private let strokeWidth: CGFloat = 2.0

    private init(size: CGSize, color: UIColor, windowSize: CGSize, windowsVertical: Int, windowsHorizontal: Int, windowStyle: WindowStyle, floorStyle: FloorStyle) {
        self.buildingSize = size
        self.color = color
        self.windowSize = windowSize
        self.windowsVertical = windowsVertical
        self.windowsHorizontal = windowsHorizontal
        self.windowStyle = windowStyle
        self.floorStyle = floorStyle
        super.init(frame: CGRect(origin: .zero, size: buildingSize))
    }

    override var intrinsicContentSize: CGSize {
        return buildingSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.darker.cgColor)

        let entranceHeight = buildingSize.height * 0.15
        let windowPaddingHorizontal = (buildingSize.width - (CGFloat(windowsHorizontal) * windowSize.width)) / CGFloat(windowsHorizontal + 1)
        let windowPaddingVertical = (buildingSize.height - entranceHeight - (CGFloat(windowsVertical) * windowSize.height)) / CGFloat(windowsVertical + 1)
        let floorIndicatorHeight = windowPaddingVertical * 0.3

        // step 1: draw the background
        let buildingRect = CGRect(origin: .zero, size: buildingSize)
        context.fill(buildingRect)

        // step 2: draw the stroke
        context.stroke(buildingRect.insetBy(dx: strokeWidth * 0.5, dy: strokeWidth * 0.5), width: strokeWidth)

        // step 3: draw the entrance
        let gateOriginY = CGFloat(windowsVertical) * (windowSize.height + windowPaddingVertical) + windowPaddingVertical
        let gateWidth = buildingSize.width * CGFloat.random(min: 0.2, max: 0.5)
        let gateHeight = buildingSize.height - gateOriginY
        let gateOriginX = buildingRect.midX - gateWidth * 0.5
        drawEntry(rect: CGRect.init(x: gateOriginX, y: gateOriginY, width: gateWidth, height: gateHeight), context: context)

        // step 4: loop and draw the windows and the patterns
        let windowsStartX: CGFloat = windowPaddingHorizontal
        let windowsStartY: CGFloat = (windowPaddingVertical + floorIndicatorHeight) * 0.5

        for windowIndexVertical in 0..<windowsVertical {
            for windowIndexHorizontal in 0..<windowsHorizontal {
                let origin = CGPoint(x: windowsStartX + CGFloat(windowIndexHorizontal) * (windowSize.width + windowPaddingHorizontal),
                                     y: windowsStartY + CGFloat(windowIndexVertical) * (windowSize.height + windowPaddingVertical))
                let rect = CGRect(origin: origin, size: windowSize)
                drawWindow(style: windowStyle, in: rect, context: context)

            }
        }

        // step 5: draw the floor indicators
        for floorIndicatorIndex in 0...windowsVertical {
            // draw floor indicator
            let floorIndicatorOrigin = CGPoint(x: 0, y: CGFloat(floorIndicatorIndex) * (windowSize.height + windowPaddingVertical))
            drawFloorIndicator(style: floorStyle, in: CGRect(origin: floorIndicatorOrigin, size: CGSize(width: buildingSize.width, height: floorIndicatorHeight)), context: context)
        }
    }

    private func drawFloorIndicator(style: FloorStyle, in rect: CGRect, context: CGContext) {
        context.saveGState()
        let background = color.darker
        let stroke = background.darker
        context.setFillColor(background.cgColor)
        context.setStrokeColor(stroke.cgColor)
        switch style {
        case .empty:
            context.fill(rect)
            context.stroke(rect)
        case .circles:
            context.fill(rect)
            context.stroke(rect)
            let strokeSize: CGFloat = 2.0
            let circleHeight = rect.height - strokeSize
            let circleSize: CGSize = CGSize(width: circleHeight, height: circleHeight)
            var x = rect.minX + strokeWidth * 0.5
            while x < rect.width {
                context.strokeEllipse(in: CGRect(origin: CGPoint(x: x, y: rect.minY + strokeSize * 0.5), size: circleSize))
                x += circleHeight * 0.75
            }
        case .none:
            break
        }
        context.restoreGState()
    }

    private func drawWindow(style: WindowStyle, in rect: CGRect, context: CGContext) {
        context.saveGState()
        let backgroundColor = color.darker
        let stroke = backgroundColor.darker
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(backgroundColor.cgColor)
        switch style {
        case .cross:
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 2.0).cgPath
            context.addPath(path)
            context.fillPath()

            context.move(to: CGPoint(x: rect.midX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            context.move(to: CGPoint(x: rect.minX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            context.addPath(path)
            context.strokePath()
        case .empty:
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 2.0).cgPath
            context.addPath(path)
            context.fillPath()
        }
        context.restoreGState()
    }

    private func drawEntry(rect: CGRect, context: CGContext) {
        context.saveGState()
        let backgroundColor = color.darker
        let stroke = backgroundColor.darker
        context.setStrokeColor(stroke.cgColor)
        context.setFillColor(backgroundColor.cgColor)

        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight] , cornerRadii: CGSize(width: 3, height: 3)).cgPath
        context.addPath(path)
        context.fillPath()
        context.addPath(path)
        context.strokePath()
        context.restoreGState()
    }
}
