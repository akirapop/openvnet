# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'bundler/setup'
require 'pry'
require_relative '../../vnspec'

Dir[File.expand_path('./support/*.rb', File.dirname(__FILE__))].map {|f| require f }
Dir[File.expand_path('./shared_examples/*.rb', File.dirname(__FILE__))].map {|f| require f }

RSpec.configure do |c|
  c.include Vnspec::Logger
  c.include Vnspec::Config

  c.run_all_when_everything_filtered = true
  c.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #c.order = 'random'

  c.add_formatter(:documentation)
  #c.add_formatter(:json)

  c.before(:all, :vm_skip_dhcp => true) do
    setup_vm(vm_use_dhcp: vm_use_dhcp)
  end

  c.before(:all, :vm_skip_dhcp => false) do
    setup_vm
  end

end
