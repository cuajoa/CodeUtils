declare @CodMonedaPais CodigoMedio
declare @CodPais CodigoMedio
    
select @CodPais = CodPais from PARAMETROSREL

select @CodMonedaPais = CodMoneda
from PAISES
where CodPais = @CodPais


select CodTpActivoAfipIt from TPACTIVOAFIPIT where CodInterfazAFIP = 'A.N.1.2.0' or CodInterfazAFIP = 'AN12'

SELECT * FROM CTASBANCARIAS 
inner join TPCTABANCARIA 
		on TPCTABANCARIA.CodTpCtaBancaria = CTASBANCARIAS.CodTpCtaBancaria
where CTASBANCARIAS.CodMoneda = @CodMonedaPais
	and UPPER(TPCTABANCARIA.CodTpCtaBancariaSist) = 'CC' 