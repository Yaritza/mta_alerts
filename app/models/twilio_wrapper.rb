class TwilioWrapper
	attr_reader :client, :from, :alert_id
	
	def initialize(alert_id)
		@client = Twilio::REST::Client.new(ENV["SID"], ENV["AUTH_TOKEN"])
		@from =  ENV["PHONE"]
		@alert_id=alert_id
	end
		
	#Finds a recipient's phone number
	def recipient_number
		Alert.find(@alert_id).recipient.phone_number
	end 

	#Finds the name of the train lines associated with a given alert.
	#Finds the traffic status associated that alert
	#Generate the string with the traffic status for the correspoding train lines in an alert

	def train_status
		name = Service.find_by(name: Alert.find(@alert_id).service_name).name
		traffic = Service.find_by(name: (Alert.find(@alert_id).service_name)).traffic
		"#{traffic} for #{name} as of #{Time.now.strftime('%I:%M%p')}"
	end

	# Sets up an SMS from the app's Twilio number to an alert's corresponding recipient's phone number 
	def sms
		client.account.messages.create(:from => from, :to => recipient_number, :body => train_status)
	end

  # This method is placeholder for implementation of a voice over IP messaging whereby a recipient can get 
  # the train status alerts via an automated phone call, rendering the app usable as a wake-up call. 
  # It requires a more predictable MTA feed than the one currently in use.

	# def call
	# 	client.account.calls.create(:from => from, :to => recipient_number, :url => build_url_for_phone_call)
	# end
	
end
