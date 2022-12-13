
/*Clientes que han realizado pocos pedidos el año pasado.
Indicar por cliente la cantidad de pedidos que han realizado.
Mostrar aquellos clientes que han echo menos de 2 pedidos en 2020.
Si algun cliente no a realizado ningun pedido este año mostrarlo igualmente con cantidad de pedido igual a 0.
Indicar cuil, nombre,apellido,cantidad de pedidos y ultima fecha de pedido*/

select c.cuil,c.nombre,c.apellido,count(p.cuil_cliente) 'cantidad de pedidos',max(p.fecha_pedido)
from cliente c 
left join pedido p on c.cuil=p.cuil_cliente
and p.fecha_pedido between 20210801 and 20210831
group by 1,2,3
having count(p.cuil_cliente)<2;

/*select cli.cuil, cli.nombre, cli.apellido,ped.fecha_pedido, count(ped.numero) cant_ped, max(ped.fecha_pedido)
from cliente cli
left join pedido ped
	on cli.cuil= ped.cuil_cliente and ped.fecha_pedido between '20200101' and '20211231'
group by cli.cuil, cli.nombre, cli.apellido
having cant_ped <=2         JULIAN*/



/*Listar todos los productos que desarrolle un grupo que alguna vez fueron solicitado
 (usar el nombre de algún grupo que hayan cargado)  e indicar la cantidad de pedidos del 
 mes (agosto) si los tuvo. Indicar código y  nombre del producto y si cantidad de pedidos */
 
 select p.codigo,p.nombre,count(ped.numero),max(ped.fecha_pedido)
 from producto p
 inner join grupo g on p.numero_grupo= g.numero
 left join solicita s on p.codigo=s.codigo_producto
 left join pedido ped on s.numero_pedido=ped.numero
 and year(fecha_pedido)=2021 and month(fecha_pedido)=8
 where g.nombre like "ma%" 
 group by 1,2
 having count(ped.numero)<3;
 
 
 
 
 
 
 
 
 
 

select p.codigo,p.nombre,ped.fecha_pedido,count(ped.numero)"cantidad pedido"
from producto p
inner join grupo g on p.numero_grupo=g.numero
left join  solicita s on s.codigo_producto=p.codigo
left join pedido ped on s.numero_pedido=ped.numero
and ped.fecha_pedido between 20210801 and 20210830
where g.nombre like "ma%"
group by 1,2;

/*Listar los nombres de los miembros de grupo que participan en mas de un grupo*/

select m.cuil,m.nombre,m.apellido,count(*) 'contador de grupo'
from miembro m
inner join grupo_miembro g on m.cuil=g.cuil_miembro
group by 1,2,3
having count(g.numero_grupo)>0;

/*Indicar los productos cuya cantidad de lotes producidos el mes pasado (agosto)
sea menor a 20. Indicar código y nombre del producto, 
última fecha de producción de lote en agosto, cantidad de lotes producidos y la cantidad de horas trabajadas en el mismo mes. 
Si algún producto no fue fabricado ningún lote durante el mes de agosto entonces debe aparecer con cantidad 0. */

select p.nombre,p.codigo,
max(l.fecha_produccion)"última fecha de producción",
count(l.codigo_producto)"cantidad de lotes producidos",
pro.horas_trabajadas
from producto p 
left join lote l on p.codigo=l.codigo_producto
and year (l.fecha_produccion)=2021 and month(l.fecha_produccion)=8
left join produce pro on l.numero = pro.numero_lote
and p.codigo = pro.codigo_producto
group by 1,2
having count(l.codigo_producto)<20;


/*Indicar los productos cuya cantidad de horas totales dedicadas en su produccion el mes pasado (agosto) sea menor a 20.
Indicar codigo y nombre del producto, 
ultima fecha de produccion de lote en agosto y total de horas dedicadas en la fabricación en agosto.
Si algun producto no fue fabricado durante agosto entomces debe aparecer con cantidad 0*/

select p.codigo,p.nombre,
max(l.fecha_produccion)"última fecha de producción",
sum(pro.horas_trabajadas)"total de horas dedicadas en la fabricación"
from producto p 
left join lote l on p.codigo=l.codigo_producto
and year (l.fecha_produccion)=2021 and month(l.fecha_produccion)=8
left join produce pro on l.numero = pro.numero_lote
and p.codigo = pro.codigo_producto
group by 1,2
having sum(pro.horas_trabajadas)<80.000 or sum(pro.horas_trabajadas) is null;


/*Indicar los productos cuya cantidad de lotes producidos el mes pasado (agosto)
sea menor a 20. Indicar código y nombre del producto, 
última fecha de producción de lote en agosto, cantidad de lotes producidos y la cantidad de horas trabajadas en el mismo mes. 
Si algún producto no fue fabricado ningún lote durante el mes de agosto entonces debe aparecer con cantidad 0. */

select p.codigo,p.nombre,count(l.codigo_producto),sum(pro.horas_trabajadas)
from producto p
left join lote l on p.codigo=l.codigo_producto
and year(l.fecha_produccion)=2021 and month(l.fecha_produccion)=8   
left join produce pro on p.codigo=pro.codigo_producto and l.numero=pro.numero_lote
group by 1,2
having count(l.codigo_producto)<20;


select p.codigo,p.nombre,max(l.fecha_produccion),count(l.codigo_producto),sum(pro.horas_trabajadas)
from producto p
left join lote l on p.codigo = l.codigo_producto
and year (l.fecha_produccion)=2021 and month(l.fecha_produccion)=8
left join produce pro on pro.codigo_producto=p.codigo and pro.numero_lote=l.numero 
group by 1,2
having count(l.codigo_producto)<20;

select p.codigo,p.nombre,max(l.fecha_produccion),count(l.codigo_producto),sum(pro.horas_trabajadas)
from producto p
left join produce pro on pro.codigo_producto=p.codigo 
left join lote l on p.codigo = l.codigo_producto and pro.numero_lote=l.numero
and year (l.fecha_produccion)=2021 and month(l.fecha_produccion)=8
group by 1,2
having count(l.codigo_producto)<20;


/*Indicar los miembros de la cooperativa que hayan trabajado en menos de 10 lotes para la fabricacion en el mes pasado(agosto).
Indicar cuil, nombre, apellido, cantidad de lotes trabajados y fecha del ultimo lote fabricaado en agosto donde participó.
 Si algun membro no particpó en agosto en ningun lote, deberá mostrar 0 **/
 
 select m.cuil,m.nombre,m.apellido,count(l.numero)"cantidad de lotes trabajados",max(l.fecha_produccion)"fecha del ultimo lote fabricado"
 from miembro m
 left join produce p on m.cuil=p.cuil_miembro
 left join lote l on p.numero_lote=l.numero
 and l.codigo_producto=p.codigo_producto
 and year (l.fecha_produccion)=2021 and month(l.fecha_produccion)=8
 group by m.cuil,m.nombre,m.apellido
 having count(l.numero)<10;









