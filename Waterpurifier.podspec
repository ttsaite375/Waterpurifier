
Pod::Spec.new do |s|

  s.name         = "Waterpurifier"
  s.version      = "1.0.2"
  s.summary      = "小米净水器插件-iOS"
  s.description  = <<-DESC
  小米、、云米合作开发，iPhone端的小米净水器插件代码
                   DESC

  s.homepage     = "https://github.com/ttsaite375/Waterpurifier"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = { "云米科技" => "chenyang@viomi.com.cn" }
 
  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"

  s.source  = { :git => "https://github.com/ttsaite375/Waterpurifier.git", :tag => "#{s.version}" }

  s.source_files  = "Waterpurifier/Logic/*.{h,m,pch}","Waterpurifier/UI/*.{h,m,pch}","Waterpurifier/Supporting Files/*.{h,m,pch}"

  s.requires_arc = true

end
