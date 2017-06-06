Pod::Spec.new do |spec|
  spec.name = 'Swish'
  spec.version = '2.0.3'
  spec.summary = 'Nothing but net(working)'
  spec.homepage = 'https://github.com/thoughtbot/Swish'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = {
    'Gordon Fontenot' => 'gordon@thoughtbot.com',
    'Sid Raval' => 'sid@thoughtbot.com',
    'thoughtbot' => nil,
  }
  spec.social_media_url = 'http://twitter.com/thoughtbot'
  spec.source = { :git => 'https://github.com/thoughtbot/Swish.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Source/**/*.{h,swift}'

  spec.dependency 'Result', '~> 3.1'

  spec.requires_arc = true

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.watchos.deployment_target = '2.0'
  spec.tvos.deployment_target = '9.0'
end
