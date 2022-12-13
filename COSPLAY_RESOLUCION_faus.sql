/*Crear unidad_medida.

Se ha decidido realizar un mejor control de los materiales, para ello se deberá crear la entidad unidad_medida
identificada por un código y debe contener una descripción.
Los valores de dicha tabla deberán cargarse a partir de las unidades de medidas que se encuentran actualmente en la
tabla material. El código debe ser generado automáticamente y el atributo unidad_medida de la tabla material se utilizara
para la lista de elementos tomándolos como descripción. Desarrolle las sentencias DDL requeridas para
1. crear la tabla unidad_medida
2. migrar los datos de material a unidad_medida
3. cambiar la columna material.unidad_medida por una clave foránea a unidad medida:
codigo_unidad_medida
4. eliminar la columna original unidad_medida de la tabla material.*/

CREATE TABLE `cosplay`.`unidad_medida` (
  `cod_unidad` INT NOT NULL AUTO_INCREMENT,
  `descripcion_unidad` VARCHAR(45) NULL,
  PRIMARY KEY (`cod_unidad`));
  
  insert into unidad_medida (descripcion_unidad)
  select distinct m.unidad_medida
  from material m;
  
  ALTER TABLE `cosplay`.`material` 
ADD COLUMN `cod_unidad` INT NULL AFTER `tipo`;

ALTER TABLE `cosplay`.`material` 
ADD INDEX `fk_unidad_m_idx` (`cod_unidad` ASC) VISIBLE;
;
ALTER TABLE `cosplay`.`material` 
ADD CONSTRAINT `fk_unidad_m`
  FOREIGN KEY (`cod_unidad`)
  REFERENCES `cosplay`.`unidad_medida` (`cod_unidad`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `cosplay`.`material` 
DROP COLUMN `unidad_medida`;


/*Listado de trabajos por artesano de 2018.

Indicar para cada artesano los trabajos de 2018 donde participó. Indicar legajo, nombre y apellido del artesano, nombre y
nro. de cliente, número de trabajo y fecha de pedido.
Ordenar por fecha de pedido y por legajo.*/

select e.legajo,e.nombre,e.apellido,c.nombre,c.nro,t.nro,t.fecha_pedido
from empleado e
inner join ejecucion_tarea et on e.legajo=et.legajo_artesano
inner join trabajo t on et.nro_trabajo=t.nro
inner join cliente c on t.nro_cliente=c.nro
where e.tipo='artesano' and year(t.fecha_pedido) = 2018;

/*Lista de tareas y artesanos.
Indicar todas las tareas y los artesanos asignados a ellas.
Indicar nro de trabajo, nro de ítem, descripción del tipo de elemento, descripción del tipo de tarea, fecha y hora de inicio
de la tarea, legajo, nombre y apellido del artesano asignado y horas trabajadas.
En caso de no tener uno asignado o no haber registrado horas deberá mostrar los datos de la tarea indicando no
asignado en los datos del artesano. Ordenar descendente por cantidad de horas trabajadas.*/

select t.nro_trabajo,t.nro_item,tt.descripcion,t.fecha_hora_inicio,em.legajo,em.nombre,em.apellido,sum(e.hs_trabajadas_reales)
from tarea t
inner join tipo_tarea tt on t.codigo_tipo_tarea=tt.codigo
inner join ejecucion_tarea e on t.nro_trabajo=e.nro_trabajo and t.nro_item=e.nro_item and t.codigo_tipo_tarea=e.codigo_tipo_tarea
inner join empleado em on e.legajo_artesano=em.legajo
where em.tipo='artesano'
group by 5;



/*Ranking de clientes.
Indicar: Número de cliente, cuil/cuit, nombre, email, cantidad de trabajos encargados y sumatoria de importes
presupuestados.
Ordenar sumatoria de importes en forma descendente y por cantidad de trabajos en forma ascendente.*/

select c.nro,c.cui,c.nombre,c.email,count(*)"cantidad de trabajos",sum(t.importe_presup)'sumatoria'
from cliente c
inner join trabajo t on c.nro=t.nro_cliente
group by 1,2,3,4;

/*Artesanos excediendo el máximo de horas al mes:
Realizar un procedimiento almacenado que calcule las horas trabajadas reales totales por artesano en el mes (usando la
fecha de inicio) y liste aquellos que exceden el máximo de horas que deberían haber trabajado en el mes.

El procedimiento almacenado debe recibir como parámetros el mes, el año y el máximo de horas. Debe listar los
artesanos indicando legajo, cuil, nombre, apellido, descripción de la especialidad, cantidad total de horas trabajadas y
horas excedidas. Al finalizar invocar el procedimiento. Para realizar pruebas usar Octubre de 2018 y 10 hs*/

select e.legajo,e.cuil,e.nombre,e.apellido,es.descripcion,sum(et.hs_trabajadas_reales),tar.fecha_hora_inicio
from empleado e
inner join artesano_especialidad a on e.legajo=a.legajo_artesano
inner join especialidad es on a.codigo_especialidad=es.codigo
inner join ejecucion_tarea et on e.legajo=et.legajo_artesano
inner join tarea tar on et.nro_trabajo=tar.nro_trabajo and et.nro_item=tar.nro_item and et.codigo_tipo_tarea=tar.codigo_tipo_tarea
where e.tipo='artesano' and year(tar.fecha_hora_inicio)=2018 and month(tar.fecha_hora_inicio)=10
group by 1,2,3,4,5
having sum(et.hs_trabajadas_reales)>10;

call exc(10,2018,10)

  