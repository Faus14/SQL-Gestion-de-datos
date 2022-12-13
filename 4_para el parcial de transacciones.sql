
/*305-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
 Se ha decidido cambiar la composición de la “ensalada burgol”, se retirarán los materiales “sal” y “aceite oliva agroecol” y
 se agregará 0.5 de un nuevo material que debe ser dado de alta con los siguientes datos,
nombre: “arroz negro”, unidad de medida: kg y stock: 10. **/

start transaction;

insert into material (nombre,unidad_medida,stock)
value("arroz negro","kg",10);

select codigo into @EB
from producto
where nombre = 'ensalada burgol';

select codigo into @S
from material
where nombre = 'sal';

select codigo into @AOA
from material
where nombre = 'aceite oliva agroecol';

 select mat.codigo INTO @cod_mat 
       FROM material mat
       WHERE mat.nombre = 'arroz negro';

delete from composicion 
where codigo_producto=@EB and codigo_material = @S;

delete from composicion 
where codigo_producto=@EB and codigo_material = @AOA;

insert into composicion value (@EB,@cod_mat,0.5);

commit;

/*304-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
 Se ha fabricado el día de hoy un nuevo lote del producto “bruscheta” que vence en 2 días.
 Debe insertarse con el número siguiente de lote y la cantidad fabricada es 50.
 Se debe además registrar 2 hs de Sanji Vinsmoke de trabajo de producción para dicho lote.
 También se deberá incrementar el precio sugerido un 20%.*/
 
 start transaction;
 
 select codigo into @Bru
from producto
where nombre="bruscheta";

 update producto p set p.precio_sugerido=p.precio_sugerido+p.precio_sugerido*0.2
 where p.codigo=@Bru;

select numero into @num_l
from lote 
where codigo_producto=@Bru;

insert into lote(codigo_producto,numero,cantidad_producida,fecha_produccion,fecha_vencimiento)
 value(@Bru,@num_l+1,50,curdate(),curdate()+2);
 
 select numero into @num_lote
 from lote 
 where fecha_produccion=curdate()+1;

select cuil into @miem
from miembro
where nombre="Sanji" and apellido="Vinsmoke";

insert into produce(codigo_producto,numero_lote,cuil_miembro,horas_trabajadas)
value (@Bru,@num_lote,@miem,2);

commit;

/*303-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
Se ha creado el nuevo grupo “Agroecológico”.
 El mismo será conformado por 2 miembros ya pertenecientes a la cooperativa: “Souma Yukihira” y “Sanji Vinsmoke”. 
 Este grupo se hará cargo de desarrollar los productos “ensalada burgol” y
 “ensalada tabule” los cuales deberán ser reasignados a este nuevo grupo. **/
 
 start transaction;
 
 select cuil into @miem_1
 from miembro
 where nombre ="Souma" and apellido="Yukihira";
 
 select cuil into @miem_2
 from miembro
 where nombre ="Sanji" and apellido="Vinsmoke";
 
 insert into grupo (nombre)value("Agroecológico");
 
 select numero into@num_gru
 from grupo g
 where g.nombre="Agroecológico";
 
 insert into grupo_miembro (numero_grupo,cuil_miembro)
 value(@num_gru,@miem_1);
  insert into grupo_miembro (numero_grupo,cuil_miembro)
 value(@num_gru,@miem_2);
 
 update producto p set p.numero_grupo=@num_gru
 where p.nombre in("ensalada burgol","ensalada tabule");
 
 commit;


