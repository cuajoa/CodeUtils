UPDATE TPCTABANCARIA
SET
CodInterfaz=UPPER(CodInterfaz)
WHERE CodInterfaz is not null


declare @CodMonedaPais CodigoMedio
declare @CodPais CodigoMedio
    
select @CodPais = CodPais from PARAMETROSREL

select @CodMonedaPais = CodMoneda
from PAISES
where CodPais = @CodPais
	
update CTASBANCARIAS 
set CTASBANCARIAS.CodTpActivoAfipIt = (select CodTpActivoAfipIt from TPACTIVOAFIPIT where CodInterfazAFIP = 'A.N.1.2.0' or CodInterfazAFIP = 'AN12')
from CTASBANCARIAS 
	inner join BANCOS 
		on BANCOS.CodBanco = CTASBANCARIAS.CodBanco 
	LEFT JOIN EMISORES ON EMISORES.CodEmisor = BANCOS.CodEmisor 
	left join PAISES
		on PAISES.CodPais = BANCOS.CodPais 
	inner join TPCTABANCARIA 
		on TPCTABANCARIA.CodTpCtaBancaria = CTASBANCARIAS.CodTpCtaBancaria
where coalesce(CTASBANCARIAS.CodMoneda,EMISORES.CodMoneda) = @CodMonedaPais and coalesce(EMISORES.CodPais,@CodPais) = @CodPais
	and TPCTABANCARIA.CodTpCtaBancariaSist = 'CC' 

select CodTpActivoAfipIt from TPACTIVOAFIPIT where CodInterfazAFIP = 'A.N.1.2.0' or CodInterfazAFIP = 'AN12'

SELECT * FROM CTASBANCARIAS 
inner join TPCTABANCARIA 
		on TPCTABANCARIA.CodTpCtaBancaria = CTASBANCARIAS.CodTpCtaBancaria
where CTASBANCARIAS.CodMoneda = @CodMonedaPais
	and UPPER(TPCTABANCARIA.CodTpCtaBancariaSist) = 'CC' 