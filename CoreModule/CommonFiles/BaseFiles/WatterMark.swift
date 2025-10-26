//
//  WatterMark.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import UIKit

class WatermarkView: UIView {
    
    private var text: String
    private var textColor: UIColor
    private var font: UIFont
    
    init(frame: CGRect, text: String, textColor: UIColor = UIColor.black.withAlphaComponent(0.05), font: UIFont = .systemFont(ofSize: 20)) {
        self.text = text
        self.textColor = textColor
        self.font = font
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false // allow touches to pass through
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(textColor.cgColor)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        let textSize = text.size(withAttributes: attributes)
        
        let rowCount = 3
        let columnCount = 3
        
        let horizontalSpacing = rect.width / CGFloat(columnCount)
        let verticalSpacing = rect.height / CGFloat(rowCount)
                
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                let x = CGFloat(column) * horizontalSpacing
                let y = CGFloat(row) * verticalSpacing
                
                let string = NSAttributedString(string: text, attributes: attributes)
                
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                
                context?.translateBy(x: x + horizontalSpacing / 2, y: y + verticalSpacing / 2)
                context?.rotate(by: -CGFloat.pi / 4)
                context?.translateBy(x: -(textSize.width / 2), y: -(textSize.height / 2))
                
                string.draw(at: .zero)
                
                context?.restoreGState()
            }
        }

        
    }
}
