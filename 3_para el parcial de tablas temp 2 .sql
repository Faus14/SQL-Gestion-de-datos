/*305-4. Listar los miembros de la cooperativa que no hayan participado 
en la producción de ningún lote fabricado durante el mes pasado (agosto).
 Indicar CUIL, Nombre y Apellido. */
 
 select *
 from miembro mi
 where mi.cuil not in (select m.cuil 
 from miembro m
 inner join produce p on m.cuil=p.cuil_miembro
 inner join lote l on p.numero_lote=l.numero
 where month(l.fecha_produccion)=8);
 
 
/**305-5.Listar los Grupos que desarrollan gran cantidad de productos. 
Indicar para cada Grupo el número, nombre y cantidad de productos que desarrollan,
 pero sólo mostrar aquellos grupos cuya cantidad supere al promedio de dichas cantidades desarrolladas por todos los grupos.*/
 
 select count(p.codigo)/count(distinct p.numero_grupo)  into @prom_tot
 from producto p ;
 
select g.numero,g.nombre,count(p.codigo) cant_grupo
 from grupo g
 inner join producto p on g.numero=p.numero_grupo
 group by 1,2
 having cant_grupo>@prom_tot;
 


 
/* 304-4. Listar los productos que entre sus materiales no se compongan de maní, nuez o almendra.
  Indicar código, nombre y precio sugerido. */
  
    select *
  from producto pro
  where pro.codigo not in ( select p.codigo
  from producto p
  inner join composicion c on p.codigo=c.codigo_producto
  inner join material m on c.codigo_material=m.codigo
  where m.nombre like "%almendra%");
  
  /* 304-5. Listar los clientes y la cantidad de pedidos que han realizado.
 Incluir sólo los clientes que han realizado una cantidad mayor al promedio de dichas cantidades de todos los clientes. */
 
 select count(p.numero)/count(distinct p.cuil_cliente) into @prom_tot
 from cliente c
 inner join pedido p on c.cuil=p.cuil_cliente;
 
  select c.cuil,c.nombre,c.apellido,count(p.numero) cant_pedidos
 from cliente c
 inner join pedido p on c.cuil=p.cuil_cliente
 group by 1,2,3
 having cant_pedidos>@prom_tot;
 
 
 /*Listar los clientes que no realizaron pedidos con productos que se pactara un valor unitario superior a $5000.
 Indicar CUIL, nombre y apellido. */
 
 select * 
 from cliente cli 
 where cli.cuil not in ( select c.cuil
 from cliente c
 inner join pedido p on c.cuil=p.cuil_cliente
 inner join solicita s on s.numero_pedido=p.numero
 inner join producto pro on s.codigo_producto=pro.codigo
 where s.precio_unitario_acordado > 150.000);
 
 /*Listar los productos y la cantidad producida de cada uno. 
 Mostrar sólo los productos cuya cantidad producida supere el promedio de dichas cantidad producidas para todos los productos.
 Indicar código, nombre  y cantidad producida. */
 
 select avg(l.cantidad_producida) into @prom_total
 from producto p
 inner join lote l on p.codigo=l.codigo_producto;
 
 
 
select p.codigo,p.nombre,sum(cantidad_producida) sum_producto
from producto p
inner join lote l on p.codigo=l.codigo_producto
group by 1,2
having sum_producto<@prom_total;

/*7) Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los
contrató.*/
drop temporary table prom_empre;

create temporary table prom_empre
select c.cuit,avg(sueldo) prom
from contratos c
group by 1;

select p.dni,p.apellido,p.nombre,c.sueldo,prom
from personas p 
inner join contratos c on p.dni=c.dni
inner join empresas e on c.cuit=e.cuit
inner join prom_empre l on e.cuit=l.cuit
where c.sueldo>prom;

select c.cuit,avg(sueldo) prom
from contratos c
group by 1;

 -- 12) Plan de capacitacion mas barato. Indicar los datos del plan de capacitacion y el valor actual
 
drop temporary table max_fecha;

create temporary table max_fecha
select pl.nom_plan,max(fecha_desde_plan) fecha_max
from plan_capacitacion pl 
inner join valores_plan vp on pl.nom_plan=vp.nom_plan
group by 1;

drop temporary table calculo_p;
create temporary table calculo_p
select vp.nom_plan,vp.fecha_desde_plan,vp.valor_plan
from  valores_plan vp 
inner join max_fecha mf on vp.nom_plan=mf.nom_plan and vp.fecha_desde_plan=mf.fecha_max;

select min(cee.valor_plan) Minimo_valor into @valor
from calculo_p cee;

select *
from calculo_p ple 
inner join max_fecha vpe on ple.nom_plan=vpe.nom_plan
where ple.valor_plan=@valor;

/*302-4. Listar los productos que no tienen entregas en los últimos 2 meses (agosto y septiembre).
 Indicar, código y nombre del producto. **/

select pro.codigo,pro.nombre
from producto pro 
where pro.codigo not in( select p.codigo
 from producto p
 inner join  entrega e on e.codigo_producto=p.codigo
 where month(e.fecha_entrega)=7 or month(e.fecha_entrega)=9)  ;
 
 select pro.codigo,pro.nombre
from producto pro 
where pro.codigo not in( select e.codigo_producto
 from  entrega e
 where month(e.fecha_entrega)=8 or month(e.fecha_entrega)=9) ;
 
/* SELECT p.codigo, p.nombre
FROM producto p
WHERE p.codigo NOT IN (SELECT e.codigo_producto codprod
	FROM entrega e
	WHERE e.fecha_entrega BETWEEN 20210801 AND 20210930); ENEAS */
 

 
 /*302-5. Listar los miembros y la cantidad total de horas que han trabajado en la fabricación de lotes.
 Mostrando aquellos que han trabajado menos horas totales que el promedio de dichas horas totales de los miembros.
 Indicar cuil, nombre, apellido y la cantidad de horas totales trabajadas. **/
 
 select sum(p.horas_trabajadas)/count( distinct p.cuil_miembro) into @prom_tot  
 /*Promedio por distintos miembros, me parece conveniente usar este*/
 from miembro m
 inner join produce p on m.cuil=p.cuil_miembro;
 
select mi.cuil,mi.nombre,mi.apellido,sum(pi.horas_trabajadas) horas
from miembro mi
inner join produce pi on mi.cuil=pi.cuil_miembro
inner join lote l on pi.numero_lote=l.numero and pi.codigo_producto=l.codigo_producto
group by 1,2,3
having horas < @prom_tot;

 /*select avg(p.horas_trabajadas) 
 from  produce p ;  
 
 select sum(p.horas_trabajadas)/count(p.cuil_miembro)  
from miembro m
inner join produce p on m.cuil=p.cuil_miembro;
 
select sum(p.horas_trabajadas)/count( distinct p.cuil_miembro)  
from miembro m
inner join produce p on m.cuil=p.cuil_miembro;

SELECT count(*) INTO @cant_miem
FROM miembro m;*/

/*SELECT p.cuil_miembro, m.nombre, m.apellido, SUM(p.horas_trabajadas) horastot_miembro
FROM produce p
INNER JOIN miembro m ON m.cuil = p.cuil_miembro
GROUP BY 1, 2, 3
HAVING horastot_miembro > (SELECT SUM(p.horas_trabajadas) horastot
FROM produce p) / @cant_miem; ENEAS*/




 
 
 
 
 