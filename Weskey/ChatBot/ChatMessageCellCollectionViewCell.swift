
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
        
        messageLabel.text = message.text
        
        if message.isUser {
            chatBotImageView.isHidden = true
            chatBotName.isHidden = true
        } else {
            chatBotImageView.isHidden = false
            chatBotName.isHidden = false
            chatBotImageView.image = UIImage(named: "chatbotCharacterChatting")
            chatBotName.text = "We's Key"
        }
        
        let userColor = UIColor(hex: "#632810")
        let botColor = UIColor(hex: "#632810")
        
        if message.isUser {
            messageBackgroundView.backgroundColor = UIColor.white
            messageBackgroundView.layer.borderColor = userColor.cgColor
            messageBackgroundView.layer.borderWidth = 1.0
            messageLabel.textColor = UIColor.black
            messageLabel.textAlignment = .right
            messageLabel.setLineSpacing(lineSpacing: 5)
            leadingConstraint.constant = 50
            trailingConstraint.constant = 0
        } else {
            messageBackgroundView.backgroundColor = botColor
            messageLabel.textColor = UIColor.white
            messageLabel.textAlignment = .left
            messageLabel.setLineSpacing(lineSpacing: 5)
            leadingConstraint.constant = 10
            trailingConstraint.constant = 50
        }
        
        messageBackgroundView.layer.cornerRadius = 10
        messageBackgroundView.clipsToBounds = true
        messageBackgroundView.layer.maskedCorners = message.isUser ? [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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

