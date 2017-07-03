# ReactiveCocoa  
ReactiveCocoa结合AFNetworking的简单使用，以及RAC在UI控件例如UIButton上的简单使用

#Cocoapod配置ReactiveCocoa时需要加上use_frameworks!
platform :ios, '8.0'
use_frameworks!

target 'ReactiveCocoaDemo' do
    pod 'ReactiveCocoa'
    pod 'AFNetworking', '~> 2.5.0'
end
