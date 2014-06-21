# Eltex::Lte

This gem aims to provide transport-flexible functionality, for easy communication with Eltex LTE devices. It currently allows you to execute commands on a device and get back the output of those commands.

Eltex LTE-8X central office node terminal is designed to provide a broadband access over Passive Optical Network (PON). Access to provider transport network  is realized by 10 Gigabit and combo Gigabit uplink interfaces. GPON interfaces are used for connection to Passive Optical distribution Network (PON). It is possible to connect up to 128 subscriber optical terminals to each interface by one fiber. Dynamic Bandwidth Allocation (DBA) enables to provide downstream rate up to 2.5 Gbps.

## Installation

Install from githib:

    git clone git@github.com:gordienko/eltex-lte.git
    cd eltex-lte
    gem build eltex-lte.gemspec
    gem install eltex-lte-<version>.gem

Add this line to your application's Gemfile:

    gem 'eltex-lte'

And then execute:

    $ bundle

Or install it yourself as:
    
    $ gem install eltex-lte

## Usage

### This library is used as follows:

    require 'eltex/lte'

    lte = Lte::Session.new(:host => "10.0.0.1", :user => "username", :password => "accesspass")
    output = lte.cmd "add ont config XX:XX:XX:XX:XX:XX", :get_result => true
    lte.cmd "ont_mac XX:XX:XX:XX:XX:XX"
    lte.cmd "set description Petr Ivanov"
    lte.cmd "set profile rules 1"
    lte.cmd "set profile ipmc 2"
    output = lte.cmd "reconfigure", :get_result => true
    
    output =~ /successfully reconfigured/m
        puts "OK!"
    else
        puts "ERROR!"
    end
    
    lte.cmd "exit"

### Additional Connection Parameters

    :password_pat => %r/Password:/io - Pattern password prompt string device
    :prompt_pat => %r/^LTE-8X/io - Pattern prompt string device
    :debug => true - Enable debug mode

### Additional examples of the use of library

Get data from the device in a list:

    lte.cmd("show profile rules list", :get_result => true, :result_array => true).each do |l|
      puts l.split(/\s+/)
    end

Get data from the device in a list (way shorter):

    lte.get_list("show ont list verbose all").each do |l|
        puts l
    end

Setting profiles ONT followed reconfiguration:

    lte.set_ont_profile_and_reconfigure(:ont_mac => "XX:XX:XX:XX:XX:XX", :profile_index => 2, :profile_name => "ipmc")

Reconfiguration ONT:

    if lte.ont_reconfigure("0E:00:02:00:27:28")
      puts "ONT uccessfully reconfigured"
    end

## Contributing

1. Fork it ( http://github.com/gordienko/eltex-lte/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
