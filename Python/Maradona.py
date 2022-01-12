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
# Bearer Token AAAAAAAAAAAAAAAAAAAAAMaRKAEAAAAAGJ6B%2BKLzbdNriSbXnRzm4F7mJns%3D8x7vcsY4CKuYvpOHwPbDg56Ft4iLZvFd0Ke8KRKPpAJycMJspK

my_consumer_key ="z1CV1lsZfQiNJhtrMlU0LVcgQ"
my_consumer_secret ="l5CreecFlP2O0OCF7zlq8iUrFK4k25tIHxk8v5w1YbbjO5Ka6d"
my_access_token ="1332367072542724096-Ode2PiJWhFH0ofdLYySlZ1fSZcHsYc"
my_access_token_secret ="S82ViM2mDUxaoKqm8OcuoXpgSypdRDjG4iSy2S3GlI4Lq"
# authentication of consumer key and secret 
my_auth = tweepy.OAuthHandler(my_consumer_key, my_consumer_secret) 
# Authentication of access token and secret 
my_auth.set_access_token(my_access_token, my_access_token_secret) 
my_api = tweepy.API(my_auth)
my_api.update_status(status=message_post)