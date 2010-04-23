require 'rubygems'
require 'net/http'
require 'uri'

class PastiePlugin < Plugin
        
	def help(plugin, topic = "")
		case topic
			when '':
				"pastie: Manages pastie paste requests. " +
                                "Ask the bot for a pastie link using: " +
                                "'pastie', 'pastie me', or 'url me'. " +
                                "For example, 'botname: url me'. "
		end
	end
	
	def listen(m)
		# Ignore things unless we're directly talked to
		return unless m.address?
	
                # Return unless we're addressed properly	
		return unless m.message =~ /(pastie|pastie me|url me)/

                if m.message =~ /^(\S+)[:,]/
	          addressee = "#{$1}"
                else
		  addressee = m.sourcenick
	        end
		
                pastie
 
	        @bot.say "#{addressee}", "Your pastie URL is " + @url
        end

	private
        def pastie
                pastie_url = URI.parse("http://pastie.org/pastes")

                req = Net::HTTP::Post.new(pastie_url.path)
   
                body = "Click Paste Again to edit"
 
                form_data = {"paste[body]" => body, "paste[authorization]" => "burger"}
    
                req.set_form_data(form_data)
                req.add_field("User-Agent", "rbot pastie plugin")
    
                result = Net::HTTP.new(pastie_url.host, pastie_url.port).start {|http| http.request(req) }
                
                @url = result['location']
        end
end

plugin = PastiePlugin.new
