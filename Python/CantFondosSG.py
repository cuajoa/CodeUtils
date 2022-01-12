# *-* coding: utf-8 *-*

from datetime import datetime, timedelta
from common.general import general
from decimal import Decimal
from common.connection import MongoDB
import matplotlib.pyplot as plt

def agregate(esEsco):
    mongo_db = MongoDB.getCollection(collection_name='patrimonio')
    cotizacion_usd=93.75

    fecha_hasta=datetime.today()- timedelta(days=15)
    fecha_desde=datetime.today()- timedelta(days=16)

    resultado = mongo_db.aggregate(
        [{
            "$match":{
                "$and": [
                        { "fecha": { "$gte": fecha_desde } },
                        { "fecha": { "$lt":  fecha_hasta } },
                        { "patrimonio": {"$gt": 50000}},
                        { "esESCO": {"$eq": esEsco}}
                    ]
            }
        },
        {
            "$group": {
                "_id":["$data.SGNombre","$fecha"],
                "cantidad": { "$sum": 1 },
                "patrimonio":
                { "$sum":
                        {"$cond": [
                            { "$eq": [
                                "$data.Moneda", "Dolar Estadounidense"
                            ]},
                            { "$multiply":[ 
                                "$patrimonio", cotizacion_usd 
                                ]
                            },
                            "$patrimonio"
                        ]
                        }
                }
            }
        },
        {
            "$sort":{"cantidad":-1}
        }
        ]
        )

    return resultado

resultado_Esco=agregate(True)

fondos_total=0
AUM=Decimal(0)
for i in resultado_Esco:
    fondos_total +=i["cantidad"]
    AUM +=i["patrimonio"].to_decimal()

    pn= str(i["patrimonio"])
    dec= f'{Decimal(pn):,}'
    PatNet=dec.replace(',', ' ').replace('.', ',').replace(' ', '.').replace('00000000000','')


    print( i["_id"][0] + " | Fondos: " + str(i["cantidad"]) + " | AUM: " + str(PatNet))

pnAUM= str(AUM)
decAUM= f'{Decimal(pnAUM):,}'
PatNetAUM=decAUM.replace(',', ' ').replace('.', ',').replace(' ', '.').replace('00000000000','')

print("-------------------------------------------------------------")
print("TOTAL: " + str(fondos_total) + " fondos con un total de AUM de " + str(PatNetAUM))


resultado_Otros=agregate(False)
AUMOtros=0
for i in resultado_Otros:
    AUMOtros +=i["patrimonio"].to_decimal()
print("Representa un Market Share de " + "{:.2%}".format(((AUM/(AUM+AUMOtros)))))