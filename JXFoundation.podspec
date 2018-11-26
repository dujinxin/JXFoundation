#
# Be sure to run `pod lib lint JXFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXFoundation'
  s.version          = '1.0.2'
  s.summary          = '自定义view，以及平时自己常用的一些方法扩展'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/dujinxin/JXFoundation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dujinxin' => '510033463@qq.com' }
  s.source           = { :git => 'https://github.com/dujinxin/JXFoundation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '9.0'
  s.swift_version    = '4.2'
  # s.source_files = 'JXFoundation/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JXFoundation' => ['JXFoundation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  

  s.subspec 'Constant' do |ss|
      ss.source_files = 'JXFoundation/Classes/Constant/**/*'
      ss.dependency 'JXFoundation/UIKit+Extension'
  end
  s.subspec 'Foundation+Extension' do |ss|
      ss.source_files = 'JXFoundation/Classes/Foundation+Extension/**/*'
  end
  s.subspec 'UIKit+Extension' do |ss|
      ss.source_files = 'JXFoundation/Classes/UIKit+Extension/**/*'
      ss.dependency 'JXFoundation/Foundation+Extension'
  end
  s.subspec 'JXManager' do |ss|
      ss.source_files = 'JXFoundation/Classes/JXManager/**/*'
      ss.dependency 'JXFoundation/Constant'
  end
  s.subspec 'JXView' do |ss|
      ss.source_files = 'JXFoundation/Classes/JXView/**/*'
      ss.dependency 'JXFoundation/Foundation+Extension'
      ss.dependency 'JXFoundation/UIKit+Extension'
      ss.dependency 'JXFoundation/Constant'
  end
end
