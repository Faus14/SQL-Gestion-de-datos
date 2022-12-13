
/*Listar los miembros que hayan realizado producción el mes pasado (julio) en algún lote. 
Indicando cuil, nombre y apellido del miembro y de lo producido en dicho mes el código 
y nombre del producto, número de lote, fecha de producción y cantidad de horas que trabajó dicho miembro. Ordenar por apellido 
y nombre alfabéticamente.*/

select m.cuil,m.nombre,m.apellido,l.cantidad_producida,pr.nombre,l.numero,l.fecha_produccion,p.horas_trabajadas
from miembro m
inner join produce p on m.cuil=p.cuil_miembro
inner join lote l on p.numero_lote=l.numero and p.codigo_producto=l.codigo_producto
inner join producto pr on p.codigo_producto=pr.codigo
where l.fecha_produccion between 20210701 and 20210729
order by 3,2;


/*Listar todos los lotes producidos hace 2 meses (junio) y si las hubo en ese mismo mes las entregas realizadas.
 Indicar código y nombre del producto, número de lote y fecha de producción 
 y de las entregas de junio (sólo si hubo en junio),fecha de entrega y cantidad entregada.*/
 
 select p.codigo, p.nombre, l.numero, l.fecha_produccion, e.fecha_entrega, e.cantidad
 from lote l
inner join producto p on l.codigo_producto=p.codigo
left join entrega e on l.numero=e.numero_lote 
and l.codigo_producto=e.codigo_producto
and fecha_entrega between 20210701 and 20210731
where l.fecha_produccion between 20210701 and 20210731;

/*Mostrar los productos que hayan sido solicitados durante el mes de agosto del 2021, 
aquellos que no hayan sido solicitados (nunca o el mes de agosto), indicar "sin solicitud".
Mostrar código, nombre , características, nombre del grupo al que pertenece , número de pedido ,fecha de pedido*/

select p.codigo,p.nombre,p.caracteristicas,g.nombre
,ifnull(ped.numero,"sin solicitud")numero_ped
,ifnull(ped.fecha_pedido,"sin solicitud")fecha_ped
from producto p
inner join grupo g on p.numero_grupo=g.numero
left join solicita s on p.codigo=s.codigo_producto
left join pedido ped on s.numero_pedido=ped.numero
and fecha_pedido between 20210801 and 20210831;


 /*Listar productos que hayan sido entregados el mes pasado (junio).
 Indicando código y nombre del producto, número del lote, fecha de producción y de la entrega y cantidad entregada.
 Ordenar por nombre del producto alfabético y fecha de entrega ascendente. */
 
 select p.codigo,p.nombre,l.fecha_produccion,e.fecha_entrega,e.cantidad
 from producto p
 inner join lote l on p.codigo=l.codigo_producto
 inner join entrega e on p.codigo=e.codigo_producto
 and l.numero=e.numero_lote
 where e.fecha_entrega between "2021-07-01" and "2021-07-31"
 order by 2 asc,4 asc;
 
 
 
 
 
 /*Listar todos los productos de un grupo (usar el nombre de algún grupo que hayan cargado) 
 y en caso que hayan sido fabricados lotes este mes (julio).
 Indicar código y nombre del producto, el número de lote, cantidad producida*/

select *
from producto p
inner join grupo g on p.numero_grupo=g.numero
left join lote l on p.codigo=l.codigo_producto
and fecha_produccion between 20210701 and 20210731
where g.nombre like "cafe%"
;

/********************************************************************************************************************/
/*Parcial inner*/

/*302 - 1. Listar productos que tengan un pedido con fecha de entrega convenida durante este mes (septiembre).
 Indicando código y nombre del producto y del pedido número, fecha de entrega convenida, cantidad a entregar y precio unitario acordado.
 Ordenar por nombre de producto alfabético y fecha de entrega convenida ascendente. **/
 
select p.codigo,p.nombre,pe.numero,pe.fecha_entrega_convenida,e.cantidad,s.precio_unitario_acordado
from producto p
inner join solicita s on p.codigo=s.codigo_producto
inner join pedido pe on s.numero_pedido=pe.numero
inner join entrega e on pe.numero=e.numero_pedido
and e.codigo_producto=p.codigo
/*where pe.fecha_entrega_convenida between 20210901 and 20210931*/
order by p.nombre asc, pe.fecha_entrega_convenida asc;

/*
10
-4
*/



/*302-2.Listar todos los pedidos hechos por un cliente (usar el nombre y apellido de algún cliente que haya cargado en su db) y 
sólo las entregas realizadas durante el mes pasado (agosto) a dichos pedidos.
 Indicar número de pedido, fecha del pedido, código y cantidad de cada producto solicitado 
 y si hubo alguna entrega en agosto indicar número de lote, fecha de entrega y cantidad entregada **/
 
SELECT  p.numero,p.fecha_pedido,pr.codigo,s.cantidad,l.numero,e.fecha_entrega,e.cantidad
from pedido p
inner join solicita s on p.numero=s.numero_pedido
/*inner join cliente c on c.cuil=p.cuil_cliente*/
inner join producto pr on pr.codigo= s.codigo_producto
inner join lote t on pr.codigo=t.codigo_producto
left join entrega e on e.numero_pedido=p.numero
/*and e.numero_lote=t.numero
and e.codigo_producto=pr.codigo*/
and e.fecha_entrega between 20210701 and 20210731
/*where c.nombre like "jose%"  */;

/*  
10
-2 (falta tabla )
-2,5(falta atributo)	

 */





