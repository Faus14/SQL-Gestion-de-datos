
-- promedio cantidad de miembros por grupos

select count(*) into @cant_tot
from grupo_miembr gm;

select gm.numero_grupo,count(*) cant_grupo, count(*)*100/@cant_tot PROMEDIO
from grupo_miembro gm
group by 1;

-- listar el valor hora a la fecha actual

select max(fecha_desde) into @fecha_max
from valor_hora vh
where vh.fecha_desde<= current_date() ;

select *
from valor_hora vh
where vh.fecha_desde=@fecha_max;

-- listar el promedio de cantidad de pedidos por cliente y la fecha maxima en el que el cliente realizo pedidos


-- se requiere conocer de los pedidos identificados con fecha máxima de los clientes el valor de los productos solicitados 

-- calculando esos valores en función de la cantidad del producto, de la cantidad de materiales por producto y de los valores de 
-- los materiales de su composición a la fecha de hoy




/*305-4. Listar los miembros de la cooperativa que no hayan participado 
en la producción de ningún lote fabricado durante el mes pasado (agosto).
 Indicar CUIL, Nombre y Apellido. */
 
select *
 from miembro m
 where m.cuil not in (
 select mi.cuil
 from miembro mi
 inner join produce p on mi.cuil=p.cuil_miembro
 inner join lote l on p.numero_lote=l.numero
 and month(l.fecha_produccion )=8);
 
 /*select  m.cuil,m.apellido,m.nombre
 from miembro m
 inner join produce p on m.cuil=p.cuil_miembro
 inner join lote l on p.numero_lote=l.numero
 where m.cuil not in (
 select m.cuil
 from miembro m
 inner join produce p on m.cuil=p.cuil_miembro
 inner join lote l on p.numero_lote=l.numero
 and month(l.fecha_produccion )=8);MALLLLLLLL*/
 
 /*select *
 from miembro mi
 left join produce p on mi.cuil=p.cuil_miembro
 left join lote l on p.numero_lote=l.numero
 where month(l.fecha_produccion )<>8
 group by mi.cuil;  NO ANDA CON LEFT */
 
/* select *
from miembro m
where m.cuil not in (select p.cuil_miembro
from produce p
inner join lote l 
  on p.codigo_producto=l.codigo_producto
  and p.numero_lote=l.numero
  and l.fecha_produccion between '20210801' and '20210831');*NANU/
  
  /**305-5.Listar los Grupos que desarrollan gran cantidad de productos. 
Indicar para cada Grupo el número, 
nombre y cantidad de productos que desarrollan, pero sólo mostrar aquellos grupos cuya cantidad
supere al promedio de dichas cantidades desarrolladas por todos los grupos.*/

select count(p.nombre)/ count(distinct p.numero_grupo) into @prom_total
from grupo g
inner join producto p on g.numero=p.numero_grupo ;

select g.numero,g.nombre,count(p.nombre) cantidad_desarrollada
from grupo g
inner join producto p on g.numero=p.numero_grupo 
group by 1,2
having cantidad_desarrollada>@prom_total;

/*select p.numero_grupo, g.nombre, count(p.codigo) cantProducida
from producto p
inner join grupo g
    on p.numero_grupo = g.numero
group by numero_grupo
having cantProducida > (select count(*) / count(numero_grupo)
                   from producto);*/
  
  
  /* 304-4. Listar los productos que entre sus materiales no se compongan de maní, nuez o almendra.
  Indicar código, nombre y precio sugerido. */
  
   select pr.codigo,pr.nombre,pr.precio_sugerido
  from producto pr
  where pr.codigo not in(
  select p.codigo
  from producto p
  inner join composicion c on p.codigo=c.codigo_producto
  inner join material m on c.codigo_material=m.codigo
  WHERE m.nombre like "mani" or m.nombre like "nuez" or m.nombre LIKE "almendra");
 
  
  /* 304-5. Listar los clientes y la cantidad de pedidos que han realizado.
 Incluir sólo los clientes que han realizado una cantidad mayor al promedio de dichas cantidades de todos los clientes. */
 
  select count(p.cuil_cliente)/count(distinct c.cuil) into @prom_tot
 from cliente c
 inner join pedido p on c.cuil=p.cuil_cliente;
 
 select c.cuil,c.nombre,c.apellido,count(p.cuil_cliente) cantidad_pedidos
 from cliente c
 inner join pedido p on c.cuil=p.cuil_cliente
 group by 1,2,3
 having cantidad_pedidos>@prom_tot;
 
 /*Listar los clientes que no realizaron pedidos con productos que se pactara un valor unitario superior a $5000.
 Indicar CUIL, nombre y apellido. */
 
select c.cuil,c.nombre,c.apellido 
from cliente c
 where c.cuil not in(
 select cli.cuil from cliente cli
 inner join pedido p on cli.cuil=p.cuil_cliente
 inner join solicita s on s.numero_pedido= p.numero
 inner join producto pro on pro.codigo=s.codigo_producto
 where s.precio_unitario_acordado>5.000);
 
 /*Listar los productos y la cantidad producida de cada uno. 
 Mostrar sólo los productos cuya cantidad producida supere el promedio de dichas cantidad producidas para todos los productos.
 Indicar código, nombre  y cantidad producida. */
 
 select avg(l.cantidad_producida) into @prom_tot
 from lote l ;
 
 select p.codigo,p.nombre,sum(l.cantidad_producida) cant_pro ,@prom_tot "promedio total"
 from producto p
 inner join lote l on p.codigo=l.codigo_producto
 group by 1
 having cant_pro < @prom_tot; 
 
 
 

 
