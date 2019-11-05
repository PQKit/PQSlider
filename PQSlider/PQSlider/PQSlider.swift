//
//  PQSlider.swift
//  PQSlider
//
//  Created by 盘国权 on 2019/11/5.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

open class PQSlider: UISlider {
    
    public typealias ValueChangeClosure = (Float) -> ()
    
    // MARK: - public property
    /// default is empty
    open var colors: [UIColor] = []
    /// default is empty
    open var locations: [CGFloat] = []
    /// default is nil
    open var borderColor: UIColor? = nil
    /// default is 0
    open var borderWidth: CGFloat = 0
    /// default is 0
    open var colorHeight: CGFloat = 20
    /// default is 0.1s
    open var timeSpan: TimeInterval = 0.1
    
    
    // MARK: - system method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initData()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if lastColorHeight != colorHeight {
            lastColorHeight = colorHeight
            let y = (frame.height - colorHeight) * 0.5
            imgView.frame = CGRect(x: 0, y: y, width: frame.width, height: colorHeight)
            drawImage()
        }
    }
    
    // MARK: - public method
    
    /// reload UI
    open func reloadUI() {
        drawImage()
    }
    
    /// listen value change
    /// - Parameter closure: closure
    public func listen(_ closure: ValueChangeClosure?) {
        valueChangeClosure = closure
    }
    
    // MARK: - private property
    private lazy var imgView: UIImageView = {
       let view = UIImageView()
        return view
    }()
    /// value change closure
    private var valueChangeClosure: ValueChangeClosure?
    private var lastTime: TimeInterval = CFAbsoluteTimeGetCurrent()
    private var lastColorHeight: CGFloat = 0
}

// MARK: - private method
private extension PQSlider {
    func initData() {
        
        insertSubview(imgView, at: 4)
        
        tintColor = .clear
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
        
        addTarget(self, action: #selector(valueChange), for: .valueChanged)
        addTarget(self, action: #selector(endMove), for: .touchUpInside)
        addTarget(self, action: #selector(endMove), for: .touchUpOutside)
    }
    
    @objc func valueChange() {
        guard let closure = valueChangeClosure else { return }
        if timeSpan == 0 {
            closure(value)
        }
        else if CFAbsoluteTimeGetCurrent() - lastTime > timeSpan {
            lastTime = CFAbsoluteTimeGetCurrent()
            closure(value)
        }
    }
    
    @objc func endMove() {
        valueChange()
    }
    
    func drawImage() {
        let image = UIColor.image(colors: colors, locations: locations, size: CGSize(width: frame.width, height: colorHeight), borderWidth: borderWidth, borderColor: borderColor)
        imgView.image = image
    }
}

// MARK: - private extension
private extension UIColor {
    static func image(colors: [UIColor],
                      locations: [CGFloat],
                      size: CGSize,
                      borderWidth: CGFloat,
                      borderColor: UIColor?) -> UIImage? {
        
        guard !colors.isEmpty, !locations.isEmpty else {
            print("Colors and locations must has value")
            return nil
        }
        
        guard colors.count == locations.count else {
            print("Please make sure colors and locations count is equal")
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        if  borderWidth > 0 ,
            let borderColor = borderColor {
            let rect = CGRect(x: size.width * 0.01, y: 0, width: size.width * 0.98, height: size.height)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: size.height * 0.5)
            borderColor.setFill()
            path.fill()
        }
        
        let rect = CGRect(x: size.width * 0.01 + borderWidth, y: borderWidth, width: size.width * 0.98 - borderWidth * 2, height: size.height - borderWidth * 2)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: size.height * 0.5)

        drawLinerGradient(ctx: ctx!, path: path.cgPath, colors: colors, locations: locations)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func drawLinerGradient(ctx: CGContext,
                                  path: CGPath,
                                  colors: [UIColor],
                                  locations: [CGFloat]) {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors.map { $0.cgColor } as CFArray, locations: locations)
        
        let pathRect = path.boundingBoxOfPath
        
        let startPoint = CGPoint(x: pathRect.minX, y: pathRect.midY)
        let endPoint = CGPoint(x: pathRect.maxX, y: pathRect.midY)
        
        ctx.saveGState()
        
        ctx.addPath(path)
        ctx.clip()
        ctx.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))
        ctx.restoreGState()
    }
}
