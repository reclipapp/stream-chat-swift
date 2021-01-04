//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

open class MessageComposerInputTextView<ExtraData: ExtraDataTypes>: UITextView,
    AppearanceSetting,
    Customizable,
    UIConfigProvider
{
    // MARK: - Properties
            
    lazy var textViewHeightConstraint = heightAnchor.constraint(equalToConstant: .zero)
    
    // MARK: - Subviews
    
    public lazy var placeholderLabel: UILabel = UILabel().withoutAutoresizingMaskConstraints
    
    // MARK: - Overrides
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        
        setUp()
        (self as! Self).applyDefaultAppearance()
        setUpAppearance()
        setUpLayout()
        updateContent()
    }
    
    // MARK: Public
    
    open func defaultAppearance() {
        font = .preferredFont(forTextStyle: .callout)
        textContainer.lineFragmentPadding = 10
        textColor = uiConfig.colorPalette.text
        
        placeholderLabel.font = font
        placeholderLabel.textColor = uiConfig.colorPalette.messageComposerPlaceholder
        placeholderLabel.textAlignment = .center
        
        backgroundColor = .clear
    }
    
    open func setUp() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    open func setUpAppearance() {}
    
    open func setUpLayout() {
        embed(placeholderLabel, insets: .init(
            top: .zero,
            leading: textContainer.lineFragmentPadding,
            bottom: .zero,
            trailing: .zero
        ))
        placeholderLabel.pin(anchors: [.centerY], to: self)
        
        isScrollEnabled = false
        
        textViewHeightConstraint.isActive = true
    }
    
    open func updateContent() {}
    
    @objc func textDidChange() {
        delegate?.textViewDidChange?(self)
        placeholderLabel.isHidden = !text.isEmpty
        textViewHeightConstraint.constant = calculatedTextHeight() + textContainerInset.bottom + textContainerInset.top
        layoutIfNeeded()
    }
}
