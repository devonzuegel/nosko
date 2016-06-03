class MessengerBotController < ActionController::Base
  def message(event, sender)
    # profile = sender.get_profile # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    puts "==============================================".black
    puts "Received:".black
    log(event, sender)
    puts "Sending...".black
    ap msg
    puts "------------".black
    sender.reply(msg)
    puts "==============================================".black
  end

  def delivery(event, sender)
    puts "==============================================".black
    puts "Delivered:".black
    log(event, sender)
    puts "==============================================".black
  end

  # Postbacks occur when a postback button on a Structured Message is tapped.
  # More info: developers.facebook.com/docs/messenger-platform/webhook-reference#Postback
  def postback(event, sender)
    puts "==============================================".black
    puts "Postback:".black
    log(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
    end
    puts "==============================================".black
  end

  private

  def log(event, sender)
    # ap sender
    ap event
    puts '--------------'.black
  end

  def msg
    buttons = User.first.findings.take(5).map { |f| button(f) }
    {
      "attachment":{
        "type":"template",
        "payload":{
          "template_type":"button",
          "text":"Last week, you read:",
          "buttons": buttons
        }
      }
    }
  end

  def button(finding)
    {
      "type":  "web_url",
      "url":   "https://#{ENV['domain_name']}/finding/#{finding.to_param}",
      "title": finding.title
    }
  end

  # def msg3
  #   {
  #     'text': "Hello smallbusiness.chron.com/adding-links-facebook-messages-30012.html goodbye github.com/devonzuegel/nosko/tree/staging/app/assets/javascripts/components/form-templates"
  #   }
  # end
end
