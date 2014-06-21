require 'pty'
require 'expect'

module Lte
  class Session

    def initialize(options = {}, &blk)
      @host = options[:host]
      @user = options[:user]
      @password = options[:password]
      @password_pat = options[:password_pat] || %r/Password:/io
      @prompt_pat = options[:prompt_pat] || %r/^LTE-8X/io
      $expect_verbose = true if options[:debug] == true
      begin
        @o, @i = PTY.spawn("ssh -oStrictHostKeyChecking=no #{@user}@#{@host}")
        @i.sync = true
        @o.expect(@password_pat){ @i.puts @password }
        @o.expect(/#{@password_pat}|#{@prompt_pat}/io) do |output|
          abort "Incorrect username or password!" if output.first =~ @password_pat
          @i.puts
        end
      rescue
        abort "Could not connect to device #{@host}!"
      end
    end

    # Run command
    def cmd(command, options = {})
      @o.expect(@prompt_pat){ @i.puts command }
      get_result(:array => options[:result_array]) if options[:get_result] == true
    end

    # Getting results in a list
    def get_list(command)
      out = []
      cmd(command)
      get_result(:array => true).each do |line|
        out << line.split(/\s+/)
      end
      out
    end

    # Reconfigure ONT
    def ont_reconfigure(ont_mac)
      cmd "ont_mac #{ont_mac}"
      cmd "reconfigure"
      ret_val = (get_result =~ /successfully reconfigured/m ? true : false)
      cmd "exit"
      return ret_val
    end

    # Setting ONT profile and reconfigure
    def set_ont_profile_and_reconfigure(options = {})
      ont_mac = options[:ont_mac]
      profile_index = options[:profile_index] || 0
      profile_name = options[:profile_name] || "ipmc"
      cmd "ont_mac #{ont_mac}"
      cmd "set profile #{profile_name} #{profile_index}"
      cmd "reconfigure"
      ret_val = (get_result =~ /successfully reconfigured/m ? true : false)
      cmd "exit"
      return ret_val
    end

    private

    # Getting result
    def get_result(options = {})
      array = options[:array] || false
      out = []
      @o.expect(@prompt_pat) do |output|
        out = output.first.split(/\n/)
        @i.puts
      end
      array ? out[1..-2] : out[1..-2].join("\n")
    end

  end
end
