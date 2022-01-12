import requests

_simbolo='BTC'

_url=f'https://api3.binance.com/api/v3/ticker/price?symbol={_simbolo}USDT'
# _url='https://api.binance.com/api/v3/exchangeInfo?symbol=BTCUSDT'

response = requests.get(_url)
data = response.json()

if response.status_code != 200:
    print('Failed to get data:', response.status_code)
else:
    print(data)


