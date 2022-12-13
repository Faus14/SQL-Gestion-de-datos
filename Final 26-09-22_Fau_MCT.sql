/*MCT --> 26/09/2022 */
/* 1
Realice todos los cambios necesarios (agregado de tablas, para modificar el modelo relacional propuesto de modo que responda a los siguientes cambios de requerimientos:
Se desea asignar a los choferes una categoría. Crear una entidad categoría con un código numérico secuencial que la identifique y un nombre. Las categorías a registrar son: Senior y Junior
Modificar la tabla choferes para registrar la categoría correspondiente en referencia a la nueva tabla.
Categorizar los choferes de la siguiente forma:
Si ha realizado más viajes que la cantidad de viajes programados que el promedio por chofer debe ser “Senior”
Caso contrario debe ser registrado como “Junior”*/

CREATE TABLE `manolo_carpa_tigre`.`choferes_categoria` (
  `cod_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre_cat` VARCHAR(45) NULL,
  PRIMARY KEY (`cod_categoria`));

INSERT INTO `manolo_carpa_tigre`.`choferes_categoria` (`nombre_cat`) VALUES ('senior');
INSERT INTO `manolo_carpa_tigre`.`choferes_categoria` (`nombre_cat`) VALUES ('junior');

ALTER TABLE `manolo_carpa_tigre`.`choferes` 
ADD COLUMN `cod_categoria` INT NULL AFTER `email`;

start transaction;
select avg(v.nro_viaje) into @prom
from viajes v
inner join viajes_choferes vc on v.nro_viaje=vc.nro_viaje
inner join choferes c on vc.cuil=c.cuil;

create temporary table table1
select c.cuil,count(vc.cuil) contador
from choferes c
inner join viajes_choferes vc on c.cuil=vc.cuil
inner join viajes v on vc.nro_viaje=v.nro_viaje
group by 1
having contador>@prom;

create temporary table table2
select c.cuil,count(vc.cuil) contador
from choferes c
inner join viajes_choferes vc on c.cuil=vc.cuil
inner join viajes v on vc.nro_viaje=v.nro_viaje
group by 1
having contador<=@prom;

update choferes c
inner join table1 t on c.cuil=t.cuil
set c.cod_categoria=1;

update choferes c
inner join table2 t on c.cuil=t.cuil
set c.cod_categoria=2;
commit;

ALTER TABLE `manolo_carpa_tigre`.`choferes` 
ADD INDEX `fk_categoria_idx` (`cod_categoria` ASC) VISIBLE;
;
ALTER TABLE `manolo_carpa_tigre`.`choferes` 
ADD CONSTRAINT `fk_categoria`
  FOREIGN KEY (`cod_categoria`)
  REFERENCES `manolo_carpa_tigre`.`choferes_categoria` (`cod_categoria`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
/* 2
LISTADO DE VIAJES CASUALES DEL ÚLTIMO TURNO DE CADA CHOFER

Listar los choferes indicando para su último turno los viajes casuales que hicieron. 
Mostrar cuil, nombre y apellido del chofer, número de viaje, fecha y hora de inicio e importe. 
En caso de no haber realizado viajes en su último turno mostrar “No realizó viajes” en los datos faltantes. 
Ordenar por Apellido y Nombre alfabéticamente.
Observación: un viaje casual tiene número de contrato nulo*/

create temporary table chof1
select ct.cuil,ct.cod_turno,max(ct.fecha_turno)fe
from choferes_turnos ct
group by 1;

select chof.cuil,chof.nom_ape,ifnull(v.nro_viaje,'No realizó viajes'),ifnull(v.fecha_ini,'No realizó viajes'),ifnull(v.hora_ini,'No realizó viajes'),v.importe
from choferes_turnos c
inner join chof1 ct on c.cuil=ct.cuil and c.fecha_turno=ct.fe and c.cod_turno=ct.cod_turno
inner join choferes chof on c.cuil=chof.cuil 
left join viajes v on ct.cuil=v.cuil and v.cuil=c.cuil and v.cuil=chof.cuil and c.cod_turno=v.cod_turno and c.fecha_turno=v.fecha_turno
order by chof.nom_ape;


/* 3
RANKING DE KM RECORRIDOS POR LOS MÓVILES CON MENOR KM
Listar los móviles que han recorrido menos KM en total en viajes que el promedio de KM en total de todos los móviles. 
Indicar patente, capacidad, fecha del último service y capacidad. 
Se deben incluir aquellos móviles que no han realizado viajes también. 
Ordenar por KM totales recorridos en viajes descendente y fecha de último service ascendente.*/

select avg(km_fin-km_ini) into @prom
from moviles m
inner join viajes_moviles vm on m.patente=vm.patente
inner join viajes v on vm.nro_viaje=v.nro_viaje;

select m.patente,m.capacidad,ifnull(m.fecha_ult_service,''),sum(km_fin-km_ini) suma
from moviles m
left join viajes_moviles vm on m.patente=vm.patente
left join viajes v on vm.nro_viaje=v.nro_viaje
group by 1,2,3
having  suma<@prom
order by suma desc , m.fecha_ult_service asc ;


/* 4
MOVILES ACTIVOS - CANTIDAD DE VIAJES REALIZADOS y KM RECORRIDOS
Para cada móvil que no esté dado de baja informar cuántos viajes (no cancelados) ha hecho y 
cuántos KM ha recorrido en ellos desde la fecha del último service. Indicando patente, capacidad, fecha del último service,
KM recorridos, cantidad de viajes. Ordenar por KM recorridos descendientes y fecha de último viaje ascendente.*/
 
 
select m.patente,m.capacidad,max(m.fecha_ult_service),sum(km_fin-km_ini)cantidad_km,count(v.nro_viaje)
from moviles m
inner join viajes_moviles vm on m.patente=vm.patente
inner join viajes v on vm.nro_viaje=v.nro_viaje
where m.fecha_baja is null
group by 1,2
order by cantidad_km desc ,max(m.fecha_ult_service) asc ;


/* 5
FUNCION: KM RECORRIDOS
Crear la función kms_recorridos que reciba de parámetros la patente de un móvil, una fecha desde 
y una fecha hasta y en función de la fecha de inicio del viaje devuelva los KM recorridos reales del móvil entre esas fechas. 
En caso de no haber realizado viajes la función debe retornar 0. 
Luego listar todos los móviles y utilizando dicha función indicar los kilómetros recorridos por cada móvil 
desde inicios de 2018 hasta junio de 2018 inclusive.*/

USE `manolo_carpa_tigre`;
DROP function IF EXISTS `manolo_carpa_tigre`.`kms_recorridos`;
DELIMITER $$
CREATE FUNCTION `kms_recorridos`(pat varchar(7), fecha_desde date, fecha_hasta date )
RETURNS int READS SQL DATA
BEGIN
declare km_rec decimal(9,3);
select coalesce(sum(vm.km_fnvm.km_ini),0) into km_rec
from viajes via
inner join viajes_moviles vm
on via.nro_viaje=vm.nro_viaje
where patente=pat
and via.fecha_ini between fecha_desde and fecha_hasta;
return km_rec;
END$$
DELIMITER ;

select kms_recorridos(m.patente, '20130101', '20131231'), m.*
from moviles m;


/* 6
Se ha decidido simplificar los tipos de viajes y dejar solo 3 tipos de viaje: 
“Corta Distancia” (hasta 50 KM)
“Media Distancia” (más de 50 KM, hasta 1000 KM)
“Larga Distancia” (más de 1000KM)”. 

También se notó que muchos viajes no tienen asignado un tipo, situación que debe corregirse cargando
los tipos de viaje en los viajes que no lo tienen aún de manera automática según los KM estimados.

Realizar una transacción para reflejar los siguientes cambios: 
Cambiar el tipo de viaje de los viajes: “Urbanos” a “Corta Distancia” y “Nacional (hasta 1000 km)” a “Media distancia”.
Renombrar el tipo de viaje “Nacional (más de 1000 km)” a “Larga Distancia”
Para aquellos viajes sin tipo de viaje asignar el tipo correspondiente según los KM estimados del viaje.*/

begin;
select cod_tipo_viaje into @urb from tipos_viajes where desc_tipo_viaje='Urbano';
select cod_tipo_viaje into @cd from tipos_viajes where desc_tipo_viaje='Corta Distancia';
select cod_tipo_viaje into @md from tipos_viajes where desc_tipo_viaje='Media Distancia';
select cod_tipo_viaje into @nacCorto from tipos_viajes where desc_tipo_viaje='Nacional(hasta 1000 km)';

update viajes set cod_tipo_viaje=@cd where cod_tipo_viaje=@urb;
update viajes set cod_tipo_viaje=@nacCorto where cod_tipo_viaje=@md;
update tipos_viajes set desc_tipo_viaje='Larga Distancia' where desc_tipo_viaje='Nacional(más de 1000 km)';

update viajes set cod_tipo_viaje=@cd
where cod_tipo_viaje is null
and km_estimados< 50;

update viajes set cod_tipo_viaje=@md
where cod_tipo_viaje is null
and km_estimados between 50 and 1000;

update viajes set cod_tipo_viaje=@ld
where cod_tipo_viaje is null
and km_estimados>1000;

commit;






