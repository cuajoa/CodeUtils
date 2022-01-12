

ALTER TABLE REGLGESTIONCPT
	DROP CONSTRAINT XPKREGLGESTIONCPT

GO

ALTER TABLE REGLGESTIONCPT
	ALTER COLUMN CodReglGestionCpt CodigoLargo NOT NULL

GO

ALTER TABLE REGLGESTIONCPT
ADD CONSTRAINT [XPKREGLGESTIONCPT] PRIMARY KEY CLUSTERED 
(
	[CodReglGestionCpt] ASC,
	[CodReglGestion] ASC,
	[CodFondo] ASC,
	[CodCuotapartista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

GO

--COMMIT
--Rollback