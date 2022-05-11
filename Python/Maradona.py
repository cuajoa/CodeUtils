# *-* coding: utf-8 *-*
# Días sin el Diego
from datetime import datetime

fecha_inicio=datetime(2020, 11, 25)

delta=datetime.today()-fecha_inicio

message_post=str(delta.days)+" días sin Maradona \n"
message_post+=str(delta.days)+" days without Maradona \n\n"
message_post+="#maradona #HomenajeADiego"

print(message_post)


#Twittea

import tweepy 
# personal details 


# authentication of consumer key and secret 
my_auth = tweepy.OAuthHandler(my_consumer_key, my_consumer_secret) 
# Authentication of access token and secret 
my_auth.set_access_token(my_access_token, my_access_token_secret) 
my_api = tweepy.API(my_auth)
my_api.update_status(status=message_post)
