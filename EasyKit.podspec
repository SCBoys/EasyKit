#
#  Be sure to run `pod spec lint EasyKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "EasyKit" # 项目名称
  s.version      = "1.1.5"        # 版本号 与 你仓库的 标签号 对应
  s.license      = "MIT"          # 开源证书
  s.summary      = "extenstion tool" # 项目简介

  s.homepage     = "https://github.com/SCBoys/EasyKit" # 你的仓库主页
  s.source       = { :git => "https://github.com/SCBoys/EasyKit.git", :tag => "#{s.version}" } #你的仓库地址，不能用SSH地址
  s.source_files = "EasyKit/**/*.{h,m}"
  s.requires_arc = true # 是否启用ARC
  s.platform     = :ios, "8.0" #平台及支持的最低版本
  s.frameworks   = "UIKit", "Foundation" #支持的框架
  # s.dependency   = "AFNetworking" # 依赖库

  # User
  s.author             = { "owliVendy" => "sxf19901213@gmail.com" } # 作者信息
  s.social_media_url   = "https://owlivendy.github.io/" #个人主页

end
