
# *-* coding: utf-8 *-*

from zeep import Client
url = "https://svcvf.ad-cap.com.ar/Reportes.svc?wsdl"

# Here's an example for calling data to a fake weather API.
data = {
   "pGUID": None,
   "pReporteMFCICheckRequest":{
    "FechaDesde": "2020-12-22",
    "FechaHasta": "2020-12-23",
    "NumCuotapartista":None}
}
# It would have to know how to interact with the client
# wsdl_url = "weather_service_url.com/?wsdl" # always ending in "wsdl" (web service description language"
# Now python knows what functions parameters are 
# available and creates a client you can interact with.
soap_client = Client(url)
# Then interact with the client like a class object
api_result = soap_client.service.MFCICheck_Solicitudes(**data)

print(api_result)