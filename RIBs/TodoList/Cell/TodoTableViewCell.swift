
//
//  TodoTableViewCell.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import UIKit
import SnapKit

final class TodoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // 셀 스타일 설정
        backgroundColor = .secondarySystemGroupedBackground
        selectionStyle = .default
        
        // 서브뷰 추가 및 레이아웃 설정
        contentView.do { superView in
            
            // 체크마크 이미지뷰 설정
            checkmarkImageView.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.equalToSuperview().inset(16)
                    $0.centerY.equalToSuperview()
                    $0.size.equalTo(24)
                }
            }
            
            // 상태 라벨 설정
            statusLabel.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.trailing.equalToSuperview().inset(16)
                    $0.centerY.equalToSuperview()
                    $0.width.equalTo(50)
                    $0.height.equalTo(20)
                }
            }
            
            // 제목 라벨 설정
            titleLabel.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.equalTo(checkmarkImageView.snp.trailing).offset(12)
                    $0.top.equalToSuperview().inset(12)
                    $0.trailing.equalTo(statusLabel.snp.leading).offset(-8)
                    $0.bottom.lessThanOrEqualToSuperview().inset(12)
                }
            }
        }
    }
    
    // MARK: - Configuration
    
    func configure(with todo: Todo) {
        // Title: always set a fresh attributed string with explicit color
        let attributed = NSMutableAttributedString(string: todo.title)
        let color: UIColor = todo.completed ? .secondaryLabel : .label
        attributed.addAttribute(.foregroundColor,
                                 value: color,
                                 range: NSRange(location: 0, length: attributed.length))
//        if todo.completed {
//            attributed.addAttribute(.strikethroughStyle,
//                                    value: NSUnderlineStyle.single.rawValue,
//                                    range: NSRange(location: 0, length: attributed.length))
//        }
        titleLabel.attributedText = attributed
        
        // Checkmark and status
        if todo.completed {
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.tintColor = .systemGreen
            statusLabel.text = "완료"
            statusLabel.backgroundColor = .systemGreen
            statusLabel.textColor = .white
        } else {
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = .systemGray3
            statusLabel.text = "진행중"
            statusLabel.backgroundColor = .systemOrange
            statusLabel.textColor = .white
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkImageView.image = nil
        titleLabel.text = nil
        titleLabel.attributedText = nil
        titleLabel.textColor = .label
        statusLabel.text = nil
        statusLabel.backgroundColor = .clear
        statusLabel.textColor = .label
    }
}
