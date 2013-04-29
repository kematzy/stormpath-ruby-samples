#!/usr/bin/env ruby

require 'optparse'
require 'rubygems'
require 'stormpath-sdk'

options = {}
help_called = false

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: ruby stormpath.rb COMMAND [OPTIONS]"
  opt.separator ""
  opt.separator "This script helps you test the Stormpath Ruby SDK."
  opt.separator ""
  opt.separator "If no option is specified, the Client instance is displayed with a 'to_s' call."
  opt.separator ""
  opt.separator  "Commands"
  opt.separator  "     file: use the specified file to retrieve API Key Information."
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-o","--option OPTION","Available options to perform on the Ruby SDK.") do |option|
    options[:option] = option
  end

  opt.separator  "         tenant: get the a Tenant representation based on the provided API Key" +
                         " with a call to 'inspect' on that Tenant."

  opt.on("-h","--help","Help on this script.") do

    puts opt_parser
    help_called = true

  end

  opt.separator  ""
  opt.separator  "Examples:"
  opt.separator  "    Get Tenant from file: ruby stormpath.rb file -o tenant YOUR_FILE_HERE_REPLACEME"

end

opt_parser.parse!

case ARGV[0]

  when "file"

    opt = options[:option]

    file = ARGV[1]


    if !file.nil? and File::exist? file

      client = Stormpath::Client.new({
        api_key_file_location: file
      })

      if (opt == 'tenant')

        puts "Getting tenant from Client..."
        begin

          puts client.tenant.inspect

          puts "Done"

        rescue Stormpath::Error => re

          p '** Error Retrieving Tenant **'
          p 'Message: ' + re.message
          p 'HTTP Status: ' + re.get_status.to_s
          p 'Developer Message: ' + re.get_developer_message
          p 'More Information: ' + re.get_more_info
          p 'Error Code: ' + re.get_code.to_s

        end

      else

        puts "Showing Client instance..."
        puts client.to_s
        puts "Done"

      end



    else

      puts "File #{file} does not exist."

    end

  else

    if !help_called
       puts opt_parser
    end


end
