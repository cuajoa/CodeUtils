DECLARE
    @FechaProceso smalldatetime
    SET @FechaProceso =convert(varchar(10), getdate(), 120)
    DECLARE
        @CodPais CodigoLargo
        SET @CodPais = dbo.fnPaisAplicacion()
        select
               FechaProceso
             , CodigoFondo
             ,
                --NombreClase,
                --Clase,
                Precio
             , PatrimonioNeto
        from
               (
                          SELECT
                                     TPVALORESCP.CodFondo     AS Fondo
                                   , TPVALORESCP.CodTpValorCp as Clase
                                   , TPVALORESCP.Descripcion  as NombreClase
                                     --   1 AS TipoPrecio, /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                     --   'VCP Real' AS NombreTipoPrecio /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                   , VALORESCP.ValorCuotaparte as Precio
                                   , VALORESCP.PatrimonioNeto  as PatrimonioNeto
                                   ,
                                      --   convert(smalldatetime ,convert(varchar(10), SOLICITUDESENVIOINTERF.FechaMensaje , 112)) as _FechaMensaje,
                                      --convert(smalldatetime ,
                                      convert(varchar(10), SOLICITUDESENVIOINTERF.FechaProceso , 112)
                                     --)
                                                       as FechaProceso
                                   , FONDOSREAL.Nombre as NombreFondo
                                   ,
                                      --   FONDOSREAL.NumFondo as NumeroFondo,
                                      COALESCE(TPVALORESCP.CodInterfazAdicional, CONDICIONESINGEGR.CodInterfaz ) AS CodigoFondo
                                     --0 as AjusteDiario,
                                      --   SOLICITUDESENVIOINTERF.CodSolicitudEnvioInterf as IDSolicitud,
                                      --   SOLICITUDESENVIOINTERF.FechaMensaje  as FechaSolicitada
                          FROM
                                     FONDOSREAL
                                     INNER JOIN
                                                TPVALORESCP
                                                on
                                                           TPVALORESCP.CodFondo = FONDOSREAL.CodFondo
                                     LEFT JOIN
                                                CONDINGEGRTPVALORESCP
                                     INNER JOIN
                                                CONDICIONESINGEGR
                                                ON
                                                           CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr
                                                           AND CONDICIONESINGEGR.CodFondo       = CONDINGEGRTPVALORESCP.CodFondo
                                                           ON
                                                                      CONDINGEGRTPVALORESCP.CodFondo         = TPVALORESCP.CodFondo
                                                                      AND CONDINGEGRTPVALORESCP.CodTpValorCp = TPVALORESCP.CodTpValorCp
                                                INNER JOIN
                                                           SOLICITUDESENVIOINTERF
                                                           ON
                                                                      FONDOSREAL.CodFondo=SOLICITUDESENVIOINTERF.CodFondo
                                                LEFT JOIN
                                                           VALORESCP
                                                           ON
                                                                      TPVALORESCP.CodFondo         = FONDOSREAL.CodFondo
                                                                      and TPVALORESCP.CodTpValorCp = VALORESCP.CodTpValorCp
                                                                      and Fecha                    = SOLICITUDESENVIOINTERF.FechaMensaje
                                     WHERE
                                                TPVALORESCP.CodFondo                   = SOLICITUDESENVIOINTERF.CodFondo
                                                AND FONDOSREAL.EstaAnulado             = 0
                                                AND SOLICITUDESENVIOINTERF.EstaAnulado = 0
                                                -- AND     SOLICITUDESENVIOINTERF.FueEnviado = 0
                                                AND convert(smalldatetime ,convert(varchar(10), SOLICITUDESENVIOINTERF.FechaMensaje , 112)) =convert(smalldatetime ,convert(varchar(10), @FechaProceso , 112))
                                                --AND NOT FONDOSREAL.CodFondo IN (SELECT Fondo FROM #VCP_INTERFGAF)
                                                and SOLICITUDESENVIOINTERF.FechaMensaje=@FechaProceso
                                                --order by CodigoFondo
               )
               as VCPREAL
        where
               CodigoFondo is not null
               and CodigoFondo not in
               (
                      select
                             --FechaProceso,
                              CodigoFondo
                             --NombreClase,
                              --Clase,
                              --ValorCuotaparte as Precio, PatrimonioNeto
                      from
                             (
                                        SELECT
                                                   TPVALORESCP.CodFondo     AS Fondo
                                                 , TPVALORESCP.CodTpValorCp as Clase
                                                 , TPVALORESCP.Descripcion  as NombreClase
                                                 , 2                        AS TipoPrecio
                                                 ,
                                                   /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                                   'VCP Anticipado' AS NombreTipoPrecio
                                                 ,
                                                   /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                                   VALORESCPANTICIP.ValorCuotaparte
                                                 , VALORESCPANTICIP.PatrimonioNeto
                                                 , convert(smalldatetime ,convert(varchar(10), SOLICITUDESENVIOINTERF.FechaMensaje , 112)) as _FechaMensaje
                                                 ,
                                                    -- convert(smalldatetime ,
                                                    convert(varchar(10), SOLICITUDESENVIOINTERF.FechaProceso , 112)
                                                   --)
                                                                                                                              as FechaProceso
                                                 , FONDOSREAL.Nombre                                                          as NombreFondo
                                                 , FONDOSREAL.NumFondo                                                        as NumeroFondo
                                                 , COALESCE(TPVALORESCP.CodInterfazAdicional, CONDICIONESINGEGR.CodInterfaz ) AS CodigoFondo
                                                 ,
                                                    --   0 as AjusteDiario,
                                                    SOLICITUDESENVIOINTERF.CodSolicitudEnvioInterf as IDSolicitud
                                                 , SOLICITUDESENVIOINTERF.FechaMensaje             as FechaSolicitada
                                        FROM
                                                   FONDOSREAL
                                                   INNER JOIN
                                                              TPVALORESCP
                                                              on
                                                                         TPVALORESCP.CodFondo = FONDOSREAL.CodFondo
                                                   LEFT JOIN
                                                              CONDINGEGRTPVALORESCP
                                                   INNER JOIN
                                                              CONDICIONESINGEGR
                                                              ON
                                                                         CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr
                                                                         AND CONDICIONESINGEGR.CodFondo       = CONDINGEGRTPVALORESCP.CodFondo
                                                                         ON
                                                                                    CONDINGEGRTPVALORESCP.CodFondo         = TPVALORESCP.CodFondo
                                                                                    AND CONDINGEGRTPVALORESCP.CodTpValorCp = TPVALORESCP.CodTpValorCp
                                                              INNER JOIN
                                                                         SOLICITUDESENVIOINTERF
                                                                         ON
                                                                                    FONDOSREAL.CodFondo=SOLICITUDESENVIOINTERF.CodFondo
                                                              LEFT JOIN
                                                                         VALORESCPANTICIP
                                                                         ON
                                                                                    VALORESCPANTICIP.CodFondo         = TPVALORESCP.CodFondo
                                                                                    and VALORESCPANTICIP.CodTpValorCp = TPVALORESCP.CodTpValorCp
                                                   WHERE
                                                              SOLICITUDESENVIOINTERF.EstaAnulado = 0
                                                              --and SOLICITUDESENVIOINTERF.FueEnviado = 0
                                                              AND dbo.fnSumarDiasHabiles(@FechaProceso, 1, @CodPais) = VALORESCPANTICIP.Fecha
                                                              and SOLICITUDESENVIOINTERF.FechaMensaje                =@FechaProceso
                             )
                             as VCPANTI
               )
        union
              (
                     select
                            FechaProceso
                          , CodigoFondo
                          ,
                             --NombreClase,
                             --Clase,
                             ValorCuotaparte as Precio
                          , PatrimonioNeto
                     from
                            (
                                       SELECT
                                                  TPVALORESCP.CodFondo     AS Fondo
                                                , TPVALORESCP.CodTpValorCp as Clase
                                                , TPVALORESCP.Descripcion  as NombreClase
                                                , 2                        AS TipoPrecio
                                                ,
                                                  /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                                  'VCP Anticipado' AS NombreTipoPrecio
                                                ,
                                                  /*1 VCP, 2 VCP Anticipado para MCS Galicia*/
                                                  VALORESCPANTICIP.ValorCuotaparte
                                                , VALORESCPANTICIP.PatrimonioNeto
                                                , convert(smalldatetime ,convert(varchar(10), SOLICITUDESENVIOINTERF.FechaMensaje , 112)) as _FechaMensaje
                                                ,
                                                   -- convert(smalldatetime ,
                                                   convert(varchar(10), SOLICITUDESENVIOINTERF.FechaProceso , 112)
                                                  --)
                                                                                                                             as FechaProceso
                                                , FONDOSREAL.Nombre                                                          as NombreFondo
                                                , FONDOSREAL.NumFondo                                                        as NumeroFondo
                                                , COALESCE(TPVALORESCP.CodInterfazAdicional, CONDICIONESINGEGR.CodInterfaz ) AS CodigoFondo
                                                ,
                                                   --   0 as AjusteDiario,
                                                   SOLICITUDESENVIOINTERF.CodSolicitudEnvioInterf as IDSolicitud
                                                , SOLICITUDESENVIOINTERF.FechaMensaje             as FechaSolicitada
                                       FROM
                                                  FONDOSREAL
                                                  INNER JOIN
                                                             TPVALORESCP
                                                             on
                                                                        TPVALORESCP.CodFondo = FONDOSREAL.CodFondo
                                                  LEFT JOIN
                                                             CONDINGEGRTPVALORESCP
                                                  INNER JOIN
                                                             CONDICIONESINGEGR
                                                             ON
                                                                        CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr
                                                                        AND CONDICIONESINGEGR.CodFondo       = CONDINGEGRTPVALORESCP.CodFondo
                                                                        ON
                                                                                   CONDINGEGRTPVALORESCP.CodFondo         = TPVALORESCP.CodFondo
                                                                                   AND CONDINGEGRTPVALORESCP.CodTpValorCp = TPVALORESCP.CodTpValorCp
                                                             INNER JOIN
                                                                        SOLICITUDESENVIOINTERF
                                                                        ON
                                                                                   FONDOSREAL.CodFondo=SOLICITUDESENVIOINTERF.CodFondo
                                                             LEFT JOIN
                                                                        VALORESCPANTICIP
                                                                        ON
                                                                                   VALORESCPANTICIP.CodFondo         = TPVALORESCP.CodFondo
                                                                                   and VALORESCPANTICIP.CodTpValorCp = TPVALORESCP.CodTpValorCp
                                                  WHERE
                                                             SOLICITUDESENVIOINTERF.EstaAnulado = 0
                                                             --and SOLICITUDESENVIOINTERF.FueEnviado = 0
                                                             AND dbo.fnSumarDiasHabiles(@FechaProceso, 1, @CodPais) = VALORESCPANTICIP.Fecha
                                                             and SOLICITUDESENVIOINTERF.FechaMensaje                =@FechaProceso
                            )
                            as VCPANTI
              )