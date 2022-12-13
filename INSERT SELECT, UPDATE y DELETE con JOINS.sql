/*Práctica Nº 9: INSERT SELECT, UPDATE y DELETE con JOINS
Práctica en Clase: 1 – 2 – 3 – 4 – 5 – 6 – 7
BASE DE DATOS: AFATSE

/*INSERT SELECT
1) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/06/2009 con un 20 por ciento más que su último valor. Eliminar las filas agregadas.*/

drop temporary table ttt;
create temporary table ttt
select v.nom_plan,max(v.fecha_desde_plan) fecha
from valores_plan v
group by 1;

insert into valores_plan
select vp.nom_plan,'2022-06-01',vp.valor_plan*1.20
from valores_plan vp
inner join ttt t on vp.nom_plan=t.nom_plan and vp.fecha_desde_plan=t.fecha;




/*2) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/08/2009, con la siguiente regla: Los cursos cuyo último valor sea menor a $90
aumentarlos en un 20% al resto aumentarlos un 12%.*/

start transaction;
create temporary table ttt1
select v.nom_plan,max(v.fecha_desde_plan) fecha,max(v.valor_plan)
from valores_plan v
group by 1;

insert into valores_plan
select vp.nom_plan,'2022-09-24',vp.valor_plan*1.20
from valores_plan vp
inner join ttt1 t on vp.nom_plan=t.nom_plan and vp.fecha_desde_plan=t.fecha
where vp.valor_plan>200;
insert into valores_plan

select vp.nom_plan,'2022-09-24',vp.valor_plan*1.10
from valores_plan vp
inner join ttt1 t on vp.nom_plan=t.nom_plan and vp.fecha_desde_plan=t.fecha
where vp.valor_plan<200;
commit;

/*3) Crear un nuevo plan: Marketing 1 Presen. Con los mismos datos que el plan
Marketing 1 pero con modalidad presencial. Este plan tendrá los mismos temas, exámenes
y materiales que Marketing 1 pero con un costo un 50% superior, para todos los períodos
de este año que ya estén definidos costos del plan.*/





/*UDATE con JOIN
4) Cambiar el supervisor de aquellos instructores que dictan Reparac PC Avanzada este año a
66-66666666-6 (Franz Kafka).*/





/*5) Cambiar el horario de los cursos de que dicta este año Franz Kafka (cuil ) desde las 16 hs.
Moverlos una hora más temprano.*/

/*DELETE con JOIN
6) Eliminar los exámenes donde el promedio general de las evaluaciones sea menor a 5.5.
Eliminar también los temas que sólo se evalúan en esos exámenes. Ayuda: Usar una tabla
temporal para determinar el/los exámenes que cumplan en las condiciones y utilizar dichas
tabla para los joins. Tener en cuenta las CF para poder eliminarlos.*/

/*7) Eliminar las inscripciones a los cursos de este año de los alumnos que adeuden cuotas
impagas del año pasado.*/
