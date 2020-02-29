//
//  KeyboardTrackableViewController.swift
//  FutureFeature
//
//  Created by abobrov on 23/08/2018.
//  Copyright © 2018 neolant. All rights reserved.
//

import UIKit

class KeyboardTrackableViewController: BaseViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint? // unused
    @IBOutlet weak var mainScrollView: UIScrollView?

    private let _keyboardManager = KeyboardManager()
    
    public var savedInset : CGFloat = 0

    @objc func textChanged(notification: NSNotification) {
        if mainScrollView != nil,
            let sender = notification.object as? UIView,
            sender is UITextInput,
            sender.isDescendant(of: mainScrollView!) {

            scrollToCaret(in: sender as! UIView & UITextInput)
        }
    }

    let caretInset : CGFloat = 8

    func scrollToCaret(in input: UIView & UITextInput) {
        guard let mainScrollView = self.mainScrollView else { return }


        if let caretPosition = input.selectedTextRange?.start {
            let caretRect = input.caretRect(for: caretPosition)

            let translatedRect = mainScrollView.convert(caretRect, from: input).insetBy(dx: -caretInset, dy: -caretInset)


            mainScrollView.scrollRectToVisible(translatedRect, animated: true)

            //let test = input.selectionRects(for: selection).map { ($0 as! UITextSelectionRect).rect } // возвращает некорректный размер ({+infinity, +infinity, 0 ,0})
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mainScrollView = self.mainScrollView else { return }

        savedInset = mainScrollView.contentInset.bottom

        _keyboardManager
            .on(.willChangeFrame) { [weak self] options in
                guard let `self` = self else { return }

                if (options.startFrame == options.endFrame) {
                    return
                }

                let scrollerFrame = self.view.convert(mainScrollView.frame, from: mainScrollView.superview)
                let scrollerBottomSpace = self.view.frame.height - scrollerFrame.minY - scrollerFrame.height
                let keyboardVisibleHeight = max(0, self.view.frame.height - options.endFrame.minY)
                let bottomInset = max(self.savedInset, keyboardVisibleHeight - scrollerBottomSpace)

                UIView.animate(withDuration: options.animationDuration) {
                    mainScrollView.contentInset.bottom = bottomInset
                    mainScrollView.scrollIndicatorInsets.bottom = bottomInset

                    if let firstResponder = self.view.currentFirstResponder {
                        if let textInput = firstResponder as? UIView & UITextInput {
                            self.scrollToCaret(in: textInput)
                        } else { // кастомный респондер не являющийся текстовым полем (например, date picker)
                            let frame = mainScrollView.convert(firstResponder.frame, from: firstResponder.superview)
                            mainScrollView.scrollRectToVisible(frame, animated: false) // Мы уже внутри анимации
                        }
                    }
                }
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _keyboardManager.start()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _keyboardManager.stop()

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextFieldTextDidChange,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextViewTextDidChange,
                                                  object: nil)

    }
}
