class TwilioWrapper
	attr_reader :client, :from, :alert_id
	
	def initialize(alert_id)
		@client = Twilio::REST::Client.new(ENV["SID"], ENV["AUTH_TOKEN"])
		@from =  ENV["PHONE"]
		@alert_id=alert_id
	end
		
	def recipient_number
		Alert.find(@alert_id).recipient.phone_number
	end 

	def train_status
		name =Service.find_by(name: Alert.find(@alert_id).service_name).name
		traffic =Service.find_by(name: (Alert.find(@alert_id).service_name)).traffic
		"#{traffic} for #{name} as of #{Time.now.strftime('%I:%M%p')}"
	end

	def sms
		client.account.messages.create(:from => from, :to => recipient_number, :body => train_status)
	end

	def call
		client.account.calls.create(:from => from, :to => recipient_number, :url => build_url_for_phone_call)
	end
	


end
