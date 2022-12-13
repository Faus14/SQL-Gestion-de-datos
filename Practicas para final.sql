/*4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de
nacimiento, teléfono, y su dirección. Las cabeceras de las columnas serán:*/
select concat(p.nombre, " ",p.apellido)"Apellido y Nombre",p.fecha_nacimiento,p.Telefono,p.direccion
from personas p
where p.dni=28675888;


/*5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y
31345778. Ordenadas por fecha de Nacimiento*/
select concat(p.nombre, " ",p.apellido)"Apellido y Nombre",p.fecha_nacimiento,p.Telefono,p.direccion
from personas p
where p.dni in (27890765,29345777 ,31345778);


/*6) Mostrar las personas cuyo apellido empiece con la letra ‘G’.*/
select *
from personas p
where p.apellido like 'g%';

/*7) Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y 2000*/
select p.nombre,p.apellido,p.fecha_nacimiento
from personas p
where p.fecha_nacimiento between  '1980-01-01' and  '2000-12-31';


/*8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente por fecha de solicitud.*/
select *
from solicitudes_empresas
order by fecha_solicitud;


/*9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral
ordenados por fecha desde.*/
select *
from antecedentes a
where a.fecha_hasta is null;

/*11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas 30-
10504876-5 o 30-21098732-4.Rotule el encabezado: Nro Contrato DNI Salario CUIL*/

select c.nro_contrato,c.dni,c.sueldo,c.cuit
from contratos c
where c.sueldo >2000 and c.cuit in ('30-10504876-5' , '30-21098732-4')
order by nro_contrato;

/*12) Mostrar los títulos técnicos.*/
select *
from titulos t
where t.desc_titulo like 'tecnico%' ;

/*13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y
 el código de cargo sea 6; o hayan solicitado aspirantes de sexo femenino */
select *
from solicitudes_empresas s
where (s.fecha_solicitud > '2013-09-21' and s.cod_cargo = 6) or s.sexo='Femenino';


/*14) Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido
terminado.*/
select *
FROM contratos c
where c.sueldo > 2000 and c.fecha_caducidad is null;


/*Práctica Nº 2: JOINS*/

/*1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
sueldo acordado en el contrato.*/

select p.dni,p.nombre,p.apellido,c.sueldo
from contratos c
inner join personas p on c.dni = p.dni
where c.nro_contrato=5;

/*2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa.*/
select c.dni, c.nro_contrato, c.fecha_incorporacion,c.fecha_solicitud, ifnull ( c.fecha_caducidad,'SIN FECHA') FechaCaducacion,e.razon_social
from contratos c 
inner join empresas e on c.cuit= e.cuit
where e.razon_social in ('Viejos Amigos' , 'Traigame eso')
order by c.fecha_incorporacion, e.razon_social;

/*3) Listado de las solicitudes consignando razón social, dirección y e_mail de la
empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
fecha d solicitud y descripción de cargo.*/

select e.razon_social,e.direccion,e.e_mail,c.desc_cargo,s.anios_experiencia
from solicitudes_empresas s
inner join empresas e on s.cuit=e.cuit
inner join cargos c on s.cod_cargo=c.cod_cargo
order by fecha_solicitud;


/*4) ¿Listar todos los candidatos con título de bachiller o un título de educación no
formal. Mostrar nombre y apellido, descripción del título y DNI.*/

select p.nombre,p.apellido,t.desc_titulo,p.dni
from personas p
inner join personas_titulos tp on p.dni=tp.dni
inner join titulos t on tp.cod_titulo=t.cod_titulo
where t.desc_titulo like 'bachiller%' or t.tipo_titulo like 'educacio%';

/*5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.*/

select nombre,apellido,desc_titulo
from personas p
inner join personas_titulos pe ON p.dni=pe.dni
inner join titulos t ON t.cod_titulo=pe.cod_titulo;

/*6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
S.A */

SELECT distinct(concat( apellido," , ",nombre," tiene como referencia a ",ifnull( persona_contacto,"sin contacto")," cuando trabajo en ",razon_social))Antecedentes
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
select concat(p.nombre," ",p.apellido)PERSONA,(c.desc_cargo)CARGO
from personas p
inner join entrevistas e on p.dni=e.dni
inner join cargos c on e.cod_cargo=c.cod_cargo;

/*9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
ascendente por empresa y descendente por cargo:*/
select emp.razon_social,c.desc_cargo,e.desc_evaluacion,ev.resultado
FROM evaluaciones e
inner join entrevistas_evaluaciones ev on e.cod_evaluacion=ev.cod_evaluacion
inner join entrevistas ent on ev.nro_entrevista=ent.nro_entrevista
inner join empresas emp on ent.cuit=emp.cuit
inner join cargos c on ent.cod_cargo=c.cod_cargo
order by emp.razon_social asc,desc_cargo desc  ;

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

select  emp.cuit,emp.razon_social,ca.desc_cargo,per.dni,per.nombre,per.apellido
from solicitudes_empresas s
left join empresas emp on s.cuit=emp.cuit
left join cargos ca on s.cod_cargo=ca.cod_cargo
left join contratos c on s.fecha_solicitud=c.fecha_solicitud
and emp.cuit=c.cuit
and ca.cod_cargo=c.cod_cargo
left join personas per on c.dni=per.dni;


/*12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
las solicitudes para las cuales no se haya realizado un contrato*/

select  emp.cuit,emp.razon_social,ca.desc_cargo
from solicitudes_empresas s
left join empresas emp on s.cuit=emp.cuit
left join cargos ca on s.cod_cargo=ca.cod_cargo
left join contratos c on s.fecha_solicitud=c.fecha_solicitud
and emp.cuit=c.cuit
and ca.cod_cargo=c.cod_cargo
where nro_contrato is null;

/*13) Listar todos los cargos y para aquellos que hayan sido realizados (como
antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
lo ocupó.*/

select c.desc_cargo,ifnull(p.nombre, "sin solicitud")Nombre,ifnull(p.apellido, "sin solicitud")Apellido,e.razon_social
from cargos c
left join antecedentes a on c.cod_cargo=a.cod_cargo
left join personas p on a.dni=p.dni
left join empresas e on a.cuit=e.cuit;


/*BASE DE DATOS: AFATSE
SELF JOIN

14) Indicar todos los instructores que tengan un supervisor. Mostrar:*/
select *
from instructores i
inner join instructores sup on i.cuil=sup.cuil_supervisor;

/*15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
campos en blanco*/


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

select c.nro_contrato,e.razon_social,p.nombre,p.apellido,c.fecha_incorporacion, ifnull(c.fecha_caducidad,'Contrato Vigente')FIN_CONTRATO
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join personas p on p.dni=c.dni;

/*3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
cantidad de días que finalizaron antes de tiempo. Función DATEDIFF*/

select c.nro_contrato,c.fecha_incorporacion,c.fecha_finalizacion_contrato,c.fecha_caducidad,c.sueldo,c.dni,c.cuit,c.cod_cargo,c.fecha_finalizacion_contrato,c.fecha_caducidad, datediff(c.fecha_finalizacion_contrato,c.fecha_caducidad) "DIAS ANTES"
from contratos c
where c.fecha_caducidad < c.fecha_finalizacion_contrato
order by c.nro_contrato desc;


/*4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
calcula como la fecha actual más dos meses. Función ADDDATE con INVERVAL*/

SELECT e.cuit,e.razon_social,e.direccion,c.anio_contrato,c.mes_contrato,c.importe_comision,(fecha_finalizacion_contrato + interval 2 month) fecha_finalizacion
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

select e.razon_social, sum(c.importe_comision) SUMA
from comisiones c
inner join contratos con on c.nro_contrato=con.nro_contrato
inner join empresas e on e.cuit=con.cuit
where e.razon_social like  "tr%"
group by 1;

/*2) Ídem 1) pero para todas las empresas.*/
select e.razon_social, sum(c.importe_comision) SUMA
from comisiones c
inner join contratos con on c.nro_contrato=con.nro_contrato
inner join empresas e on e.cuit=con.cuit
group by 1;

/*3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
en forma ascendente y luego por desviación estándar en forma descendente*/

select e.nombre_entrevistador,en.cod_evaluacion,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO,variance(en.resultado) VARIANZA
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
group by 1,2;


/*4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
de evaluación.*/

select e.nombre_entrevistador,en.cod_evaluacion,avg(en.resultado) PROMEDIO ,std(en.resultado) DESVIO,variance(en.resultado) VARIANZA
from entrevistas_evaluaciones en
inner join entrevistas e on en.nro_entrevista=e.nro_entrevista
where e.nombre_entrevistador="Angelica Doria"
group by 1,2
having avg(en.resultado)>71;

/*5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014*/

select e.nombre_entrevistador,count(*)
from entrevistas e
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
having avg(en.resultado)>71  and count(en.cod_evaluacion)>1
ORDER BY 3, AVG(en.resultado) DESC, STD(en.resultado) ASC;

/*8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
cantidad a pagadas.*/

select c.nro_contrato,count(*)"TOTAL",count(co.fecha_pago)"PAGAS",count(*)-count(co.fecha_pago)" A PAGAR"
from contratos c
inner join comisiones co on c.nro_contrato=co.nro_contrato
group by 1;

/*9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
el % de impagas.*/

select c.nro_contrato,count(*)"TOTAL",(count(co.fecha_pago)/count(*)*100)"PAGAS",((count(*)-count(co.fecha_pago))/count(*))*100" A PAGAR"
from contratos c
inner join comisiones co on c.nro_contrato=co.nro_contrato
group by 1;


/*10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
diferencia respecto al total de solicitudes.*/

select count(distinct s.cuit)'cantidad',count(*)-count(distinct s.cuit)'diferencia'
from solicitudes_empresas s;

/*11) Cantidad de solicitudes por empresas*/

select e.cuit,e.razon_social,count(*)
from empresas e
inner join solicitudes_empresas s on e.cuit=s.cuit
group by 1;

/*12) Cantidad de solicitudes por empresas y cargos.*/

select e.cuit,e.razon_social,c.cod_cargo,count(*)
from empresas e
inner join solicitudes_empresas s on e.cuit=s.cuit
inner join cargos c on s.cod_cargo=c.cod_cargo
group by 1,2,3;

/*LEFT/RIGHT JOIN

13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.*/

select e.cuit,e.razon_social,count(distinct a.dni)
from empresas e
left join antecedentes a on e.cuit=a.cuit
group by 1,2;

/*14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
0. Agregar algún cargo que nunca haya sido solicitado*/

select c.cod_cargo,c.desc_cargo,count(s.fecha_solicitud) "CANTIDAD"
from cargos c
left join solicitudes_empresas s on c.cod_cargo=s.cod_cargo
group by 1,2
order by count(s.fecha_solicitud) desc;

/*15) Indicar los cargos que hayan sido solicitados menos de 2 veces*/

select c.cod_cargo,c.desc_cargo,count(s.fecha_solicitud) "CANTIDAD"
from cargos c
left join solicitudes_empresas s on c.cod_cargo=s.cod_cargo
group by 1,2
having count(s.fecha_solicitud)<2
order by count(s.fecha_solicitud) desc;


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

select max(c.sueldo) into @max_s
from contratos c
inner join empresas e on c.cuit=e.cuit
where e.razon_social = "Viejos Amigos";

select p.dni,concat(p.nombre," ",p.apellido)Nombre,c.sueldo
from personas p
inner join contratos c on p.dni=c.dni
inner join empresas e on c.cuit=e.cuit
where c.sueldo<@max_s;


/*3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
de aquellas cuyo promedio supere al promedio de Tráigame eso*/

select avg(co.importe_comision) into @prom
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join comisiones co on c.nro_contrato=co.nro_contrato
where e.razon_social="Traigame eso";

select e.cuit,e.razon_social,avg(co.importe_comision)
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join comisiones co on c.nro_contrato=co.nro_contrato
group by 1,2
having avg(co.importe_comision)> @prom;

/*4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las 
comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes 
contrato, año contrato , nro. contrato, nombre y apellido del empleado.*/

select avg(co.importe_comision) into @prom2
from comisiones co;

select e.razon_social,concat(p.nombre," ",p.apellido)Nombre,c.nro_contrato,mes_contrato,anio_contrato,avg(co.importe_comision)
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join comisiones co on c.nro_contrato=co.nro_contrato
inner join personas p on c.dni=p.dni
group by 1,2,3
having avg(co.importe_comision)< @prom2;

/*5) Determinar las empresas que pagaron más que el promedio*/

select avg(co.importe_comision) into @prom3
from comisiones co ;

select e.cuit,e.razon_social,avg(co.importe_comision)
from contratos c
inner join empresas e on c.cuit=e.cuit
inner join comisiones co on c.nro_contrato=co.nro_contrato
group by 1,2
having avg(co.importe_comision)> @prom3;

/*6) Seleccionar los empleados que no tengan educación no formal o terciario*/
select *
from personas p
where p.dni  not in (select p.dni
from personas p
inner join personas_titulos pe on p.dni=pe.dni
inner join titulos t on pe.cod_titulo=t.cod_titulo
where t.tipo_titulo in ('Educacion no formal') or t.tipo_titulo in ("Terciario"));

-- asi no andaaaaa (por que hay dos q tienen difetentes titulos y no deberian aparecer)
select p.dni,p.apellido,p.nombre
from personas p
inner join personas_titulos pe on p.dni=pe.dni
inner join titulos t on pe.cod_titulo=t.cod_titulo
where t.tipo_titulo not in ("Educacion no formal" ,"Terciario")
group by 1;

/*7) Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los
contrató.*/

-- drop temporary table promedio1; (BORAR TABLA)
create temporary table promedio1
SELECT con.cuit, AVG(con.sueldo) prom
FROM contratos con
GROUP BY 1;

SELECT con.dni, per.nombre, con.cuit, con.sueldo, prom
FROM contratos con
INNER JOIN personas per ON con.dni = per.dni
Inner join promedio1 p on p.cuit=con.cuit
where con.sueldo>prom;

/*8) Determinar las empresas que pagaron en promedio la mayor o menor de las comisiones*/

select en.razon_social,avg(c.importe_comision) prom
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

select count(a.dni) cantidad into @cant
from alumnos a
inner join inscripciones i on a.dni=i.dni
where a.nombre="Antoine de";

select a.dni,a.nombre,a.apellido,count(a.dni)"cantidad de cursos a la que se inscribió", count(a.dni)-@cant "cuantas veces más"
from alumnos a
inner join inscripciones i on a.dni=i.dni
group by 1,2,3
having count(a.dni)>@cant;


/*10) En el año 2014, qué cantidad de alumnos se han inscripto a los Planes de Capacitación
indicando para cada Plan de Capacitación la cantidad de alumnos inscriptos y el
porcentaje que representa respecto del total de inscriptos a los Planes de Capacitación
dictados en el año.*/

select count(i.dni) into @tot
from plan_capacitacion pc
inner join inscripciones i on pc.nom_plan=i.nom_plan
inner join alumnos a on i.dni=a.dni
where year(i.fecha_inscripcion)=2014;

select pc.nom_plan,count(*), (count(*)/@tot)*100 "% total"
from plan_capacitacion pc
inner join inscripciones i on pc.nom_plan=i.nom_plan
inner join alumnos a on i.dni=a.dni
where year(i.fecha_inscripcion)=2014
group by 1;

-- 11) Indicar el valor actual de los planes de Capacitación 

-- DUDAAAAAA 



-- 12) Plan de capacitacion mas barato. Indicar los datos del plan de capacitacion y el valor actual

select *
from valores_plan v;


/*13) ¿Qué instructores que han dictado algún curso del Plan de Capacitación “Marketing 1” el
año 2014 y no vayan a dictarlo este año? (año 2015)*/

SELECT ci.cuil,c.fecha_ini
FROM cursos_instructores ci
INNER JOIN cursos c ON c.nom_plan = ci.nom_plan
INNER JOIN instructores ins ON ins.cuil = ci.cuil 
						 AND ci.nro_curso = c.nro_curso
WHERE (YEAR(fecha_ini) = '2014'  AND ci.nom_plan = "Marketing 1")
and ci.cuil not in

(SELECT cil.cuil
FROM cursos_instructores cil
INNER JOIN cursos ce ON ce.nom_plan = cil.nom_plan
INNER JOIN instructores inst ON inst.cuil = cil.cuil 
						 AND cil.nro_curso = ce.nro_curso
WHERE YEAR(ce.fecha_ini) = '2015'  AND cil.nom_plan = "Marketing 1");


-- 14) Alumnos que tengan todas sus cuotas pagas hasta la fecha.

select *
from alumnos a
where a.dni not in ( select a.dni
from alumnos a 
inner join cuotas c on a.dni=c.dni
where c.fecha_pago is null);


/*15) Alumnos cuyo promedio supere al del curso que realizan. Mostrar dni, nombre y apellido,
promedio y promedio del curso.*/

DROP TEMPORARY TABLE IF EXISTS prom_alum;
create temporary table prom_alum
select a.dni,e.nro_curso, avg(e.nota) alumnoprom
from alumnos a
inner join evaluaciones e on a.dni=e.dni
group by 1,2;


DROP TEMPORARY TABLE IF EXISTS prom_cu;
create temporary table prom_cu
select e.nro_curso, avg(e.nota) cursoprom
from evaluaciones e 
group by 1;

select a.dni,a.nombre,a.apellido,alumnoprom,cursoprom
from alumnos a
inner join evaluaciones e on a.dni=e.dni
inner join prom_alum p on a.dni=p.dni
inner join prom_cu pr on e.nro_curso=pr.nro_curso
where alumnoprom > cursoprom
group by 1,2,3;

/*16)Para conocer la disponibilidad de lugar en los cursos que empiezan en abril para
lanzar una campaña se desea conocer la cantidad de alumnos inscriptos a los cursos
que comienzan a partir del 1/04/2014 indicando: Plan de Capacitación, curso, fecha de
inicio, salón, cantidad de alumnos inscriptos y diferencia con el cupo de alumnos
registrado para el curso que tengan al más del 80% de lugares disponibles respecto del
cupo.*/

/*17) Indicar el último incremento de los valores de los planes de capacitación, consignando
nombre del plan fecha del valor actual, fecha el valor anterior, valor actual, valor anterior y
diferencia entre los valores. Si el curso tiene un único valor mostrar la fecha anterior en
NULL el valor anterior en 0 y la diferencia en 0.*/

/*PRACTICA 8*/
/*INSERT*/
/*1) Agregar el nuevo instructor Daniel Tapia con cuil: 44-44444444-4, teléfono: 444-444444,
email: dotapia@gmail.com, dirección Ayacucho 4444 y sin supervisor.*/

start transaction;
INSERT INTO instructores (`cuil`, `nombre`, `apellido`, `tel`, `email`, `direccion`) VALUES ('44-44444444-4', 'Daniela',
 'Tapia', '444-444444', 'dotapia@gmail.com', 'Ayacucho 4444');
 COMMIT;
 -- rollback;
 
 
/*2)*/

start transaction;
INSERT INTO `plan_capacitacion` (`nom_plan`, `desc_plan`, `hs`, `modalidad`) VALUES ('Administrador de BD',
 ' Instalación y configuración MySQL. Lenguaje', '300', 'Presencial');
 
 INSERT INTO `plan_temas` (`nom_plan`, `titulo`, `detalle`) VALUES ('Administrador de BD', '1- Instalación MySQL ', 'Distintas configuraciones de instalación');
INSERT INTO `plan_temas` (`nom_plan`, `titulo`, `detalle`) VALUES ('Administrador de BD', '2- Configuración DBMS', 'Variables de entorno, su uso y configuración');
INSERT INTO `plan_temas` (`nom_plan`, `titulo`, `detalle`) VALUES ('Administrador de BD', '3- Lenguaje SQL', 'DML, DDL y TCL');
INSERT INTO `plan_temas` (`nom_plan`, `titulo`, `detalle`) VALUES ('Administrador de BD', '4- Usuarios y Permisos ', 'Permisos de usuarios y DCL');

INSERT INTO `examenes` (`nom_plan`, `nro_examen`) VALUES ('Administrador de BD', '1');
INSERT INTO `examenes` (`nom_plan`, `nro_examen`) VALUES ('Administrador de BD', '2');
INSERT INTO `examenes` (`nom_plan`, `nro_examen`) VALUES ('Administrador de BD', '3');
INSERT INTO `examenes` (`nom_plan`, `nro_examen`) VALUES ('Administrador de BD', '4');

INSERT INTO `examenes_temas` (`nom_plan`, `titulo`, `nro_examen`) VALUES ('Administrador de BD', '1- Instalación MySQL', '1');
INSERT INTO `examenes_temas` (`nom_plan`, `titulo`, `nro_examen`) VALUES ('Administrador de BD', '2- Configuración DBMS', '2');
INSERT INTO `examenes_temas` (`nom_plan`, `titulo`, `nro_examen`) VALUES ('Administrador de BD', '3- Lenguaje SQL', '3');
INSERT INTO `examenes_temas` (`nom_plan`, `titulo`, `nro_examen`) VALUES ('Administrador de BD', '4- Usuarios y Permisos', '4');

INSERT INTO `materiales_plan` (`nom_plan`, `cod_material`) VALUES ('Administrador de BD', 'UT-001');
INSERT INTO `materiales_plan` (`nom_plan`, `cod_material`) VALUES ('Administrador de BD', 'UT-002');
INSERT INTO `materiales_plan` (`nom_plan`, `cod_material`) VALUES ('Administrador de BD', 'UT-003');
INSERT INTO `materiales_plan` (`nom_plan`, `cod_material`) VALUES ('Administrador de BD', 'UT-004');

INSERT INTO `valores_plan` (`nom_plan`, `fecha_desde_plan`, `valor_plan`) VALUES ('Administrador de BD', '2009-02-01', '150');

commit;


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
rollback;

/*1) Convertir a Daniel Tapia en el supervisor de Henri Amiel y Franz Kafka. Utilizar el cuil de
cada uno.*/

-- UPDATE `afatse`.`instructores` SET `cuil_supervisor` = '44-44444444-4' WHERE (`cuil` = '55-55555555-5');
-- UPDATE `afatse`.`instructores` SET `cuil_supervisor` = '44-44444444-4' WHERE (`cuil` = '66-66666666-6');

start transaction;
update instructores set cuil_supervisor=null
where cuil in ("55-55555555-5","66-66666666-6");
commit;


/*2) Ídem 1) pero utilizar variables para obtener el cuil de los 3 instructores.*/

start transaction;
select cuil into @inst_1
from instructores
where cuil="66-66666666-6";

select cuil into @inst_2
from instructores
where cuil="55-55555555-5";

select cuil into @supervisor
from instructores
where cuil="44-44444444-4";



update instructores set cuil_supervisor=@supervisor
where cuil in (@inst_1,@inst_2);
commit;



/*3) El alumno Victor Hugo se ha mudado. Actualizar su dirección a Italia 2323 y su teléfono
nuevo es 3232323.*/

start transaction;
update alumnos a set a.direccion="Italia 800" , a.tel="33664"
where a.nombre = "Victor" and a.apellido= "Hugo";
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

start transaction;
update instructores set cuil_supervisor=null
where cuil_supervisor="44-44444444-4";
delete from instructores i where i.nombre="Daniela" and i.apellido="Tapia";
commit;

/*7) Eliminar los inscriptos al curso de Marketing 3 curso numero 1*/

start transaction;
delete from inscripciones i where i.nom_plan="Marketing 3" and i.nro_curso=1;
commit;

/*8) Eliminar los instructores que tienen de supervisor a Elias Yanes (CUIL 99-99999999-9)*/

start transaction;
delete from instructores i where i.cuil_supervisor="99-99999999-9";
commit;

/*9) Ídem 11) pero usar una variable para obtener el CUIL de Elias Yanes.*/



start transaction;
select i.cuil into @cuil
from instructores i 
where i.nombre="Elias" and i.apellido="Yanes";
delete from instructores ins where ins.cuil_supervisor=@cuil;
commit;

/*10) Eliminar todos los apuntes que tengan como autora o coautora a Erica de Forifregoro*/

start transaction;
delete from materiales_plan where cod_material="AP-006";
delete from materiales where  autores like "%Erica de Forifregoro%";
commit;

-- INSERT SELECT
/*1) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/06/2009 con un 20 por ciento más que su último valor. Eliminar las filas agregadas.*/
/*2) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
01/08/2009, con la siguiente regla: Los cursos cuyo último valor sea menor a $90
aumentarlos en un 20% al resto aumentarlos un 12%.*/
/*3) Crear un nuevo plan: Marketing 1 Presen. Con los mismos datos que el plan
Marketing 1 pero con modalidad presencial. Este plan tendrá los mismos temas, exámenes
y materiales que Marketing 1 pero con un costo un 50% superior, para todos los períodos
de este año que ya estén definidos costos del plan.*/
/*-- UDATE con JOIN
4) Cambiar el supervisor de aquellos instructores que dictan Reparac PC Avanzada este año a
66-66666666-6 (Franz Kafka).*/
/*5) Cambiar el horario de los cursos de que dicta este año Franz Kafka (cuil ) desde las 16 hs.
Moverlos una hora más temprano.*/
-- DELETE con JOIN
/*6) Eliminar los exámenes donde el promedio general de las evaluaciones sea menor a 5.5.
Eliminar también los temas que sólo se evalúan en esos exámenes. Ayuda: Usar una tabla
temporal para determinar el/los exámenes que cumplan en las condiciones y utilizar dichas
tabla para los joins. Tener en cuenta las CF para poder eliminarlos.*/
/*7) Eliminar las inscripciones a los cursos de este año de los alumnos que adeuden cuotas
impagas del año pasado.*/


/*CREATE DEFINER=`root`@`localhost` FUNCTION `saludar`(nombre VARCHAR(50), apellido VARCHAR(50), email VARCHAR(100)) RETURNS varchar(150) CHARSET utf8
    DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(100);
    SET nombre_completo = CONCAT(nombre, ' ', apellido);
    IF email IS NOT NULL THEN
      RETURN CONCAT('Bienvenido ', nombre_completo);
    ELSE
      RETURN 'Aun no tenes Email';
    END IF;
  END*/
  
/*SELECT *,saludar(nombre,apellido,email)
FROM alumnos;*/

/*1) Crear un procedimiento almacenado llamado plan_lista_precios_actual que devuelva los
planes de capacitación indicando:
nom_plan modalidad valor_actual*/


call valor_act();

/*CREATE DEFINER=`root`@`localhost` PROCEDURE `valor_act`()
BEGIN
drop temporary table if exists valor_actual;
create temporary table valor_actual
select v.nom_plan,max(v.fecha_desde_plan) ult_fecha
from valores_plan v
group by 1 ;


select p.nom_plan,p.modalidad,vp.valor_plan
from plan_capacitacion p
inner join valor_actual v on p.nom_plan=v.nom_plan
inner join valores_plan vp on v.nom_plan=vp.nom_plan  and v.ult_fecha=vp.fecha_desde_plan;

drop temporary table if exists valor_actual;
END*/


/*2) Crear un procedimiento almacenado llamado plan_lista_precios_a_fecha que dada una
fecha devuelva los planes de capacitación indicando:
nombre_plan modalidad valor_a_fecha*/

-- call valor_a_fecha(20130601);
/*CREATE DEFINER=`root`@`localhost` PROCEDURE `valor_a_fecha`(in fecha_ingreso date)
BEGIN
drop temporary table if exists valor_fe;
create temporary table valor_fe
select v.nom_plan,max(v.fecha_desde_plan) ult_fecha
from valores_plan v
where v.fecha_desde_plan <= fecha_ingreso
group by 1 ;
 

select p.nom_plan,p.modalidad,vp.valor_plan
from plan_capacitacion p
inner join valor_fe v on p.nom_plan=v.nom_plan
inner join valores_plan vp on v.nom_plan=vp.nom_plan  and v.ult_fecha=vp.fecha_desde_plan;
END*/


/*3) Modificar el procedimiento almacenado creado en 1) para que internamente invoque al
procedimiento creado en 2).*/

/*CREATE DEFINER=`root`@`localhost` PROCEDURE `invoca_otro`()
BEGIN
call plan_lista_precios_a_fech(CURRENT_DATE);
END*/

-- call invoca_otro();

/*4) Crear una función llamada plan_valor que reciba el nombre del plan y una fecha y devuelva
el valor de dicho plan a esa fecha.*/

-- call plan_valor("Marketing 1",20140401);
/*CREATE DEFINER=`root`@`localhost` FUNCTION `plan_valor`(nombre varchar(20),fecha date) RETURNS int
    DETERMINISTIC
BEGIN
select v.valor_plan into @valor
from valores_plan v
where v.nom_plan= nombre and v.fecha_desde_plan=fecha;
RETURN @valor;
END*/

/*5) Modifique el procedimiento almacenado creado en 2) para que internamente utilice la
función creada en 4).*/

/*6) Crear un procedimiento almacenado llamado alumnos_pagos_deudas_a_fecha que dada
una fecha y un alumno indique cuanto ha pagado hasta esa fecha y cuantas cuotas
adeudaba a dicha fecha (cuotas emitidas y no pagadas). Devolver los resultados en
parámetros de salida.*/


/*CREATE PROCEDURE `alumnos_pagos_deudas_a_fecha`(IN fecha_limite DATE, IN dni_alumno 
INTEGER(11), OUT pagado FLOAT(9,3), OUT cant_adeudado INTEGER(11))
BEGIN
select @pagado:=sum(cuo.`importe_pagado`)
from cuotas cuo
where cuo.dni=dni_alumno and cuo.`fecha_pago` is not null
 and cuo.`fecha_emision`<=fecha_limite;
select @cant_adeudado:=count(*)
from cuotas cuo
where cuo.dni=dni_alumno and cuo.`fecha_pago` is null
 and cuo.`fecha_emision`<=fecha_limite;
set pagado:=@pagado;
set cant_adeudado:=@cant_adeudado;
END;*/


set @t=0;
set @d=0;
call alumnos_pagos_deudas_a_fecha("20190401",24242424,@t,@d);
select @t,@d;



/*7) Crear una función llamada alumnos_deudas_a_fecha que dado un alumno y una fecha
indique cuantas cuotas adeuda a la fecha.*/

call alumnos_deudas_a_fecha(current_date(),24242424);
select alumnos_deudas_a_fecha(current_date(),'24242424');

/*select count(*) 
from cuotas cuo
where cuo.dni=24242424 and cuo.fecha_pago is null and cuo.fecha_emision<=current_date();*/

/*8) Crear un procedimiento almacenado llamado alumno_inscripcion que dados los datos de
un alumno y un curso lo inscriba en dicho curso el día de hoy y genere la primera cuota con
fecha de emisión hoy para el mes próximo.*/

call alumno_inscripcion(24242424,"Marketing 4",3);

/*9) Modificar el procedimiento almacenado creado en 8) para que antes de inscribir a un
alumno valide que el mismo no esté ya inscripto.*/
/*10) Modificar el procedimiento almacenado editado en 9) para que realice el proceso en una
transacción. Además luego de inscribirlo y generar la cuota verificar si la cantidad de
inscriptos supera el cupo, en ese caso realizar un ROLLBACK. Si la cantidad de inscriptos es
correcta ejecutar un COMMIT*/


/*Práctica Nº 13: TRIGGERS
Práctica en Clase: 1 – 2 – 3 – 4
1)
a) Crear una tabla para registrar el histórico de cambios en los datos de los alumnos con
el siguiente script:*/

CREATE TABLE `alumnos_historico` (
 `dni` int(11) NOT NULL,
 `fecha_hora_cambio` datetime NOT NULL,
 `nombre` varchar(20) default NULL,
 `apellido` varchar(20) default NULL,
 `tel` varchar(20) default NULL,
 `email` varchar(50) default NULL,
 `direccion` varchar(50) default NULL,
 `usuario_modificacion` varchar(50) default NULL,
 PRIMARY KEY (`dni`,`fecha_hora_cambio`),
 CONSTRAINT `alumnos_historico_alumnos_fk` FOREIGN KEY (`dni`) REFERENCES
`alumnos` (`dni`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Luego crear TRIGGERS para insertar los nuevos valores en archivo_historico cuando los
alumnos sean ingresados o sus datos sean modificados. Registrar la fecha y hora actual
con CURRENT_TIMESTAMP y el usuario actual con CURRENT_USER.8*/

CREATE TRIGGER `alumnos_before_ins_tr` AFTER INSERT ON `alumnos`
 FOR EACH ROW
 insert into alumnos_historico
 values (new.dni,CURRENT_TIMESTAMP,new.nombre,new.apellido,
 new.tel,new.email,new.direccion,CURRENT_USER);








 


