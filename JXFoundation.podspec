#
# Be sure to run `pod lib lint JXFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXFoundation'
  s.version          = '2.0.3.3'
  s.summary          = '基类，自定义view，extension，方法工具，用于快速集成'

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
  s.swift_version    = '5.1'
  # s.source_files = 'JXFoundation/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JXFoundation' => ['JXFoundation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'Basic' do |ss|
      ss.source_files = 'JXFoundation/Classes/Basic/**/*'
      ss.dependency 'JXFoundation/Core'
      ss.dependency 'JXFoundation/UIKit'
  end
  s.subspec 'Core' do |ss|
      ss.source_files = 'JXFoundation/Classes/Core/**/*'
  end
  s.subspec 'UIKit' do |ss|
      ss.source_files = 'JXFoundation/Classes/UIKit/**/*'
      ss.dependency 'JXFoundation/Core'
  end
end
