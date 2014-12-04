Pod::Spec.new do |spec|
  spec.name         = 'DTKeychain'
  spec.version      = '1.0.0'
  spec.summary      = "A simple and modern keychain wrapper."
  spec.homepage     = "https://github.com/Cocoanetics/DTKeychain"
  spec.author       = { "Oliver Drobnik" => "oliver@cocoanetics.com" }
  spec.documentation_url = 'http://docs.cocoanetics.com/DTKeychain'
  spec.social_media_url = 'https://twitter.com/cocoanetics'
  spec.source       = { :git => "https://github.com/Cocoanetics/DTKeychain.git", :tag => spec.version.to_s }
  spec.ios.deployment_target = '6.0'
  spec.osx.deployment_target = '10.6'
  spec.license      = 'BSD'
  spec.requires_arc = true

  spec.subspec 'Core' do |ss|
    ss.ios.deployment_target = '4.3'
    ss.osx.deployment_target = '10.6'
    ss.source_files = 'Core/Source/*.{h,m}'
  end
end
