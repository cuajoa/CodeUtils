# *-* coding: utf-8 *-*

import requests
from datetime import datetime

url="https://svcvf.bnzlab.com/Reportes.svc"
fecha=datetime.today().strftime("%Y-%m-%d") 

headers = {'content-type': 'text/xml; charset=utf-8'}
body = """<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:vf="http://schemas.datacontract.org/2004/07/VF.ServiceLayer.Model" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:MFCICheck_Solicitudes>
         <tem:pReporteMFCICheckRequest>
            <vf:FechaDesde>"""+datetime.today().strftime("%Y-%m-%d")  +"""</vf:FechaDesde>
            <vf:FechaHasta>"""+datetime.today().strftime("%Y-%m-%d") +"""</vf:FechaHasta>
            <vf:NumCuotapartista xsi:nil="true"></vf:NumCuotapartista>
         </tem:pReporteMFCICheckRequest>
      </tem:MFCICheck_Solicitudes>
   </soapenv:Body>
</soapenv:Envelope>"""

# print(body)

body = body.format(user='', password='')
body = body.encode('utf-8')

session = requests.session()
session.headers = headers
session.headers.update({"Content-Length": str(len(body))})
response = session.post(url=url, data=body, verify=True)

x=response.content
x=str(x,"UTF-8")
# sessionid=x[ x.index("<SessionID>")+11 : x.index("</SessionID>") ]


print("-------------------------")
print (x)

from bs4 import BeautifulSoup
xml = response.content
soup = BeautifulSoup(xml, 'xml')
if soup.find_all('Result', text='0'):
    print ("door opened")
else:
    print("door not opened")
