/*Categorización de Clientes.
Se agregan al modelo las siguientes reglas de negocio:
- Los clientes pueden tener una categoría asignada. Inicialmente un cliente puede no tener categoría.
- Las categorías están codificadas y tienen una descripción. Las categorías iniciales serán:
1.  Cliente Frecuente
2. Cliente Poco Frecuente
Para asignarle una categoría inicial los clientes con más de dos pedidos tendrán categoría categoría 2 (Poco Frecuente), los clientes con más de cinco pedidos tendrán categoría 1 (Frecuente) y el resto no tendrán categoría.
Realice todos los cambios necesarios para cumplir con los requerimientos indicados*/

CREATE TABLE `categoria_cliente` (
  `cod_categoria` int NOT NULL AUTO_INCREMENT,
  `descripcion_categoria` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`cod_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `saco_roto`.`categoria_cliente` (`descripcion_categoria`) VALUES ('Cliente Frecuente');
INSERT INTO `saco_roto`.`categoria_cliente` (`descripcion_categoria`) VALUES ('Cliente Poco Frecuente');

ALTER TABLE `saco_roto`.`personas` 
ADD COLUMN `cod_categoria` VARCHAR(45) NULL AFTER `email`;

ALTER TABLE `saco_roto`.`personas` 
ADD INDEX `fk_codcat_idx` (`cod_categoria` ASC) VISIBLE;
;
ALTER TABLE `saco_roto`.`personas` 
ADD CONSTRAINT `fk_codcat`
  FOREIGN KEY (`cod_categoria`)
  REFERENCES `saco_roto`.`categoria_cliente` (`cod_categoria`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
start transaction;

select c.cod_categoria into @valor11
from categoria_cliente c
where c.descripcion_categoria="Cliente Frecuente";

select c.cod_categoria into @valor22
from categoria_cliente c
where c.descripcion_categoria="Cliente Poco Frecuente";

create temporary table tabla22
select p.nro_persona, count(ped.nro_pedido) cantidad
  from personas p 
  left join pedidos ped on p.nro_persona=ped.nro_persona_cliente
  group by 1;

update personas p 
inner join tabla22 t on p.nro_persona=t.nro_persona
set p.cod_categoria=@valor22
where t.cantidad between 2 and 5;

update personas p 
inner join tabla22 t on p.nro_persona=t.nro_persona
set p.cod_categoria=@valor11
where t.cantidad > 5;

drop temporary table tabla22 ;


/*  1
Listar los clientes que realizaron menos de 2 pedidos. 
 Indicar nro. de cliente, apellido y nombre del clientes   y cantidad de pedidos realizados.*/
 
select p.nro_persona,p.apellido,p.nombre, count(ped.nro_pedido) cantidad
  from personas p 
  left join pedidos ped on p.nro_persona=ped.nro_persona_cliente
  group by 1
  having cantidad<2;


/* 2

Ranking de pedido de prendas por personas y tipo de prendas

Listar las personas y tipos de prenda donde la cantidad total pedida sea igual o supere a dos.
Indicar Nro, Apellido y Nombre de la persona, descripción del tipo de prenda y cantidad total pedida.
 Ordenar el listado en forma descendente por cantidad total pedida, y en forma ascendente por Apellido 
y Nombre de la persona y descripción del tipo de prenda.*/

select p.nro_persona,p.apellido,p.nombre,t.desc_tipo_prenda,sum(pr.cantidad) cantidad
  from personas p 
  inner join prendas pr on p.nro_persona=pr.nro_persona
  inner join tipos_prendas t on pr.cod_tipo_prenda=t.cod_tipo_prenda
  group by 1,2,3,4
  having cantidad >=2
  order by cantidad desc , 1,2,3,4 asc;

/* 3

Los jefes de sastres supervisan los pedidos de las prendas que confeccionan los sastres que tienen a cargo.

Se necesita realizar un control que indique cuál ha sido la última fecha de pedido para cada jefe de sastre en la que han participado
 sus sastres a cargo y qué cantidad de pedidos se han solicitado en esa fecha.
Mostrar: Datos del Jefe, última fecha de pedido y cantidad de pedidos solicitados en la fecha*/

create temporary table jefes2
select s.cuil,s.nombre,s.apellido
from sastres s
where cuil_jefe is null;

select j.cuil,j.nombre,j.apellido,max(fecha_hora_pedido)'Maxima fecha',count(*)'cantidad pedida'
from prendas p
inner join prendas_sastres ps on ps.nro_persona=p.nro_persona and ps.cod_tipo_prenda=p.cod_tipo_prenda and ps.nro_pedido=p.nro_pedido
inner join sastres s on ps.cuil=s.cuil
inner join jefes2 j on s.cuil_jefe=j.cuil
inner join pedidos ped on p.nro_pedido=ped.nro_pedido
group by 1,2,3;

/* 4

Modificación de fecha de entrega por corte de energía eléctrica:

Por un corte de energía eléctrica se originó un atraso en la fecha de entrega de las prendas.
Por ese motivo se decidió cambiar la fecha de entrega de las prendas que debían entregarse el día 2013-11-29. 
La entrega de la/las mismas se retrasa 4 días. Realice las actualizaciones correspondientes.
NOTA: Función a utilizar: ADDDATE*/

start transaction;
update prendas p
set p.fecha_entrega=adddate(p.fecha_entrega,4)
where p.fecha_entrega='2013-11-29';
commit;

/* 5

Se requiere desarrollar un procedimiento que dado un año realice un listado de las personas que han realizado pruebas en dicho año y no en el año siguiente.
El procedimiento debe mostrar datos de las personas.

Realice la prueba del procedimiento para el año 2013.*/

select p.nombre,p.apellido,p.nro_persona
from pruebas pr
inner join personas p on pr.nro_persona=p.nro_persona
where year(fecha_prueba)='2013' and p.nro_persona not in (select p.nro_persona
from pruebas pr
inner join personas p on pr.nro_persona=p.nro_persona
where year(fecha_prueba)='2014')
group by 1,2,3;





