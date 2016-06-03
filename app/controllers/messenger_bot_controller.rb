class MessengerBotController < ActionController::Base
  def message(event, sender)
    # profile = sender.get_profile # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    puts "Received:".black
    log(event, sender)
    sender.reply([msg1(event), msg2].sample)
  end

  def delivery(event, sender)
    # puts "Delivered:".black
    # log(event, sender)
  end

  # Postbacks occur when a postback button on a Structured Message is tapped.
  # More info: developers.facebook.com/docs/messenger-platform/webhook-reference#Postback
  def postback(event, sender)
    puts "Postback:".black
    log(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
    end
  end

  private

  def log(event, sender)
    ap sender
    ap event
    puts '--------------'.black
  end

  def msg1(event)
    {
      'attachment':{
        'type': 'template',
        'payload': {
          'template_type': 'button',
          'text': "This is a test. You sent: '#{event['message']['text']}'",
          'buttons':[
            {
              'type':    'web_url',
              'url':     'https://petersapparel.parseapp.com',
              'title':   'Show Website'
            },
            {
              'type':    'postback',
              'title':   'Start Chatting',
              'payload': 'USER_DEFINED_PAYLOAD'
            }
          ]
        }
      }
    }
  end

  def msg2
    {
      "attachment":{
        "type":"template",
        "payload":{
          "template_type":"generic",
          "elements":[
            {
              "title":"Classic White T-Shirt",
              "image_url":"http://petersapparel.parseapp.com/img/item100-thumb.png",
              "subtitle":"Soft white cotton t-shirt is back in style",
              "buttons":[
                {
                  "type":"web_url",
                  "url":"https://petersapparel.parseapp.com/view_item?item_id=100",
                  "title":"View Item"
                },
                {
                  "type":"web_url",
                  "url":"https://petersapparel.parseapp.com/buy_item?item_id=100",
                  "title":"Buy Item"
                },
                {
                  "type":"postback",
                  "title":"Bookmark Item",
                  "payload":"USER_DEFINED_PAYLOAD_FOR_ITEM100"
                }
              ]
            },
            {
              "title":"Classic Grey T-Shirt",
              "image_url":"http://petersapparel.parseapp.com/img/item101-thumb.png",
              "subtitle":"Soft gray cotton t-shirt is back in style",
              "buttons":[
                {
                  "type":"web_url",
                  "url":"https://petersapparel.parseapp.com/view_item?item_id=101",
                  "title":"View Item"
                },
                {
                  "type":"web_url",
                  "url":"https://petersapparel.parseapp.com/buy_item?item_id=101",
                  "title":"Buy Item"
                },
                {
                  "type":"postback",
                  "title":"Bookmark Item",
                  "payload":"USER_DEFINED_PAYLOAD_FOR_ITEM101"
                }
              ]
            }
          ]
        }
      }
    }
  end
end
