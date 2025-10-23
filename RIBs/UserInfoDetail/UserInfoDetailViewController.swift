//
//  UserInfoDetailViewController.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import UIKit
import Combine
import RIBs
import SnapKit

protocol UserInfoDetailPresentableListener: AnyObject {
    func didTapCloseButton()
}

final class UserInfoDetailViewController: UIViewController, UserInfoDetailViewControllable, UserInfoDetailPresentable {
    
    private var closeButton: UIButton!
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var userImageView: UIImageView!
    private var nameLabel: UILabel!
    private var usernameLabel: UILabel!
    private var emailLabel: UILabel!
    private var phoneLabel: UILabel!
    private var websiteLabel: UILabel!
    private var addressLabel: UILabel!
    private var companyLabel: UILabel!
    
    var listener: UserInfoDetailPresentableListener? // interactor와 연결
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI() {
        title = "사용자 상세"
        view.backgroundColor = .systemGray5
        
        self.view.do { superView in
            self.closeButton = UIButton().do {
                let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
                let image = UIImage(systemName: "xmark", withConfiguration: config)
                $0.setImage(image, for: .normal)
                $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(40)
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
                    $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(16)
                }
            }
            
            self.scrollView = UIScrollView().do { scrollView in
                superView.addSubview(scrollView)
                scrollView.snp.makeConstraints {
                    $0.top.equalTo(self.closeButton.snp.bottom).offset(16)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
                
                // ContentView
                self.contentView = UIView().do { contentView in
                    scrollView.addSubview(contentView)
                    contentView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                        $0.width.equalToSuperview()
                    }
                    
                    // User 이미지
                    self.userImageView = UIImageView().do {
                        $0.image = UIImage(systemName: "person.circle.fill")
                        $0.tintColor = .systemBlue
                        $0.contentMode = .scaleAspectFit
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalToSuperview().offset(20)
                            $0.centerX.equalToSuperview()
                            $0.width.height.equalTo(120)
                        }
                    }
                    
                    // 이름
                    self.nameLabel = UILabel().do {
                        $0.font = .boldSystemFont(ofSize: 24)
                        $0.textColor = .label
                        $0.textAlignment = .center
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.userImageView.snp.bottom).offset(16)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 사용자명
                    self.usernameLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .secondaryLabel
                        $0.textAlignment = .center
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.nameLabel.snp.bottom).offset(8)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 이메일
                    self.emailLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .label
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.usernameLabel.snp.bottom).offset(32)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 전화번호
                    self.phoneLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .label
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.emailLabel.snp.bottom).offset(16)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 웹사이트
                    self.websiteLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .label
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.phoneLabel.snp.bottom).offset(16)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 주소
                    self.addressLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .label
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.websiteLabel.snp.bottom).offset(16)
                            $0.leading.trailing.equalToSuperview().inset(20)
                        }
                    }
                    
                    // 회사
                    self.companyLabel = UILabel().do {
                        $0.font = .systemFont(ofSize: 16)
                        $0.textColor = .label
                        $0.numberOfLines = 0
                        
                        contentView.addSubview($0)
                        $0.snp.makeConstraints {
                            $0.top.equalTo(self.addressLabel.snp.bottom).offset(16)
                            $0.leading.trailing.equalToSuperview().inset(20)
                            $0.bottom.equalToSuperview().offset(-20)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: Display Method
    
    func displayPageInfo(_ user: User?) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = user?.name
            self?.usernameLabel.text = user?.username
            self?.emailLabel.text = "📧 \(user?.email ?? "")"
            self?.phoneLabel.text = "📞 \(user?.phone ?? "")"
            self?.websiteLabel.text = "🌐 \(user?.website ?? "")"
            self?.addressLabel.text = "📍 \(user?.address.street ?? ""), \(user?.address.suite ?? "") \n \(user?.address.city ?? ""), \(user?.address.zipcode ?? "")"
            self?.companyLabel.text = "🏢 \(user?.company.name ?? "")\n\(user?.company.catchPhrase ?? "")"
        }
    }
    
    
    // MARK: Events
    
    @objc private func closeButtonDidTap() {
        self.listener?.didTapCloseButton()
    }
}
