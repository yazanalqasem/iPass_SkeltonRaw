# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ipass_plus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ipass_plus
  pod 'Cosmos', '~> 23.0'
  pod 'DocumentReader', '~>7.4.3826'
#  pod 'DocumentReaderBeta', '~> 7.2.3488'
  pod 'NVActivityIndicatorView'
  pod 'PKHUD'
  pod 'ReachabilitySwift'
  pod 'Toast-Swift', '~> 5.1'
#  pod 'DocumentReaderFullAuth', '~> 7.1'
  pod 'DocumentReaderFullAuthRFID', '~>7.4.3826'
  pod 'AWSRekognition'
  pod 'AWSCore'
  pod 'Alamofire'
  pod 'EasyTipView', '~> 2.1'
#  pod 'DocumentReaderFullRFID'
  target 'ipass_plusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ipass_plusUITests' do
    # Pods for testing

  end

end


post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
