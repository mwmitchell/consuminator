config.gem 'mislav-will_paginate',  :lib => 'will_paginate', :source => 'http://gems.github.com'
config.gem 'mwmitchell-rsolr',      :version => '0.9.5', :lib => 'rsolr',         :source => 'http://gems.github.com'
config.gem 'mwmitchell-rsolr-ext',  :version => '0.9.5', :lib => 'rsolr-ext',     :source => 'http://gems.github.com'

config.after_initialize{Consuminator.init(config)}