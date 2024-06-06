import UIKit

class ChatMessageCell: UICollectionViewCell {
    @IBOutlet weak var chatBotName: UILabel!
    @IBOutlet weak var chatBotImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    func configure(with message: Message) {
            messageLabel.text = message.text
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            
            let maxMessageWidth = UIScreen.main.bounds.width - 20
            let messageTextWidth = messageLabel.sizeThatFits(CGSize(width: maxMessageWidth, height: CGFloat.greatestFiniteMagnitude)).width
            let constrainedWidth = min(maxMessageWidth, messageTextWidth)
            
            let fixedWidth: CGFloat = 150
            let finalWidth = (messageTextWidth <= fixedWidth) ? fixedWidth : constrainedWidth
            
            if message.isUser {
                chatBotImageView.isHidden = true
                chatBotName.isHidden = true
                leadingConstraint.constant = max(30, UIScreen.main.bounds.width - finalWidth)
                trailingConstraint.constant = 10
            } else {
                chatBotImageView.isHidden = false
                chatBotName.isHidden = false
                chatBotImageView.image = UIImage(named: "chatbotCharacterChatting")
                chatBotName.text = "We's Key"
                leadingConstraint.constant = 10
                trailingConstraint.constant = max(50, UIScreen.main.bounds.width - finalWidth - 10)
            }
            
            let userColor = UIColor(hex: "#632810")
            messageBackgroundView.backgroundColor = message.isUser ? UIColor.white : userColor
            messageLabel.textColor = message.isUser ? UIColor.black : UIColor.white
            messageLabel.textAlignment = message.isUser ? .right : .left
            
            messageBackgroundView.layer.cornerRadius = 10
            messageBackgroundView.layer.borderWidth = 1.0
            messageBackgroundView.layer.borderColor = userColor.cgColor
            
            layoutIfNeeded()
        }
    }

    extension UIColor {
        convenience init(hex: String) {
            var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if hexString.hasPrefix("#") {
                hexString.remove(at: hexString.startIndex)
            }
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
