
import UIKit

class PostingPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var SegmentSelectButton: UIButton!
    @IBOutlet weak var PostTitle: UITextField!
    @IBOutlet weak var PostContent: UITextView!
    @IBOutlet weak var reviewView: UIView!
    
    private let menuOptions = ["자유", "질문", "리뷰", "꿀팁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
        configTextView()
        configureSegmentSelectButton()
        reviewView.alpha = 0.0
        reviewView.isUserInteractionEnabled = false
        PostTitle.delegate = self
        PostContent.delegate = self
        
        setPlaceholderForTextField(PostTitle, placeholder: "제목을 입력하세요...")
        
        setPlaceholderForTextView(PostContent, placeholder: "내용을 입력하세요...")
    }
    
    func configTextField() {
        PostTitle.layer.borderColor = UIColor.lightGray.cgColor
        PostTitle.layer.borderWidth = 1.0
        PostTitle.layer.cornerRadius = 5.0
    }
    
    func configTextView() {
        PostContent.layer.borderColor = UIColor.lightGray.cgColor
        PostContent.layer.borderWidth = 1.0
        PostContent.layer.cornerRadius = 5.0
    }
    
    func configureSegmentSelectButton() {
        let menu = UIMenu(title: "", options: .displayInline, children: menuOptions.map { option in
            UIAction(title: option) { action in
                self.SegmentSelectButton.setTitle(option, for: .normal)
                self.updateReviewView(for: option)
            }
        })
        
        SegmentSelectButton.menu = menu
        SegmentSelectButton.showsMenuAsPrimaryAction = true
        SegmentSelectButton.changesSelectionAsPrimaryAction = true
    }
    
    func updateReviewView(for option: String) {
        if option == "리뷰" {
            reviewView.alpha = 1.0
            reviewView.isUserInteractionEnabled = true
        } else {
            reviewView.alpha = 0.0
            reviewView.isUserInteractionEnabled = false
        }
    }
    
    func setPlaceholderForTextField(_ textField: UITextField, placeholder: String) {
        textField.text = placeholder
        textField.textColor = .lightGray
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = .black
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            setPlaceholderForTextField(textField, placeholder: "제목을 입력하세요...")
        }
    }
        
    func setPlaceholderForTextView(_ textView: UITextView, placeholder: String) {
        textView.text = placeholder
        textView.textColor = .lightGray
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholderForTextView(textView, placeholder: "내용을 입력하세요...")
        }
    }
}

class reviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var smellStackView: UIStackView!
    @IBOutlet weak var tasteStackView: UIStackView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var wkName: UITextField!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var reviewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
        configTextView()
        setupRatingButtons(for: priceStackView)
        setupRatingButtons(for: smellStackView)
        setupRatingButtons(for: tasteStackView)
        registerForKeyboardNotifications()
        wkName.delegate = self
        reviewTitle.delegate = self
        reviewContent.delegate = self
        
        // Set placeholders
        setPlaceholderForTextField(wkName, placeholder: "위스키 제품명을 입력하세요.")
        setPlaceholderForTextField(reviewTitle, placeholder: "제목을 입력하세요...")
        setPlaceholderForTextView(reviewContent, placeholder: "내용을 입력하세요...")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardFrame.height
        }
    }
        
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupRatingButtons(for stackView: UIStackView) {
        let buttons = stackView.arrangedSubviews.compactMap { $0 as? UIButton }
        buttons.forEach { button in
            button.setImage(UIImage(named: "reviewUnfilledStar"), for: .normal)
            button.setImage(UIImage(named: "reviewFilledStar"), for: .selected)
            button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        }
    }
        
    @objc func ratingButtonTapped(_ sender: UIButton) {
        guard let buttons = sender.superview?.subviews.compactMap({ $0 as? UIButton }) else { return }
        let rating = buttons.firstIndex(of: sender)! + 1
        for (index, button) in buttons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    func configStarView() {
        starView.layer.borderColor = UIColor(red: 92/255, green: 43/255, blue: 23/255, alpha: 1.0).cgColor
        starView.layer.borderWidth = 1.0
        starView.layer.cornerRadius = 5.0
        starView.backgroundColor = UIColor.white
    }
        
    private func configTextField() {
        wkName.layer.borderColor = UIColor.lightGray.cgColor
        wkName.layer.borderWidth = 1.0
        wkName.layer.cornerRadius = 5.0
        
        reviewTitle.layer.borderColor = UIColor.lightGray.cgColor
        reviewTitle.layer.borderWidth = 1.0
        reviewTitle.layer.cornerRadius = 5.0
    }
        
    private func configTextView() {
        reviewContent.layer.borderColor = UIColor.lightGray.cgColor
        reviewContent.layer.borderWidth = 1.0
        reviewContent.layer.cornerRadius = 5.0
    }
    
    func setPlaceholderForTextField(_ textField: UITextField, placeholder: String) {
        textField.text = placeholder
        textField.textColor = .lightGray
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = .black
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            let placeholder = textField == wkName ? "위스키 제품명을 입력하세요." : "제목을 입력하세요..."
            setPlaceholderForTextField(textField, placeholder: placeholder)
        }
    }
        
    func setPlaceholderForTextView(_ textView: UITextView, placeholder: String) {
        textView.text = placeholder
        textView.textColor = .lightGray
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholderForTextView(textView, placeholder: "내용을 입력하세요...")
        }
    }
}
