# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

def rx_swift
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
end

def facebook
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
end

def firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
end

target 'WoofRunner' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WoofRunner
  pod 'iCarousel', '~> 1.8'
  pod 'SnapKit', '~> 3.2.0'
  pod 'BrightFutures'
  pod 'PopupDialog', '~> 0.5'
  pod 'Google/SignIn'
  rx_swift
  facebook
  firebase
end
