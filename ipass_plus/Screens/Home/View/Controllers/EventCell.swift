import UIKit

class EventCell: UICollectionViewCell {
    
    let eventImageView = UIImageView()
    let eventTitleLabel = UILabel()
    let eventDateLabel = UILabel()
    let eventTagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.layer.cornerRadius = 15
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventImageView)
        
        eventTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventTitleLabel.textColor = .white
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventTitleLabel)
        
        eventDateLabel.font = UIFont.systemFont(ofSize: 16)
        eventDateLabel.textColor = .white
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventDateLabel)
        
        eventTagLabel.font = UIFont.systemFont(ofSize: 14)
        eventTagLabel.textColor = .yellow
        eventTagLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventTagLabel)
        
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            eventTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            
            eventDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            eventDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            eventTagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            eventTagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func configure(with event: Event) {
       // contentView.backgroundColor = .white
       // eventImageView.image = UIImage(named: event.imageName)
        let randomColor = UIColor.random()
        if(event.title == "Event 1") {
            eventImageView.backgroundColor = .clear
            eventTitleLabel.text = ""
            eventDateLabel.text = ""
            eventTagLabel.text = ""

        }
       else if(event.title == "Event 8") {
            eventImageView.backgroundColor = .clear
           eventTitleLabel.text = ""
           eventDateLabel.text = ""
           eventTagLabel.text = ""
        }
        else {
            eventImageView.backgroundColor = randomColor
            eventTitleLabel.text = event.title
//            eventDateLabel.text = event.date
//            eventTagLabel.text = event.tag
           // eventTitleLabel.text = "Event Name"
            eventDateLabel.text = event.date
            eventTagLabel.text = event.tag
        }
        
       
        
    }
}


extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
