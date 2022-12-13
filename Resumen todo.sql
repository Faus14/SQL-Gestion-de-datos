/*PRODUCTO CARTESIANO*/
select *
from personas p , entrevistas e
where p.dni=e.dni;

/*NATURAL JOIN (ELIMINA COLUMNAS REPETIDAS)*/
SELECT *
FROM personas p natural join entrevistas;

/*INNER JOIN (AMBAS TABLAS ESTE EL VALOR DE COMBINACION)*/
SELECT *
FROM personas p 
inner join entrevistas e ON p.dni=e.dni
where p.dni=27890765;

/* LEFT JOIN  (MUESTRA TODO LO DE LA IZQ AUNQUE NO SE CUMPLA LO DE LA DERECHA)*/
/*RIGHT JOIN (MUESTRA TODO LO DE LA DER INDEPENDIENTEMENTE DE LO Q ESTE EN LA IZQ)*/

/*COUNT */
select count(*) Cantidad
from personas;

SELECT COUNT(co.fecha_caducidad) cantidad
FROM contratos co;

select count(*)
FROM contratos;

select cod_cargo, count(*) /*cuento la cantidad de cod cargo q hay repetidos */
from contratos
group by cod_cargo;



/*SUM*/
SELECT SUM(co.nro_contrato) SUMA
from contratos co;

/*avg*/
SELECT avg(co.nro_contrato) PROMEDIO
from contratos co;

/*MIN*/
SELECT MIN(co.nro_contrato) MINIMO
from contratos co;


/*MAX*/
SELECT MAX(co.nro_contrato) MAXIMO
from contratos co;


/*group*//*having*/
SELECT tit.tipo_titulo, count(*)
from titulos tit
group by tit.tipo_titulo
having count(*)=3;

select com.anio_contrato,com.mes_contrato, sum(com.importe_comision)
from comisiones com
group by 1,2
having sum(com.importe_comision)>100;


/*aca agarramos a todos */
select vp.nom_plan, MAX(vp.fecha_desde_plan)
from valores_plan vp;

/*Aca lo hacemos por grupo */
select vp.nom_plan, MAX(vp.fecha_desde_plan)
from valores_plan vp
where vp.fecha_desde_plan<=current_date()
group by vp.nom_plan;

select MAX(vp.fecha_desde_plan) into @maxima
from valores_plan vp;

select @maxima;  /*guardar en memoria lo anterior(solo un valor guarda)*/


/*drop temporary table  tt_fecha_max;*//*Elimina la tabla*/

create temporary table  tt_fecha_max
select vp.nom_plan, MAX(vp.fecha_desde_plan)
from valores_plan vp
where vp.fecha_desde_plan<=current_date()
group by vp.nom_plan;

select *
from tt_fecha_max;

select vp.nom_plan,vp.fecha_desde_plan,vp.valor_plan
from valores_plan vp
inner join tt_fecha_max tt
on vp.nom_plan=tt.nom_plan
and vp.fecha_desde_plan=tt.fecha_max;


-- INSERT
 start transaction;
	insert into unidades_medida (desc_unidad)
    select distinct mat.unidad
    from materiales mat;
 commit;
 
-- UPDATE
start transaction;
    update materiales
    SET cod_unidad = (select um.cod_unidad from unidades_medida um where um.desc_unidad = materiales.unidad);
commit;

-- DELETE
start transaction;
UPDATE instructores SET cuil_supervisor = NULL 
WHERE cuil_supervisor = "44-44444444-4";
DELETE FROM instructores WHERE cuil = "44-44444444-4"; 
COMMIT;

