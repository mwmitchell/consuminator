config.gem 'mislav-will_paginate',  :version => '2.3.8', :lib => 'will_paginate', :source => 'http://gems.github.com'
config.gem 'mwmitchell-rsolr',      :version => '0.8.2', :lib => 'rsolr',         :source => 'http://gems.github.com'
config.gem 'mwmitchell-rsolr-ext',  :version => '0.5.9', :lib => 'rsolr-ext',     :source => 'http://gems.github.com'

config.after_initialize{Consuminator.init}