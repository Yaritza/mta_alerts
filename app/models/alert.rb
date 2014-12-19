class Alert < ActiveRecord::Base
  belongs_to :recipient  
  has_many :services
  validates_presence_of :start
  validates_presence_of :end

# Determines whether or not a train lines have traffic updates not specified a "Good Service" 
	def bad_service?
		Service.find_by(name: self.service_name).traffic != "GOOD SERVICE"
	end

#Checks the current train status of a given train line(s)
	def current_train_status
		Service.find_by(name: self.service_name).traffic
	end

#Checks if there are changes to the train service status as compared to the last train status sent out to a recipient.
	def changed_service?
		(self.last_alert_status != nil) && (self.last_alert_status != self.current_train_status)
	end

	def new_bad_service?
		self.bad_service? && self.last_alert_status != self.current_train_status
	end

	#checks if alert object is selected within critical timeframe of recipient
	def relevant_time?
		self.start <= DateTime.now && self.end >= DateTime.now
		# (self.start.hour <= DateTime.now.hour) (self.start.minute <= DateTime.now.minute) && (self.end.hour >	DateTime.now.hour) 
	end

	def assign_value_of_changed_status
		self.update_attributes(last_alert_status: Service.find_by(name: self.service_name).traffic)
	end

	# def reset_last_sent
	# 	if (Time.now.to_f - alert.last.to_f) % 86400  > 0
	# 	alert.update_attributes(sent_at: nil, last_alert_status: nil) 
	# 	end
	# end

	def transmogrify
		assign_value_of_changed_status
		update_attributes(last_sent: DateTime.now)

	end
###Relates to creating text to voice calls.
	def obtain_description
		#it's only pulling traffic train status for now, but we will get it to pull out the description instead.
		Service.find_by(name: self.service_name).traffic
	end

	def add_more_details
		Service.find_by(self.service_name).more_detail
	end

	def build_url_for_phone_call
		message0 = obtain_description.gsub(" ","+")
		message1 = add_more_details.gsub(" ","+")
		"http://twimlets.com/message?Message[0]=" + "#{message_0}" + "&Message[1]=" + "#{message1}"
	end

	#We are following this url example below to to format the url for a call:
	# http://twimlets.com/message?Message[0]=http://myserver.com/1.mp3&Message[1]=http://myserver.com/2.mp3&Message[2]=I+Just+Played+A+File&Message[3]=I+Just+Said+Some+Text

	def call

	end
	

end
