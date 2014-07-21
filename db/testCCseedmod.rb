require 'open-uri'
require 'nokogiri'
require 'pry'
require 'pp'

####For Line seeds#####
 class Line
  def names
    names = ["123", "456","7", "ACE", "BDFM", "G", "JZ", "L", "NQR", "S", "SIR" ]
  end
end

line = Line.new

puts "Loading train_lines" 
line.names.each  do |names|
  Line.create(name: name)
end
puts "#{Line.count} line records have been added."


#####Service seeds######

class Service

  attr_accessor :doc, :train_name_array, :status_array, :description, :delay_header, :output_hash

  def initialize
    @output_hash = Hash.new {|hash, key| hash[key] = {}} # the final array that can hold all the information
    @doc = Nokogiri::XML(open("http://web.mta.info/status/serviceStatus.txt"))
  end

  def descriptive_status
    @doc.xpath('//subway//line').each do |line|

      train_name = line.at_css("/name").text

      train_status = line.at_css("status").text
      @output_hash[train_name][:status] = train_status 
      super_descriptive = line.xpath("text")

      html = Nokogiri::HTML(super_descriptive.text)

          if train_status == "GOOD SERVICE"
            super_descriptive = "On time"
          else  
            html.css(".plannedWorkDetailLink").each do |detail|
            planned_work = detail.children.text
            @output_hash[train_name][:header] = planned_work
            end
      html.css(".plannedWorkDetail").each do |detail|
        planned_work_detail = detail.children.text
        @output_hash[train_name][:details] = planned_work_detail
      end

      html.css(".TitleDelay").each do |detail| # working with this 
        title_delay = detail.children.text
        @output_hash[train_name][:title_delay] = title_delay
      end

      html.css(".TitleServiceChange").each do |detail|
        title_service_change = detail.children.text
        @output_hash[train_name][:service_change] = title_service_change
      end       
       puts @output_hash
      end 
    end 
  end

end

 service = Service.new
 binding.pry

# puts "deleting old seeds"
# Service.delete_all
# puts "loading"

service.descriptive_status.each do |train_name, info|
  Service.create(name: train_name, traffic: info[:status], description: info[:header], more_details: info[:details], line_id: Line.find_by name: train_name)
  end

puts "finished loading"

