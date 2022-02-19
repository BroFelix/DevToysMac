//
//  BrightnessBarView.swift
//  DevToys
//
//  Created by yuki on 2022/02/19.
//

import CoreUtil

final class BrightnessBarView: NSLoadView {
    var color: Color = .default { didSet { self.updateHandle(); updateColorLayer() } }
    let lightnessPublisher = PassthroughSubject<CGFloat, Never>()
    
    private let handleLayer = ColorPickerHandleLayer()
    private let colorLayer = CAGradientLayer.animationDisabled()
    
    override func layout() {
        super.layout()
        self.colorLayer.frame = bounds
        self.updateHandle()
    }
    
    override func mouseDown(with event: NSEvent) {
        self.sendLocation(event.location(in: self))
    }
    override func mouseDragged(with event: NSEvent) {
        self.sendLocation(event.location(in: self))
    }
    
    private func sendLocation(_ location: CGPoint) {
        self.lightnessPublisher.send((location.y / bounds.height).clamped(0...1))
    }
    
    private func updateColorLayer() {
        self.colorLayer.colors = [
            NSColor(colorSpace: .current, hue: color.hue, saturation: color.saturation, brightness: 0, alpha: 1).cgColor,
            NSColor(colorSpace: .current, hue: color.hue, saturation: color.saturation, brightness: 1, alpha: 1).cgColor
        ]
    }
    
    private func updateHandle() {
        self.handleLayer.color = color.withAlpha(1).cgColor
        self.handleLayer.frame.center = [bounds.midX, color.brightness * bounds.height]
    }
    
    override func onAwake() {
        self.snp.makeConstraints{ make in
            make.width.equalTo(R.ColorPicker.barWidth)
        }
        self.wantsLayer = true
        self.layer?.addSublayer(colorLayer)
        self.layer?.addSublayer(handleLayer)
        self.layer?.cornerRadius = R.Size.corner
        self.layer?.borderWidth = 1
        self.layer?.borderColor = CGColor.black.withAlpha(0.2)
    }
}
