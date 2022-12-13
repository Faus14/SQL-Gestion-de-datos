/*   DDL:
1. (Esta consigna es eliminatoria). Desarrolle las sentencias DDL requeridas para completar la 
definición de la tabla CONTRATA 
Copie el DDL que se obtiene con la herramienta al archivo a entregar.  */

ALTER TABLE `va_alquileres`.`contrata` 
;
ALTER TABLE `va_alquileres`.`contrata` ALTER INDEX `fk_serv_idx` VISIBLE;
ALTER TABLE `va_alquileres`.`contrata` 
ADD CONSTRAINT `fk_serv`
  FOREIGN KEY (`CodServicio`)
  REFERENCES `va_alquileres`.`servicios` (`CodServicio`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_int_eve`
  FOREIGN KEY (`NroEvento` , `CodInstalacion` , `fechadesde` , `horadesde`)
  REFERENCES `va_alquileres`.`instalaciones_eventos` (`NroEvento` , `CodInstalacion` , `fechadesde` , `horadesde`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `va_alquileres`.`contrata` 
ADD INDEX `fk_emp_idx` (`cuil` ASC) VISIBLE;
;
ALTER TABLE `va_alquileres`.`contrata` 
ADD CONSTRAINT `fk_emp`
  FOREIGN KEY (`cuil`)
  REFERENCES `va_alquileres`.`empleados` (`cuil`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  

/* DML: 
2. Indicar por empleado la cantidad de eventos que tuvo como coordinador. Mostrar CUIL, apellido, nombres y 
cantidad de eventos. Aquellos empleados que no fueron coordinadores en ningún evento indicar 0. */

select em.cuil,em.nombre,em.apellido,count(ev.CuilEmpleado)"cantidad eventos"
from empleados em
left join eventos  ev on em.cuil=ev.CuilEmpleado
group by 1,2,3;

/* 3. Ranking de servicios contratados indicando: datos del servicio, suma de la cantidad del servicio contratado 
para todos los eventos y porcentaje de esta suma sobre la suma total de las cantidades de servicios 
contratados. Los servicios que no hayan sido contratados deberán figurar en la lista con cantidad total 0. 
Ordenar el ranking en forma descendente por porcentaje. */

select sum(c.cantidad) into @tot
from contrata c ;

select s.CodServicio,s.DescServicio,sum(c.cantidad)cant_Serv, ((sum(c.cantidad)/ @tot)* 100 )Promedio
from servicios s
inner join contrata c on s.CodServicio=c.CodServicio
group by 1,2;

/* 4. Calcular el total a pagar del Evento 5. El total debe incluir: la suma de los valores pactados por las 
instalaciones más la suma de los totales de servicios contratados. NOTA: el total de un servicio se calcula 
como la cantidad del servicio contratada por el valor del servicio a la fecha del contrato del evento. */

select SUM(ie.valorpactado) INTO @vinstala
FROM instalaciones_eventos ie
WHERE ie.NroEvento = 5;

select ev.fechacontrato into @vfechacontrato
FROM eventos ev
WHERE ev.NroEvento = 5;

select SUM(c.cantidad * vs.valor) 
from  contrata c
INNER JOIN valores_servicios vs
ON vs.CodServicio = c.CodServicio
AND vs.fechadesde = (SELECT MAX(vsf.fechadesde)
						 FROM valores_servicios vsf
						 WHERE vsf.CodServicio = vs.CodServicio
                           AND vsf.fechadesde <= @vfechacontrato)
WHERE c.NroEvento = 5;

SELECT @vinstala + @vservicios;

/*5. STORE PROCEDURE (SP): Desarrollar un SP que dada una nueva descripción de un tipo de evento lo registre 
en la tabla correspondiente manteniendo la correlatividad de los códigos de tipos de evento */

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `nuevo_t_evento`(in descripcion varchar(20))
BEGIN

select max(t.CodTipoEvento) into @ultimo
from tipos_evento t;

insert into  tipos_evento  
value (@ultimo+1,descripcion);

END$$
DELIMITER ;

call  nuevo_t_evento('Fiesta pop');


/*TCL 
 6. Registrar los nuevos valores de servicios para la fecha de hoy en función de su valor anterior más un 20%.*/

start transaction;
create temporary table max_fe
select v.CodServicio,max(v.fechadesde) fecha
from valores_servicios v
group by 1;

insert into valores_servicios 
select v.CodServicio,'2022-09-03',v.valor*1.20
from valores_servicios v
inner join max_fe f on v.CodServicio=f.CodServicio and v.fechadesde=f.fecha;
commit;


