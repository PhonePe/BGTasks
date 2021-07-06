Pod::Spec.new do |s|
  s.name             = 'BGTasks'
  s.version          = '1.0.2'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary          = 'A wrapper over iOS provided BackgroundTasks framework to ensure smooth onboarding of usecases and handle all the complex functionalities of BackgroundTasks within it.'
  s.homepage         = 'https://github.com/PhonePe/BGTasks'
  s.author           = { 'Shridhara V' => 'shridhara.v@phonepe.com' }
  s.source           = { :git => 'https://github.com/PhonePe/BGTasks.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  # s.osx.deployment_target = '10.12'
  # s.watchos.deployment_target = '3.0'
  # s.tvos.deployment_target = '10.0'
  
  s.swift_version = '5.0'
  
  s.frameworks = 'CoreData'

  s.default_subspec = "Core"

  s.subspec 'Core' do |core|
    core.source_files = 'BGTasks/Core/Classes/**/*.{swift,h,m}'
    core.resources = "BGTasks/Core/Assets/*.xcdatamodeld"
  end

# s.test_spec 'BGFrameworkTests' do |test_spec|
#       test_spec.source_files = 'Example/Tests/*.swift', 'Example/Tests/**/*.swift'
#       test_spec.resources = "../../App/PhonePe/Assets.xcassets"
#       test_spec.dependency 'Senpai'
#   end
end