/*Listar los miembros que hayan realizado producción el mes pasado (julio) en algún lote. 
Indicando cuil, nombre y apellido del miembro y de lo producido en dicho mes el código 
y nombre del producto, número de lote, fecha de producción y cantidad de horas que trabajó dicho miembro. Ordenar por apellido 
y nombre alfabéticamente.*/

select  m.cuil , m.nombre , m.apellido , l.cantidad_producida, p.nombre ,pro.codigo_producto,pro.numero_lote,l.fecha_produccion,pro.horas_trabajadas
from miembro m
inner join produce pro on m.cuil=pro.cuil_miembro
inner join lote l on pro.codigo_producto= l.codigo_producto and pro.numero_lote=l.numero
inner join producto p on pro.codigo_producto = p.codigo
where l.fecha_produccion between 20210301 and 20210731
order by m.apellido,m.nombre;

/*Listar todos los lotes producidos hace 2 meses (junio) y si las hubo en ese mismo mes las entregas realizadas.
 Indicar código y nombre del producto, número de lote y fecha de producción 
 y de las entregas de junio (sólo si hubo en junio),fecha de entrega y cantidad entregada.*/
 

  select prod.codigo, prod.nombre, lo.numero, lo.fecha_produccion, ent.fecha_entrega, ent.cantidad
from lote lo
inner join producto prod
	on prod.codigo=lo.codigo_producto
left join entrega ent
	on lo.numero= ent.numero_lote 
    and lo.codigo_producto= ent.codigo_producto
	and ent.fecha_entrega between '20210701' and '20210731'
where lo.fecha_produccion between '20210701' and '20210731' ;


