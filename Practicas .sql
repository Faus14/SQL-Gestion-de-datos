/*1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la 
misma.*/
desc empresas;
select * from empresas;

/*2) Mostrar la estructura de la tabla Personas. Mostrar el apellido y nombre y la fecha de 
registro en la agencia.*/
desc personas;
select apellido,nombre,fecha_registro_agencia
from personas;

/*3) Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo.
Mostrar los títulos con el formato de columna: Código Descripción y Tipo ordenarlo
alfabéticamente por descripción*/

SELECT cod_titulo Codigo , desc_titulo Descripcion, tipo_titulo Tipo
FROM titulos
order by desc_titulo asc;

/*4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de
nacimiento, teléfono, y su dirección. Las cabeceras de las columnas serán:
Apellido y Nombre      Fecha Nac.     Teléfono Dirección
(concatenados)*/

SELECT concat(apellido," ",nombre)'Apellido y Nombre',fecha_nacimiento 'Fecha Nac',Telefono,direccion
FROM personas
where dni=28675888;

/*5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y
31345778. Ordenadas por fecha de Nacimiento*/

SELECT concat(apellido," ",nombre)'Apellido y Nombre',fecha_nacimiento 'Fecha Nac',Telefono,direccion,dni
FROM personas
where dni in("28675888" ,"27890765","29345777","31345778")
/* where dni="28675888" or dni="27890765" or dni="29345777" or dni="31345778" ---> otra forma*/
order by fecha_nacimiento;

/*6) Mostrar las personas cuyo apellido empiece con la letra ‘G’*/

select *
from personas
where apellido like 'g%';

/*7) Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y
2000*/

select nombre,apellido,fecha_nacimiento
from personas
where fecha_nacimiento between  '1980-01-01' and  '2000-12-31';

/*8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente
por fecha de solicitud.*/

select *
from solicitudes_empresas
order by fecha_solicitud;

/*9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral
ordenados por fecha desde.*/
select *
from antecedentes
where isnull( fecha_hasta);

/*10)Mostrar aquellos antecedentes laborales que finalizaron y cuya fecha hasta no esté entre
junio del 2013 a diciembre de 2013, ordenados por número de DNI del empleado.*/

select *
from antecedentes
where not isnull( fecha_hasta) and fecha_hasta not between  '2013-06-01' and  '2013-12-31' 
order by dni;

/*11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas 
30-10504876-5 o 30-21098732-4.Rotule el encabezado:  Nro  Contrato  DNI  Salario  CUIL    */

SELECT nro_contrato 'Nro contrato',dni "DNI",sueldo "Salario",cuit 'CUIL'
FROM contratos
WHERE sueldo>2000 and cuit in('30-10504876-5','30-21098732-4')
order by  nro_contrato;

/*12) Mostrar los títulos técnicos*/

select *
from titulos
where desc_titulo like 'tecnico%' ;

/* 13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y el código de cargo
sea 6; o hayan solicitado aspirantes de sexo femenino */

SELECT *
FROM solicitudes_empresas
WHERE fecha_solicitud >'2013-09-21' and cod_cargo=6 or sexo='Femenino';

/*14) Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido
terminado.*/

SELECT *
FROM contratos
WHERE sueldo>'2000' and   isnull( fecha_caducidad);

/*Práctica Nº 2: JOINS*/

/*1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
sueldo acordado en el contrato.*/

select P.dni, p.apellido,p.nombre, c.sueldo
from contratos c
inner join personas p On c.dni=p.dni
where c.nro_contrato=5;

/*2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa.*/

SELECT c.dni, c.nro_contrato, c.fecha_incorporacion,c.fecha_solicitud, ifnull ( c.fecha_caducidad,'SIN FECHA') FechaCaducacion,e.razon_social
from  contratos c
inner join empresas e ON c.cuit=e.cuit
WHERE e.razon_social IN ('Viejos Amigos', 'Tráigame Eso')
order by c.fecha_incorporacion, e.razon_social;

/*3) Listado de las solicitudes consignando razón social, dirección y e_mail de la
empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
fecha d solicitud y descripción de cargo.*/

select razon_social,direccion,e_mail,desc_cargo,anios_experiencia
FROM solicitudes_empresas sol
inner join empresas e ON e.cuit=sol.cuit
inner join cargos c ON c.cod_cargo=sol.cod_cargo
order by fecha_solicitud ;

/*4) ¿Listar todos los candidatos con título de bachiller o un título de educación no
formal. Mostrar nombre y apellido, descripción del título y DNI.*/

select p.dni,nombre,apellido,desc_titulo
from personas p
inner join personas_titulos pe ON p.dni=pe.dni
inner join titulos t ON t.cod_titulo=pe.cod_titulo
where desc_titulo in ("Bachiller") or tipo_titulo in("Educacion no formal ")
order by 1 asc;

/*5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.*/

select nombre,apellido,desc_titulo
from personas p
inner join personas_titulos pe ON p.dni=pe.dni
inner join titulos t ON t.cod_titulo=pe.cod_titulo;

/*6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
S.A */

SELECT concat( apellido," , ",nombre," tiene como referencia a ",ifnull( persona_contacto,"sin contacto")," cuando trabajo en ",razon_social)Antecedentes
FROM antecedentes ant
inner join personas per on ant.dni=per.dni
inner join empresas emp on ant.cuit=emp.cuit
where persona_contacto in ("Armando Esteban Quito","Felipe Rojas") or persona_contacto is null;

/*7) Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del
cargo solicitado y edad máxima y mínima . Encabezado:*/

SELECT razon_social EMPRESA, fecha_solicitud "FECHA DE SOLICITUD",desc_cargo CARGO,edad_minima "EDAD MINIMA",edad_maxima "EDAD MAXIMA"
FROM empresas emp
inner join solicitudes_empresas soli on soli.cuit=emp.cuit
inner join cargos car on car.cod_cargo=soli.cod_cargo
where razon_social in ("Viejos Amigos");

/*8) Mostrar los antecedentes de cada postulante:*/

SELECT concat(nombre," ",apellido)Postulante ,desc_cargo Cargo
FROM entrevistas ent
inner join cargos car on car.cod_cargo=ent.cod_cargo
inner join personas per on per.dni=ent.dni;

/*9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
ascendente por empresa y descendente por cargo:*/

select razon_social,desc_cargo,desc_evaluacion,resultado
from evaluaciones eva
inner join entrevistas_evaluaciones ent on ent.cod_evaluacion=eva.cod_evaluacion
inner join  entrevistas entre on entre.nro_entrevista=ent.nro_entrevista
inner join  cargos carg on entre.cod_cargo=carg.cod_cargo
inner join empresas emp on emp.cuit=entre.cuit
order by razon_social asc , desc_cargo desc;

/*LEFT/RIGHT JOIN*/
/*10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.*/

select emp.cuit, razon_social,ifnull(fecha_solicitud,"Sin Solicitudes")Solicitudes ,ifnull(desc_cargo,"Sin Solicitudes")Cargo
from empresas emp
left join solicitudes_empresas so ON emp.cuit=so.cuit
left join cargos ca ON ca.cod_cargo=so.cod_cargo;

/*11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
y si se hubiese realizado un contrato los datos de la(s) persona(s).*/

select distinct emp.cuit,razon_social,desc_cargo,per.dni,per.nombre,per.apellido
from empresas emp 
inner join solicitudes_empresas so on so.cuit=emp.cuit
inner join cargos ca on ca.cod_cargo=so.cod_cargo
left join contratos cont on so.cuit=cont.cuit
and so.cod_cargo=cont.cod_cargo
and so.fecha_solicitud=cont.fecha_solicitud
left join personas per on per.dni=cont.dni;

/*12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
las solicitudes para las cuales no se haya realizado un contrato*/

select emp.cuit,razon_social,desc_cargo
from solicitudes_empresas so
inner join empresas emp on so.cuit=emp.cuit
inner join cargos car on so.cod_cargo=car.cod_cargo
left join contratos con on so.cuit=con.cuit
and so.cod_cargo=con.cod_cargo
and so.fecha_solicitud=con.fecha_solicitud
where nro_contrato is null;


/*13) Listar todos los cargos y para aquellos que hayan sido realizados (como
antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
lo ocupó.*/

select car.desc_cargo,per.dni,per.apellido
from cargos car
left join antecedentes ant on car.cod_cargo=ant.cod_cargo
left join personas per on per.dni=ant.dni;

/*BASE DE DATOS: AFATSE
SELF JOIN

14) Indicar todos los instructores que tengan un supervisor. Mostrar:*/
select *
from instructores;

select ins.cuil,ins.nombre,ins.apellido, sup.cuil,sup.nombre,sup.apellido
from instructores ins
inner join instructores sup on sup.cuil=ins.cuil_supervisor ;

/*15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
campos en blanco*/
select ins.cuil,ins.nombre,ins.apellido, ifnull(sup.cuil,"  "),ifnull(sup.nombre,"  "),ifnull(sup.apellido,"  ")
from instructores ins
left join instructores sup on sup.cuil=ins.cuil_supervisor ;

/*disctinct elimina filas repetidas*/


/*16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
ascendente por nombre y apellido de supervisor y descendente por fecha*/


/*Práctica Nº 3: Funciones de presentación de datos
Practica Complementaria: 1 – 2 – 3 – 4 – 5
BASE DE DATOS: AGENCIA_PERSONAL

1) Para aquellos contratos que no hayan terminado calcular la fecha de caducidad
como la fecha de solicitud más 30 días (no actualizar la base de datos). Función ADDDATE*/

select c.nro_contrato,c.fecha_incorporacion,c.fecha_finalizacion_contrato , DATE_ADD(c.fecha_solicitud , interval 1 month) 'FECHA CADUCIDAD'
from contratos c
where c.fecha_caducidad is null;

/*2) Mostrar los contratos. Indicar nombre y apellido de la persona, razón social de la
empresa fecha de inicio del contrato y fecha de caducidad del contrato. Si la fecha no ha
terminado mostrar “Contrato Vigente”. Función IFNULL*/

select p.nombre,p.apellido,e.razon_social,c.fecha_incorporacion,ifnull(c.fecha_caducidad,"Contrato Vigente") caducidad
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join personas p on c.dni=p.dni;

/*3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
cantidad de días que finalizaron antes de tiempo. Función DATEDIFF*/

select c.nro_contrato,c.fecha_incorporacion,c.fecha_finalizacion_contrato,c.fecha_caducidad,c.sueldo,c.dni,c.cuit,c.cod_cargo, datediff(c.fecha_finalizacion_contrato,c.fecha_caducidad) "DIAS ANTES"
from contratos c
where c.fecha_caducidad < c.fecha_finalizacion_contrato
order by c.nro_contrato desc;

/*4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
calcula como la fecha actual más dos meses. Función ADDDATE con INVERVAL*/

SELECT e.cuit,e.razon_social,e.direccion,c.anio_contrato,c.mes_contrato,c.importe_comision,(now() + interval 2 month) fecha_finalizacion
FROM comisiones c
inner join contratos con on c.nro_contrato=con.nro_contrato
inner join empresas e on con.cuit=e.cuit
where fecha_pago is null;

/*5) Mostrar en qué día mes y año nacieron las personas (mostrarlos en columnas
separadas) y sus nombres y apellidos concatenados. Funciones DAY, YEAR, MONTH y
CONCAT*/

select concat(p.apellido," ",p.nombre)"Nombre y apellido",p.fecha_nacimiento,day(p.fecha_nacimiento) DIA ,month(p.fecha_nacimiento) MES ,year(p.fecha_nacimiento) AÑO
from personas p;

/*Practica Nº 4: GROUP BY - HAVING
Practica en Clase: 1 – 2 – 4 –8 – 9 – 13 – 14 – 15
Práctica Complementaria: 3 – 5 – 6 –7 – 10 – 11 – 12
BASE DE DATOS: AGENCIA_PERSONAL


1) Mostrar las comisiones pagadas por la empresa Tráigame eso*/

select e.razon_social,sum(c.importe_comision)
from comisiones c
inner join contratos con on c.nro_contrato=con.nro_contrato
inner join empresas e on e.cuit=con.cuit
where e.razon_social like "tr%"
group by 1;

/*2) Ídem 1) pero para todas las empresas.*/
select e.razon_social,sum(c.importe_comision)
from comisiones c
inner join contratos con on c.nro_contrato=con.nro_contrato
inner join empresas e on e.cuit=con.cuit
group by 1;

/*3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
en forma ascendente y luego por desviación estándar en forma descendente*/

select  e.nombre_entrevistador,en.cod_evaluacion,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO,variance(en.resultado) VARIANZA
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
group by 1,2;

/*4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
de evaluación.*/
select  e.nombre_entrevistador,en.cod_evaluacion,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO,variance(en.resultado) VARIANZA
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
where e.nombre_entrevistador like "Angélica Doria" 
group by 1,2
having avg(en.resultado)>71 ;

/*5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014*/

select nombre_entrevistador,count(*)'Cantidad de entrevistas'
from entrevistas
where fecha_entrevista between "2014-10-01" AND "2014-10-31"
group by 1;

/*6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
Ordenado por cantidad de entrevistas*/

select  e.nombre_entrevistador,en.cod_evaluacion,count(*)
,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
group by 1,2
having avg(en.resultado)>71 
ORDER BY 3, AVG(en.resultado) DESC, STD(en.resultado) ASC;

/*7) Ídem 6) para aquellos cuya cantidad de entrevistas por c'okdigo de evalucaicpon
sea myor mayor que 1. Ordenado por nombre en forma descendente y por codigo de
evalucacion en forma ascendente*/

select  e.nombre_entrevistador,en.cod_evaluacion,count(*)
,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
group by 1,2
having avg(en.resultado)>71 
and count(en.cod_evaluacion) >1
ORDER BY 3, AVG(en.resultado) DESC, STD(en.resultado) ASC;

/*8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
cantidad a pagadas.*/

SELECT com.nro_contrato, count(*) "Total", count(com.fecha_pago) "Pagadas",
	count(*) - count(com.fecha_pago) "A Pagar"
FROM comisiones com
GROUP BY com.nro_contrato;

/*9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
el % de impagas.*/

SELECT com.nro_contrato, count(*) "Total",(count(com.fecha_pago)/count(*)*100) "Pagadas",
	(((count(*) - count(com.fecha_pago))/count(*))*100) "A Pagar"
FROM comisiones com
GROUP BY com.nro_contrato;

/*10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
diferencia respecto al total de solicitudes.*/

select count(distinct s.cuit) Cantidad,count(s.cuit)-count(distinct s.cuit) 'Cantidad diferencia'
from solicitudes_empresas s;

/*11) Cantidad de solicitudes por empresas*/

SELECT se.cuit, emp.razon_social, count(*)
FROM solicitudes_empresas se
INNER JOIN empresas emp ON emp.cuit = se.cuit
GROUP BY se.cuit, emp.razon_social;

/*12) Cantidad de solicitudes por empresas y cargos.*/

SELECT se.cuit, emp.razon_social,se.cod_cargo, count(*)
FROM solicitudes_empresas se
INNER JOIN empresas emp ON emp.cuit = se.cuit
GROUP BY se.cuit, emp.razon_social,se.cod_cargo;

/*LEFT/RIGHT JOIN

13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.*/

select emp.cuit,emp.razon_social,emp.direccion,count(distinct a.dni) cantidad
from empresas emp 
left join antecedentes a on emp.cuit=a.cuit
group by emp.cuit;

/*14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
0. Agregar algún cargo que nunca haya sido solicitado*/

select c.cod_cargo,c.desc_cargo,count(s.cuit)
from cargos c
left join solicitudes_empresas s on c.cod_cargo=s.cod_cargo
group by c.cod_cargo
order by count(s.cuit) desc;

/*15) Indicar los cargos que hayan sido solicitados menos de 2 veces*/

select c.cod_cargo,c.desc_cargo,count(s.cuit)
from cargos c
left join solicitudes_empresas s on c.cod_cargo=s.cod_cargo
group by c.cod_cargo
having count(s.cuit)<2
order by count(s.cuit) desc;

/*Practica Nº 5: Subconsultas, Tablas Temporales y Variables
Practica en Clase: 1 – 2 – 3 – 4 –7 – 9 – 10 – 11 – 12 – 16
Práctica Complementaria: 5 – 6 – 8 – 13 – 14 – 15 – 17
BASE DE DATOS: AGENCIA_PERSONAL

1 )¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?*/

select distinct p.dni,p.nombre,p.apellido
from personas p
inner join contratos c on p.dni=c.dni
where c.cuit in (select co.cuit
				 from contratos co
				inner join personas pe on co.dni=pe.dni
                where pe.nombre like "Ste%");
                
-- otra forma 
create temporary table con_sl
select  distinct co.cuit
from contratos co
inner join personas pe on co.dni=pe.dni
where pe.nombre like "Ste%";

select distinct p.dni,p.nombre,p.apellido
from contratos c
inner join con_sl on c.cuit=con_sl.cuit
inner join personas p on c.dni =p.dni;


/*2) Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados
de Viejos Amigos.*/


select  max(c.sueldo) into @maximo_s
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join personas p on c.dni=p.dni
where e.razon_social like "Viej%";

select per.dni,CONCAT(per.nombre, per.apellido),con.sueldo
from personas per
inner join contratos con on per.dni=con.dni
where con.sueldo<@maximo_s;


-- otra forma
select per.dni,CONCAT(per.nombre, per.apellido),con.sueldo
from personas per
inner join contratos con on per.dni=con.dni
where con.sueldo< (select  max(c.sueldo)
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join personas p on c.dni=p.dni
where e.razon_social like "Viej%");

/*3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
de aquellas cuyo promedio supere al promedio de Tráigame eso*/

select avg(c.importe_comision) into @prom_tra_eso
from empresas e
inner join contratos con on e.cuit=con.cuit 
inner join comisiones c on con.nro_contrato= c.nro_contrato
where e.razon_social like "trai%";

select en.cuit,en.razon_social,avg(cn.importe_comision)
from empresas en
inner join contratos conn on en.cuit=conn.cuit 
inner join comisiones cn on conn.nro_contrato= cn.nro_contrato
group by 1,2
having avg(cn.importe_comision)> @prom_tra_eso;


/*4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las 
comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes 
contrato, año contrato , nro. contrato, nombre y apellido del empleado.*/

select avg(c.importe_comision) into @prom_tot
from comisiones c ;

select  en.razon_social, p.nombre,p.apellido,conn.nro_contrato,cn.mes_contrato,cn.anio_contrato,cn.importe_comision
from empresas en
inner join contratos conn on en.cuit=conn.cuit 
inner join comisiones cn on conn.nro_contrato= cn.nro_contrato
inner join personas p on conn.dni=p.dni
where cn.importe_comision < @prom_tot
group by 2,3,4;

/*5) Determinar las empresas que pagaron más que el promedio*/

select avg(c.importe_comision) into @prom_tot
from comisiones c ;

select  en.razon_social, p.nombre,p.apellido,conn.nro_contrato,cn.mes_contrato,cn.anio_contrato,cn.importe_comision
from empresas en
inner join contratos conn on en.cuit=conn.cuit 
inner join comisiones cn on conn.nro_contrato= cn.nro_contrato
inner join personas p on conn.dni=p.dni
where cn.importe_comision > @prom_tot
group by 2,3,4;

/*6) Seleccionar los empleados que no tengan educación no formal o terciario*/

select distinct p.nombre,p.apellido
from personas p 
inner join personas_titulos pert on p.dni=pert.dni
inner join titulos t on pert.cod_titulo=t.cod_titulo
where t.tipo_titulo  like "Terciario" or t.tipo_titulo not like "Educacion no formal" ;

select distinct pe.nombre,pe.apellido
from personas pe
WHERE pe.dni NOT IN (select p.dni
from personas p 
inner join personas_titulos pert on p.dni=pert.dni
inner join titulos t on pert.cod_titulo=t.cod_titulo
where t.tipo_titulo  like "Terciario" or t.tipo_titulo  like "Educacion no formal");

/*7) Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los
contrató.*/
create temporary table promedio
SELECT con.cuit, AVG(con.sueldo) prom
FROM contratos con
GROUP BY 1;

SELECT con.dni, per.nombre, con.cuit, con.sueldo, prom
FROM contratos con
INNER JOIN personas per ON con.dni = per.dni
INNER JOIN promedio prom ON con.cuit = prom.cuit
WHERE con.sueldo > prom;

/*8) Determinar las empresas que pagaron en promedio la mayor o menor de las comisiones*/

select en.razon_social,avg(c.importe_comision)
from empresas en
inner join contratos con on en.cuit=con.cuit 
inner join comisiones c on con.nro_contrato= c.nro_contrato
group by 1
HAVING AVG(c.importe_comision) = (SELECT MAX(com.importe_comision)
FROM comisiones com)
OR AVG(c.importe_comision) = (SELECT MIN(comis.importe_comision)
FROM comisiones comis);

/*  BASE DE DATOS: AFATSE
9) Alumnos que se hayan inscripto a más cursos que Antoine de Saint-Exupery. Mostrar
todos los datos de los alumnos, la cantidad de cursos a la que se inscribió y cuantas
veces más que Antoine de Saint-Exupery */

select count(i.dni) into @contador_cursos
from alumnos a
inner join inscripciones i on a.dni=i.dni
where a.nombre like "Antoine de" and a.apellido like "Saint-Exupery" ;

select a.dni,a.nombre,a.apellido,count(i.dni) cursos, count(i.dni)-@contador_cursos
from alumnos a
inner join inscripciones i on a.dni=i.dni
group by 1
having cursos > @contador_cursos;

/*10) En el año 2014, qué cantidad de alumnos se han inscripto a los Planes de Capacitación
indicando para cada Plan de Capacitación la cantidad de alumnos inscriptos y el
porcentaje que representa respecto del total de inscriptos a los Planes de Capacitación
dictados en el año.*/

select count(i.dni) into @valor
from plan_capacitacion pc
inner join inscripciones i on pc.nom_plan=i.nom_plan
inner join alumnos a on i.dni=a.dni
where year(i.fecha_inscripcion)=2014;

select pc.nom_plan,count(i.dni) cantidad,((count(i.dni)*100)/@valor) Porcentaje
from plan_capacitacion pc
inner join inscripciones i on pc.nom_plan=i.nom_plan
inner join alumnos a on i.dni=a.dni
where year(i.fecha_inscripcion)=2014
group by 1;


-- 11) Indicar el valor actual de los planes de Capacitación 

SELECT vp.nom_plan,vp.fecha_desde_plan,vp.valor_plan
FROM valores_plan vp
WHERE vp.fecha_desde_plan = (SELECT MAX(valpl.fecha_desde_plan)
FROM valores_plan valpl
WHERE vp.nom_plan = valpl.nom_plan)
group by 1;

-- 12) Plan de capacitacion mas barato. Indicar los datos del plan de capacitacion y el valor actual

create temporary table valores_actuales
SELECT vp.nom_plan,vp.fecha_desde_plan,vp.valor_plan
FROM valores_plan vp
WHERE vp.fecha_desde_plan = (SELECT MAX(valpl.fecha_desde_plan)
FROM valores_plan valpl
WHERE vp.nom_plan = valpl.nom_plan)
group by 1;

select min(v.valor_plan) into @val
from valores_actuales v;

select *
from plan_capacitacion p 
inner join valores_actuales va on p.nom_plan=va.nom_plan
where va.valor_plan = @val;


/*13) ¿Qué instructores que han dictado algún curso del Plan de Capacitación “Marketing 1” el
año 2014 y no vayan a dictarlo este año? (año 2015)*/


SELECT ci.cuil,c.fecha_ini
FROM cursos_instructores ci
INNER JOIN cursos c ON c.nom_plan = ci.nom_plan
INNER JOIN instructores ins ON ins.cuil = ci.cuil 
						 AND ci.nro_curso = c.nro_curso
WHERE (YEAR(fecha_ini) = '2014'  AND ci.nom_plan = "Marketing 1")
and ci.cuil not in (SELECT cil.cuil
FROM cursos_instructores cil
INNER JOIN cursos ce ON ce.nom_plan = cil.nom_plan
INNER JOIN instructores inst ON inst.cuil = cil.cuil 
						 AND cil.nro_curso = ce.nro_curso
WHERE YEAR(ce.fecha_ini) = '2015'  AND cil.nom_plan = "Marketing 1");

-- 14) Alumnos que tengan todas sus cuotas pagas hasta la fecha.

SELECT *
FROM alumnos alu 
where alu.dni not in (select a.dni
from alumnos a
inner join cuotas c on alu.dni=c.dni
and c.fecha_pago is  null);

/*15) Alumnos cuyo promedio supere al del curso que realizan. Mostrar dni, nombre y apellido,
promedio y promedio del curso.*/

DROP TEMPORARY TABLE IF EXISTS prom_alu;
create temporary table prom_alu
select a.dni,e.nro_curso,avg(e.nota) alumnoprom
from alumnos a
inner join evaluaciones e on a.dni=e.dni
group by 1,2;

DROP TEMPORARY TABLE IF EXISTS prom_curso;
create temporary table prom_curso
select e.nro_curso,avg(e.nota) cursoprom
from alumnos a
inner join evaluaciones e on a.dni=e.dni
group by 1;

select distinct al.dni,al.nombre,al.apellido,alumnoprom,cursoprom
from alumnos al
inner join evaluaciones ev on al.dni=ev.dni 
inner join prom_curso pr on ev.nro_curso=pr.nro_curso
inner join prom_alu p on ev.dni=p.dni and p.dni=al.dni
where alumnoprom > cursoprom
group by 1,2,3;


/*16)Para conocer la disponibilidad de lugar en los cursos que empiezan en abril para
lanzar una campaña se desea conocer la cantidad de alumnos inscriptos a los cursos
que comienzan a partir del 1/04/2014 indicando: Plan de Capacitación, curso, fecha de
inicio, salón, cantidad de alumnos inscriptos y diferencia con el cupo de alumnos
registrado para el curso que tengan al más del 80% de lugares disponibles respecto del
cupo.*/

SELECT ins.nom_plan, ins.nro_curso, fecha_ini, salon, cupo, COUNT(ins.dni) "cantidad inscripciones",
cupo-COUNT(ins.dni) "diferencia",  (COUNT(*) / cupo) * 100  porcentaje_ocupado
FROM alumnos alu
INNER JOIN inscripciones ins ON ins.dni = alu.dni
INNER JOIN cursos c ON c.nom_plan = ins.nom_plan
WHERE fecha_ini > "2014/04/01"
GROUP BY ins.nom_plan, ins.nro_curso, fecha_ini, salon, cupo
having porcentaje_ocupado> 80;

/*17) Indicar el último incremento de los valores de los planes de capacitación, consignando
nombre del plan fecha del valor actual, fecha el valor anterior, valor actual, valor anterior y
diferencia entre los valores. Si el curso tiene un único valor mostrar la fecha anterior en
NULL el valor anterior en 0 y la diferencia en 0.*/


/*PRACTICA 8*/
/*INSERT*/
/*1) Agregar el nuevo instructor Daniel Tapia con cuil: 44-44444444-4, teléfono: 444-444444,
email: dotapia@gmail.com, dirección Ayacucho 4444 y sin supervisor.*/

start transaction;
insert into instructores
values
( "44-44444444-4", "Daniel", "Tapia", "444-444444", "dotapia@gmail.com", "Ayacucho 4444", 
NULL );
COMMIT;


/*2)*/

start transaction;
INSERT INTO plan_capacitacion
VALUES 
( "Administrador de BD", "Instalación y configuración MySQL. Lenguaje SQL. Usuarios y 
permisos", 300, "presencial"); 
INSERT INTO `plan_temas` 
VALUES 
( "Administrador de BD", "Instalación MySQL", "Distintas configuraciones de instalación"), 
( "Administrador de BD", "Configuración DBMS", "Variables de entorno, su uso y 
configuración"), 
( "Administrador de BD", "Lenguaje SQL", " DML, DDL y TCL"), 
( "Administrador de BD", "Usuarios y Permisos", "Permisos de usuarios y DCL");
INSERT INTO examenes
VALUES 
( "Administrador de BD", 1), 
( "Administrador de BD", 2), 
( "Administrador de BD", 3), 
("Administrador de BD", 4);
INSERT INTO examenes_temas 
VALUES 
( "Administrador de BD", "Instalación MySQL", 1), 
( "Administrador de BD", "Configuración DBMS", 2), 
( "Administrador de BD", "Lenguaje SQL", 3),
( "Administrador de BD", "Usuarios y Permisos", 4);

INSERT INTO materiales (cod_material, desc_material, url_descarga, autores, tamanio, 
fecha_creacion, cant_disponible, punto_pedido, cantidad_a_pedir ) 
VALUES 
( "AP-010", "DBA en MySQL", "www.afatse.com.ar/apuntes?AP=010", "José Román", 2, 
"2009/03/01", 0, 0, 0), 
("AP-011", "SQL en MySQL", " www.afatse.com.ar/apuntes?AP=011", "Juan López", 3, 
"2009/04/01", 0, 0, 0) ;
INSERT INTO materiales_plan
VALUES ( "Administrador de BD", "UT-001", 0), 
("Administrador de BD", "UT-002", 0),
("Administrador de BD", "UT-003", 0),
("Administrador de BD", "UT-004", 0), 
("Administrador de BD", "AP-010", 0) ,
("Administrador de BD", "AP-011", 0) ;
INSERT INTO valores_plan
VALUES ( "Administrador de BD", "2009/02/01", 150) ;
COMMIT;

/*UPDATE*/
/*1) Como resultado de una mudanza a otro edificio más grande se ha incrementado la
capacidad de los salones, además la experiencia que han adquirido los instructores permite
ampliar el cupo de los cursos. Para todos los curso con modalidad presencial y
semipresencial aumentar el cupo de la siguiente forma:
● 50% para los cursos con cupo menor a 20
● 25% para los cursos con cupo mayor o igual a 20*/

start transaction;
update cursos set cupo = cupo*1.25 where cupo>=20;
update cursos set cupo = cupo*1.50 where cupo<20;
commit;

#si aumento voy de mayor a menor
#si reduzco voy de menor a mayor

/*1) Convertir a Daniel Tapia en el supervisor de Henri Amiel y Franz Kafka. Utilizar el cuil de
cada uno.*/

start transaction;
update instructores set cuil_supervisor="99-99999999-9"
where cuil in ("55-55555555-5","66-66666666-6");

rollback;

/*2) Ídem 1) pero utilizar variables para obtener el cuil de los 3 instructores.*/

select cuil into @inst_1
from instructores
where cuil="66-66666666-6";

select cuil into @inst_2
from instructores
where cuil="55-55555555-5";

select cuil into @supervisor
from instructores
where cuil="99-99999999-9";


start transaction;
update instructores set cuil_supervisor=@supervisor
where cuil in (@inst_1,@inst_2);
commit;


/*3) El alumno Victor Hugo se ha mudado. Actualizar su dirección a Italia 2323 y su teléfono
nuevo es 3232323.*/

select dni into @dni
from alumnos 
where nombre like "Victor" and apellido like "Hugo";

start transaction;
update alumnos set direccion="Italia 2324" , tel="3232323"
where dni=@dni;
commit;

/*DELETE
4) Eliminar el plan creado en la consulta 2). Ayuda: Tener en cuenta las CF para poder
eliminarlo.*/
start transaction;
DELETE FROM valores_plan WHERE nom_plan = "Administrador de BD" ;
DELETE FROM materiales_plan WHERE nom_plan = "Administrador de BD" ;
DELETE FROM examenes_temas WHERE nom_plan = "Administrador de BD" ;
DELETE FROM examenes WHERE nom_plan = "Administrador de BD";
DELETE FROM plan_temas WHERE nom_plan = "Administrador de BD" ;
DELETE FROM plan_capacitacion WHERE nom_plan = "Administrador de BD";
COMMIT;

/*5) Eliminar los nuevos apuntes AP-008 y AP-009. Ayuda: Tener en cuenta las CF para poder
eliminarlo.*/

SELECT * 
FROM materiales_plan
WHERE cod_material IN ( "AP-008", "AP-009");

start transaction;
delete from materiales where cod_material in ( "AP-008", "AP-009");
commit;

/*6) Eliminar al instructor Daniel Tapia. Ayuda: Tener en cuenta las CF para poder eliminarlo.*/

select *
from cursos_instructores
where cuil="44-44444444-4";

select *
from evaluaciones
where cuil="44-44444444-4";

start transaction;
update instructores set cuil_supervisor=null
where cuil_supervisor="44-44444444-4";
delete from instructores where cuil="44-44444444-4";
commit;

/*7) Eliminar los inscriptos al curso de Marketing 3 curso numero 1*/

start transaction;
delete from inscripciones where nom_plan="Marketing 3" and nro_curso="1";
commit;

/*8) Eliminar los instructores que tienen de supervisor a Elias Yanes (CUIL 99-99999999-9)*/

start transaction;
delete from instructores where cuil_supervisor="99-99999999-9";
rollback;

/*9) Ídem 11) pero usar una variable para obtener el CUIL de Elias Yanes.*/

select cuil into @elias
from instructores
where nombre="Elias" and apellido="Yanes";

start transaction;
delete from instructores where cuil_supervisor=@elias;
commit;

/*10) Eliminar todos los apuntes que tengan como autora o coautora a Erica de Forifregoro*/

select *
from materiales
where  autores like "%Erica de Forifregoro%";

select *
from materiales_plan
where cod_material="AP-006";

start transaction;
delete from materiales_plan where cod_material="AP-006";
delete from materiales where  autores like "%Erica de Forifregoro%";
commit;


/*INSERT SELECT
1) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/06/2009 con un 20 por ciento más que su último valor. Eliminar las filas agregadas.*/

start transaction;
insert into `valores_plan`( `nom_plan`, `fecha_desde_plan`, `valor_plan`)
select val.`nom_plan`,'20090601', val.`valor_plan`*1.2
from valores_plan val
inner join
(
select vp.`nom_plan`, max(vp.`fecha_desde_plan`) ult_fecha
from valores_plan vp
group by vp.`nom_plan`
) fechas
 on val.`nom_plan`=fechas.nom_plan
 and val.`fecha_desde_plan`=fechas.ult_fecha;
commit;

/*2) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/08/2009, con la siguiente regla: Los cursos cuyo último valor sea menor a $90
aumentarlos en un 20% al resto aumentarlos un 12%.*/

start transaction;
insert into `valores_plan`( `nom_plan`, `fecha_desde_plan`, `valor_plan`)
select val.`nom_plan`,'20190801', val.`valor_plan`*1.12
from valores_plan val
inner join
(
select vp.`nom_plan`, max(vp.`fecha_desde_plan`) ult_fecha
from valores_plan vp
group by vp.`nom_plan`
) fechas
 on val.`nom_plan`=fechas.nom_plan
 and val.`fecha_desde_plan`=fechas.ult_fecha
where val.`valor_plan`>=90;

insert into `valores_plan`( `nom_plan`, `fecha_desde_plan`, `valor_plan`)
select val.`nom_plan`,'20190801', val.`valor_plan`*1.20
from valores_plan val
inner join
(
select vp.`nom_plan`, max(vp.`fecha_desde_plan`) ult_fecha
from valores_plan vp
group by vp.`nom_plan`
) fechas
 on val.`nom_plan`=fechas.nom_plan
 and val.`fecha_desde_plan`=fechas.ult_fecha
where val.`valor_plan`<90;
commit;

/*3) Crear un nuevo plan: Marketing 1 Presen. Con los mismos datos que el plan
Marketing 1 pero con modalidad presencial. Este plan tendrá los mismos temas, exámenes
y materiales que Marketing 1 pero con un costo un 50% superior, para todos los períodos
de este año que ya estén definidos costos del plan.*/

start transaction;

insert into plan_capacitacion
select 'Marketing 1 Presen', desc_plan,hs,'presencial'
from `plan_capacitacion`
where nom_plan= 'Marketing 1';

insert into plan_temas
select 'Marketing 1 Presen', titulo,detalle
from plan_temas
where nom_plan= 'Marketing 1';

insert into `examenes`
select 'Marketing 1 Presen', nro_examen
from `examenes`
where nom_plan= 'Marketing 1';

insert into `examenes_temas`
select 'Marketing 1 Presen',titulo,nro_examen
from `examenes_temas`
where nom_plan= 'Marketing 1';

insert into `valores_plan`(`nom_plan`, `fecha_desde_plan`, `valor_plan`)
select 'Marketing 1 Presen',fecha_desde_plan,valor_plan*1.5
from `valores_plan`
where nom_plan= 'Marketing 1' and year(fecha_desde_plan)=2019;

commit;


/*UPDATE con JOIN
/*4) Cambiar el supervisor de aquellos instructores que dictan Reparac PC Avanzada este año a
66-66666666-6 (Franz Kafka).*/

start transaction;
update
instructores i inner join
cursos_instructores ci
 on ci.cuil=i.cuil
set cuil_supervisor ='66-66666666-6'
where ci.`nom_plan`='Reparac PC Avanzada';
commit;

/*5) Cambiar el horario de los cursos de que dicta este año Franz Kafka (cuil ) desde las 16 hs.
Moverlos una hora más temprano.*/

start transaction;
update
`cursos_horarios` ch inner join
 `cursos_instructores` ci on ch.`nom_plan`=ci.`nom_plan`
 and ch.`nro_curso`=ci.`nro_curso` inner join
 `cursos` c on ci.`nom_plan`=c.`nom_plan`
 and ci.`nro_curso`=c.`nro_curso`
set ch.`hora_inicio`=ADDTIME(ch.`hora_inicio`,-010000)
,ch.`hora_fin`=ADDTIME(ch.`hora_fin`,-010000)
where ci.`cuil`='66-66666666-6' and ch.`hora_inicio`='160000'
 and year(c.`fecha_ini`)=2015;
commit;

/*Práctica Nº 12: STORE PROCEDURES y FUNCTIONS
BASE DE DATOS: AFATSE

1) Crear un procedimiento almacenado llamado plan_lista_precios_actual que devuelva los
planes de capacitación indicando:
nom_plan modalidad valor_actual*/

call plan_lista_precios_actual();

/*BEGIN

drop temporary table if exists f_actual;
create temporary table f_actual
select v.nom_plan, max(v.fecha_desde_plan) ult_f
from valores_plan v
group by 1;

select p.nom_plan,p.modalidad,f.ult_f,v.valor_plan
 from plan_capacitacion p
 inner join f_actual f on p.nom_plan=f.nom_plan 
 inner join valores_plan v on f.nom_plan=v.nom_plan and f.ult_f=v.fecha_desde_plan;
 
drop temporary table if exists f_actual;


END*/

/*2) Crear un procedimiento almacenado llamado plan_lista_precios_a_fecha que dada una
fecha devuelva los planes de capacitación indicando:
nombre_plan modalidad valor_a_fecha */

call plan_lista_precios_a_fech(20141201);
/*BEGIN

drop temporary table if exists f_actual;
create temporary table f_actual
select v.nom_plan, max(v.fecha_desde_plan) ult_f
from valores_plan v
where v.fecha_desde_plan<=fecha_hasta
group by 1;

select p.nom_plan,p.modalidad,f.ult_f,v.valor_plan
 from plan_capacitacion p
 inner join f_actual f on p.nom_plan=f.nom_plan 
 inner join valores_plan v on f.nom_plan=v.nom_plan and f.ult_f=v.fecha_desde_plan;
 
drop temporary table if exists f_actual;


END*/

/*4) Crear una función llamada plan_valor que reciba el nombre del plan y una fecha y devuelva
el valor de dicho plan a esa fecha.*/

call plan_valor ("Reparacion PC", 20090601);

/*CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_valor`(in nombre1 varchar(20) , in fecha1 date)
BEGIN
select v.valor_plan 
from valores_plan v 
where v.nom_plan=nombre1 and v.fecha_desde_plan=fecha1;
END*/






















 













