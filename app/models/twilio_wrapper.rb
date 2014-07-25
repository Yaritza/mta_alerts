class TwilioWrapper
	attr_reader :client, :from, :alert_id
	
	def initialize(alert_id)
		@client = Twilio::REST::Client.new(ENV["STEVEN"], ENV["YOLO"])
		@from =  ENV["PHONE"]
		@alert_id=alert_id
	end


		
	def recipient_number
		Alert.find(@alert_id).recipient.phone_number
	end 

	def train_status
		name=Service.find_by(name: Alert.find_by(@alert_id).service_name).name
		traffic=Service.find_by(name: Alert.find_by(@alert_id).service_name).traffic
		"#{traffic} for #{name} as of #{Time.now}."
	end

	def sms
		client.account.messages.create(:from => from, :to => recipient_number, :body => train_status)
	end

	


end