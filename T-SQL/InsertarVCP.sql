


DECLARE @CodFondo numeric(10)

SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo='6'


insert into CUOTAPARTES (CodFondo,Fecha,CodTpCuotaparte,PatrimonioNeto,CodUsuarioI,FechaI,TermI)
SELECT @CodFondo, '20220113', 'UN', 731042509.27, 1, getdate(), 'ESCOWKS89'


DECLARE @CodTpValorCp numeric(10)

SELECT @CodTpValorCp=CodTpValorCp
FROM TPVALORESCP
WHERE CodFondo=@CodFondo AND Abreviatura='A'


insert into VALORESCP (CodFondo,Fecha,CodTpValorCp,PatrimonioNeto,CuotapartesCirculacion,ValorCuotaparte,PatrimonioNetoProv,Factor,CuotapartesCirculacionSL,PatrimonioNetoSL)
SELECT @CodFondo, '20220113', @CodTpValorCp, 28159988843.10, 4648744581.85881000, 6.0575470000, 28832020258.31, 1, NULL, NULL



SELECT @CodTpValorCp=CodTpValorCp
FROM TPVALORESCP
WHERE CodFondo=@CodFondo AND Abreviatura='B'


insert into VALORESCP (CodFondo,Fecha,CodTpValorCp,PatrimonioNeto,CuotapartesCirculacion,ValorCuotaparte,PatrimonioNetoProv,Factor,CuotapartesCirculacionSL,PatrimonioNetoSL)
SELECT @CodFondo, '20220113', @CodTpValorCp, 202282344.93, 33596238.72781000, 6.0209820000, 195634170.10, 1, NULL, NULL
