/*MCT
DDL:
1. (Evaluación: Esta consigna es eliminatoria). Desarrolle las sentencias DDL requeridas para completar 
la definición de las tablas CHOFERES_TURNOS y VIAJES*/

ALTER TABLE `manolo_carpa_tigre`.`choferes_turnos` 
ADD PRIMARY KEY (`cuil`, `cod_turno`, `fecha_turno`),
ADD INDEX `fk_turn_idx` (`cod_turno` ASC) VISIBLE;
;
ALTER TABLE `manolo_carpa_tigre`.`choferes_turnos` 
ADD CONSTRAINT `fk_cuil`
  FOREIGN KEY (`cuil`)
  REFERENCES `manolo_carpa_tigre`.`choferes` (`cuil`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_turn`
  FOREIGN KEY (`cod_turno`)
  REFERENCES `manolo_carpa_tigre`.`turnos` (`cod_turno`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE `manolo_carpa_tigre`.`viajes` 
ADD INDEX `fk_tipovia_idx` (`cod_tipo_viaje` ASC) VISIBLE,
ADD INDEX `fk_contrato_idx` (`nro_contrato` ASC) VISIBLE,
ADD INDEX `fk_chof_turn_idx` (`cuil` ASC, `cod_turno` ASC, `fecha_turno` ASC) VISIBLE;
;
ALTER TABLE `manolo_carpa_tigre`.`viajes` 
ADD CONSTRAINT `fk_tipovia`
  FOREIGN KEY (`cod_tipo_viaje`)
  REFERENCES `manolo_carpa_tigre`.`tipos_viajes` (`cod_tipo_viaje`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_contrato`
  FOREIGN KEY (`nro_contrato`)
  REFERENCES `manolo_carpa_tigre`.`contratos` (`nro_contrato`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_chof_turn`
  FOREIGN KEY (`cuil` , `cod_turno` , `fecha_turno`)
  REFERENCES `manolo_carpa_tigre`.`choferes_turnos` (`cuil` , `cod_turno` , `fecha_turno`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

/*DML:
2. Ranking de móviles. Indicar: Patente, cantidad de kilómetros recorridos en todos los viajes que realizó el 
móvil. Ordenar por cantidad de kilómetros recorridos en forma descendente.*/

select m.patente,sum(v.km_fin-v.km_ini) Km_recorridos
from moviles m
inner join viajes_moviles v on m.patente=v.patente
group by 1
order by Km_recorridos desc ;

/*3. Lista de precios. Indicar código del tipo de viaje, descripción y valor actual. Si el tipo de viaje aún no 
tiene ningún precio registrado, mostrar igual el tipo de viaje indicando esta situación.*/

create temporary table precio_Act1
select tv.cod_tipo_viaje,max(tv.fecha_desde) fecha
from tipos_viajes_valores tv
group by 1;

select t.cod_tipo_viaje,t.desc_tipo_viaje,tv.fecha_desde,tv.valor_km
from tipos_viajes t
left join precio_Act1 p on t.cod_tipo_viaje=p.cod_tipo_viaje
left join tipos_viajes_valores tv on p.cod_tipo_viaje=tv.cod_tipo_viaje and p.fecha=tv.fecha_desde;


/*4. Importes adeudados: Listar los clientes que adeudan cuotas indicando: tipo y nro. de documento, 
nombre, teléfono, cantidad de cuotas vencidas, importe total adeudado e importe total de recargo al día 
de hoy.
Recordar que las cuotas vencidas tienen un importe de recargo que se calcula: Recargo = cantidad de 
días de mora * porcentaje de recargo vigente * importe de la cuota / 100.
Cantidad de días de mora = fecha actual – fecha vencimiento (Función DATEDIFF)*/

select r.PorcRecargoDiario INTO @recargo 
FROM recargos r 
WHERE r.FechaDesde = (select max(r1.fechadesde) FROM recargos r1);

select c.tipo_doc, c.nro_doc, c.denominacion, c.telefono,sum(cu.importe) 'importe deudor',count(*)'cantidad sin pagar'
, sum(@recargo * (datediff (current_date(),cu.fecha_venc)) *cu.importe/100  )"recargo"
from clientes c
inner join contratos con on c.nro_doc=con.nro_doc and c.tipo_doc=con.tipo_doc
inner join viajes v on con.nro_contrato=v.nro_contrato
inner join cuotas cu on v.nro_viaje=cu.nro_viaje
where fecha_pago is null
group by 1,2,3,4;


/*5. Disponibilidad de móviles: realizar un procedimiento almacenado que analice la disponibilidad de 
móviles con una cierta capacidad o más (parámetro de entrada) para realizar un viaje casual. El 
procedimiento deberá listar Patente y capacidad de los móviles disponibles. 
 Probar el procedimiento para la capacidad: 20*/
 
 DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Dispon_móviles`(in cap int)
BEGIN
 select * 
 from moviles m
 where m.fecha_baja is null
 and m.patente not in  (select vm.patente
                         from viajes v
                           inner join viajes_moviles vm on v.nro_viaje=vm.nro_viaje
                              where v.estado in ('En Proceso','Pendiente','Cancelado') )
and m.capacidad>= cap;
END$$
DELIMITER ;

 call Dispon_móviles(20);
 
 
/*TCL:
6. Actualización de precios: Debido a un aumento en los combustibles la empresa ha decidido un aumento 
de precios para el valor por km de los tipos de viajes. El aumento regirá a partir del lunes próximo. El 
aumento será de un 25% a los que tengan un importe menor a $100 y de 30% a los que tengan un 
importe mayor o igual a $100.*/ 

start transaction;
drop temporary table max_f;
create temporary table max_f
SELECT t.cod_tipo_viaje,max(t.fecha_desde) fec
FROM tipos_viajes_valores t
group by 1;

insert into tipos_viajes_valores 
select tv.cod_tipo_viaje,'2022-07-09',tv.valor_km *1.30
from tipos_viajes_valores tv
inner join max_f m on tv.cod_tipo_viaje=m.cod_tipo_viaje and tv.fecha_desde=m.fec
where tv.valor_km >=100;

insert into tipos_viajes_valores 
select tv.cod_tipo_viaje,'2022-07-09',tv.valor_km *1.25
from tipos_viajes_valores tv
inner join max_f m on tv.cod_tipo_viaje=m.cod_tipo_viaje and tv.fecha_desde=m.fec
where tv.valor_km < 100;
drop temporary table max_f;
commit;