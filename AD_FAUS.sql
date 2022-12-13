-- saco roto

CREATE TABLE `historico_mail` (
  `nro_persona` int NOT NULL,
  `fecha_desde` date DEFAULT NULL,
  `cuenta_email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`nro_persona`),
  KEY `fk_cuenta_email_idx` (`cuenta_email`),
  CONSTRAINT `fk_cuenta_email` FOREIGN KEY (`cuenta_email`) REFERENCES `personas` (`email`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_nro_persona` FOREIGN KEY (`nro_persona`) REFERENCES `personas` (`nro_persona`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

insert into historico_mail
select p.nro_persona,current_date(),p.email
from personas p;


/*Listado de tipos de prendas que no hayan sido pedidos. Por cada tipo mostrar su código,
descripcion.
Ordenar el listado en forma alfabética*/

select *
from tipos_prendas p
where p.cod_tipo_prenda not in(select p.cod_tipo_prenda
from prendas p);

/*Listado de sastres que son jefes. Para cada Jefe de Sastres mostrar:
Cuil , Apellido y Nombre (en una sola columna) y la cantidad de Sastres que tiene a cargo.
Ordenar en forma descendente por cantidad de sastres a cargo*/

/*select *
from sastres s
where s.cuil in (select sas.cuil_jefe from sastres sas);*/

create temporary table jefes_cuil1
SELECT s.cuil,s.nombre,s.apellido
FROM sastres s
where s.cuil_jefe is null;

SELECT j.cuil,j.nombre,j.apellido,count(s.cuil_jefe)"Cantidad"
FROM sastres s 
inner join jefes_cuil1 j on s.cuil_jefe=j.cuil
group by 1;

/*Ranking por Persona:
Listado de personas cuya cantidad de prendas solicitadas (confeccionadas y entregadas)
supera el promedio de cantidad confeccionada y entregada por personas.
NOTA, calcular cantidad por persona, promedio por persona y luego mostrar:
Datos de la persona, cantidad confeccionada y entregada, promedio y diferencia.
Ordenar por cantidad confeccionada y entregada en forma decreciente.
*/
drop temporary table if exists tt_cantidad;
create temporary table tt_cantidad
select nro_persona, count(*) cant
from prendas
where fecha_fin_real is not null
group by nro_persona;

select avg(cant) into @promedio
from tt_cantidad;

select per.nro_persona, per.dni, per.nombre, per.apellido, per.direccion, per.fecha_nac, per.email, can.cant,
round(@promedio,2), round(can.cant - @promedio,2) diferencia
from prendas pren
inner join personas per
on pren.nro_persona = per.nro_persona
inner join tt_cantidad can
on per.nro_persona = can.nro_persona
where pren.fecha_fin_real is not null
and can.cant > @promedio
group by per.nro_persona, per.dni, per.nombre, per.apellido, per.direccion, per.fecha_nac, per.email, can.cant, @promedio;
drop temporary table tt_cantidad;


/*Realizar un procedimiento "fecha_ultima_prueba".
El procedimiento debe recibir una fecha y listar para cada persona y tipo de prenda, cuál fue la
fecha de la última prueba.
Mostrar Apellido y nombre de la persona, descripción del tipo de prenda y fecha de última
prueba.
Ordenar por fecha en forma descendente y por apellido en forma alfabética.
No olvidar realizar la llamada al procedimiento*/

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fecha_ultima_prueba`(in fecha date )
BEGIN

create temporary table maxi_fecha
select p.nro_persona,cod_tipo_prenda,max(p.fecha_prueba) ult_pru
from pruebas p
where p.fecha_prueba<fecha
group by 1,2;

select p.apellido,p.nombre,m.nro_persona,t.desc_tipo_prenda,m.cod_tipo_prenda,ult_pru
from maxi_fecha m
inner join personas p on m.nro_persona=p.nro_persona
inner join tipos_prendas t on m.cod_tipo_prenda=t.cod_tipo_prenda
inner join pruebas pr on pr.nro_persona=m.nro_persona 
and pr.cod_tipo_prenda=m.cod_tipo_prenda
and pr.fecha_prueba= m.ult_pru
order by  p.apellido;


END$$
DELIMITER ;

call fecha_ultima_prueba('20211129');

/*Por un problema con el proveedor que provee el material: Alpaca se ha decidido modificar la
fecha de entrega de todas las prendas que aún no han sido terminadas de confeccionar y
contengan ese material para 15 días posterior a la fecha pactada de entrega.
Realice las actualizaciones correspondientes..
*/

start transaction;
select m.cod_material into @cod
from materiales m
where m.desc_material="Alpaca";

drop temporary table if exists t_prendas;
create temporary table t_prendas
select pre.nro_persona,pre.cod_tipo_prenda,pre.nro_pedido,tp.cod_material,pre.fecha_entrega
from prendas_materiales tp
inner join prendas pre on  pre.nro_persona = tp.nro_persona
and pre.cod_tipo_prenda = tp.cod_tipo_prenda
and pre.nro_pedido = tp.nro_pedido
where tp.cod_material=@cod and pre.fecha_fin_real is null;

update prendas pre
inner join t_prendas tp on pre.nro_persona = tp.nro_persona
and pre.cod_tipo_prenda = tp.cod_tipo_prenda
and pre.nro_pedido = tp.nro_pedido
set pre.fecha_entrega = date_add(pre.fecha_entrega, interval 15 day);

commit;

/*--------------------------------------------------------------------------------*/
