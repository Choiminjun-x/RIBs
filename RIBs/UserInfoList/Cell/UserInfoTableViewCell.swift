//
//  UserInfoTableViewCell.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import UIKit
import SnapKit

final class UserInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
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
            
            // 프로필 이미지뷰 설정
            profileImageView.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.equalToSuperview().inset(16)
                    $0.centerY.equalToSuperview()
                    $0.size.equalTo(50)
                }
            }
            
            // 화살표 이미지뷰 설정 (먼저 생성)
            chevronImageView.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.trailing.equalToSuperview().inset(16)
                    $0.centerY.equalToSuperview()
                    $0.size.equalTo(CGSize(width: 8, height: 13))
                }
            }
            
            // 이름 라벨 설정
            nameLabel.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
                    $0.top.equalToSuperview().inset(12)
                    $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
                }
            }
            
            // 이메일 라벨 설정
            emailLabel.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.trailing.equalTo(nameLabel)
                    $0.top.equalTo(nameLabel.snp.bottom).offset(2)
                }
            }
            
            // 회사 라벨 설정
            companyLabel.do {
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.leading.trailing.equalTo(nameLabel)
                    $0.top.equalTo(emailLabel.snp.bottom).offset(2)
                    $0.bottom.lessThanOrEqualToSuperview().inset(12)
                }
            }
        }
    }
    
    // MARK: - Configuration
    
    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        companyLabel.text = user.company.name
        
        // 프로필 이미지 설정 (기본 아이콘)
        setupProfileImage(for: user)
    }
    
    private func setupProfileImage(for user: User) {
        // SF Symbol을 사용한 기본 프로필 이미지
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let profileImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        
        profileImageView.image = profileImage
        profileImageView.tintColor = .white
        profileImageView.backgroundColor = generateColorForUser(user)
    }
    
    private func generateColorForUser(_ user: User) -> UIColor {
        // 사용자 ID를 기반으로 일관된 색상 생성
        let colors: [UIColor] = [
            .systemBlue, .systemGreen, .systemOrange, .systemPurple,
            .systemRed, .systemTeal, .systemIndigo, .systemPink
        ]
        return colors[user.id % colors.count]
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        emailLabel.text = nil
        companyLabel.text = nil
    }
}
