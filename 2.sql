 /*
 COSPLAY
 Lista de tareas y materiales. 
Indicar todas las tareas y los materiales utilizados en ellas. 
Indicar nro de trabajo, nro de ítem, descripción del tipo de elemento, descripción del tipo de tarea, fecha y hora de inicio de la tarea,
código y descripción de los materiales utilizados y las cantidades usadas y desperdiciadas. 
En caso de no tener registrado el uso de los materiales deberá mostrar los datos de la tarea indicando no registrado en los datos del material.
 Ordenar descendente por la cantidad de material utilizado y descendente por la cantidad desperdiciada.*/
 
 select t.nro_trabajo,u.nro_item,te.descripcion,tt.descripcion,t.fecha_hora_inicio,m.codigo,m.descripcion,u.cantidad_usada,ifnull(u.cantidad_desperdiciada,"no registrada")
from tarea t
inner join item i on t.nro_item=i.nro_item
inner join tipo_elemento te on i.codigo_tipo_elemento=te.codigo
inner join tipo_tarea tt on t.codigo_tipo_tarea=tt.codigo
left join uso_material u
		 on u.nro_trabajo=t.nro_trabajo
		and u.nro_item =t.nro_item
	     and u.codigo_tipo_tarea=t.codigo_tipo_tarea
left join material m on u.codigo_material=m.codigo;


/*
SACO ROTO
Ranking por Persona:
Listado de personas cuya cantidad de prendas solicitadas (confeccionadas y entregadas)
supera el promedio de cantidad confeccionada y entregada por personas.
NOTA, calcular cantidad por persona, promedio por persona y luego mostrar:
Datos de la persona, cantidad confeccionada y entregada, promedio y diferencia.
Ordenar por cantidad confeccionada y entregada en forma decreciente.
*/
drop temporary table if exists tt_cantidad;
create temporary table tt_cantidad
select nro_persona, sum(cantidad) cant
from prendas
where fecha_fin_real is not null
group by nro_persona;

select avg(cant) 
from tt_cantidad;

/*
select avg(p.nro_pedido)
from prendas p
where p.fecha_fin_real is not null;*/

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


