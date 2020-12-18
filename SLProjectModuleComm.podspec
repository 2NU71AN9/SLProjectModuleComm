Pod::Spec.new do |s|

s.name         = "SLProjectModuleComm"
s.version      = "1.0.0"
s.swift_version  = "5.0"
s.summary      = "通用模块"
s.description  = "这是通用模块"
s.homepage     = "https://github.com/2NU71AN9/SLProjectModuleComm" #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" } #开源协议
s.author       = { "孙梁" => "1491859758@qq.com" }
s.platform     = :ios, "11.0"
s.source       = { :git => "https://github.com/2NU71AN9/SLProjectModuleComm.git", :tag => "{s.version}" } #存储库的git地址，以及tag值

s.source_files  =  "SLProjectModuleComm/Class/**/*.{h,m,swift}" #需要托管的源代码路径
s.resources = ['SLProjectModuleComm/Assets.xcassets', 'SLProjectModuleComm/Class/**/*.xib']
s.requires_arc = true #是否支持ARC

s.dependency "SLSupportLibrary"
s.dependency "IQKeyboardManagerSwift"
s.dependency "SVProgressHUD"
s.dependency "SwiftDate"
s.dependency "Kingfisher"
s.dependency "SwiftyJSON"
s.dependency "R.swift"
s.dependency "YYCache"
s.dependency "JXSegmentedView"
s.dependency "JXPagingView"
s.dependency "FSPagerView"
s.dependency "TagListView"
s.dependency "HXPhotoPicker"
s.dependency "Moya"
s.dependency "Starscream"
s.dependency "SLEmptyPage"
s.dependency "FSTextView"
s.dependency "ESTabBarController-swift"
s.dependency "SwiftLint"
s.dependency "CTMediator"
s.dependency "NewPopMenu"
  
  #友盟
s.dependency "UMCCommon"
s.dependency "UMCCommonLog" #开发阶段进行调试SDK及相关功能使用，可在发布 App 前移除
s.dependency "UMCShare/UI" #分享
s.dependency "UMCShare/Social/WeChat"
s.dependency "UMCPush" #推送
  
  #Bugly
s.dependency "Bugly"


end
