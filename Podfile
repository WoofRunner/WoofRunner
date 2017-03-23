# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

def rx_swift
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
end

target 'WoofRunner' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WoofRunner
  pod 'iCarousel', '~> 1.8'
  rx_swift
  pod 'BrightFutures'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'iCarousel', '~> 1.8'
  rx_swift

  target 'WoofRunnerTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase/Core'
    pod 'Firebase/Database' # Because Firebase sets up their pods weirdly.
  end

  target 'WoofRunnerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
