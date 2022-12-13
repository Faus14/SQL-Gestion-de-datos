
/*305-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
 Se ha decidido cambiar la composición de la “ensalada burgol”, se retirarán los materiales “sal” y “aceite oliva agroecol” y
 se agregará 0.5 de un nuevo material que debe ser dado de alta con los siguientes datos,
nombre: “arroz negro”, unidad de medida: kg y stock: 10. **/

start transaction;

insert into material(nombre,unidad_medida,stock) value ("arroz negro","kg",10);

select codigo into @cod_ens
from producto
where nombre="ensalada burgol";

select codigo into @cod_sal
from material m
where m.nombre="Sal";

select codigo into @cod_ace
from material m
where m.nombre="aceite oliva agroecol";

delete from composicion 
where codigo_producto=@cod_ens and codigo_material=@cod_sal ;

delete from composicion 
where codigo_producto=@cod_ens and codigo_material=@cod_ace;

select codigo into @cod_arr
from material
where nombre="arroz negro";

insert into composicion value(@cod_ens,@cod_arr,0.5);

commit;


/*304-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
 Se ha fabricado el día de hoy un nuevo lote del producto “bruscheta” que vence en 2 días.
 Debe insertarse con el número siguiente de lote y la cantidad fabricada es 50.
 Se debe además registrar 2 hs de Sanji Vinsmoke de trabajo de producción para dicho lote.
 También se deberá incrementar el precio sugerido un 20%.*/
 
 start transaction;
 
 update producto set precio_sugerido= precio_sugerido+ precio_sugerido *0.2
 where nombre="bruscheta";
 
 select codigo into @cod_bru
 from producto
 where nombre="bruscheta";
 
 select max(numero) into @num_bru_lote
 from lote
 where codigo_producto=@cod_bru;
 
 insert into lote value(@cod_bru,@num_bru_lote+1,50,curdate(),curdate()+2);
 
 select cuil into @cuil_m
 from miembro
 where nombre="Sanji" and apellido="Vinsmoke";
 
 select numero into @num_lote_nu
 from lote
 where codigo_producto=@cod_bru and numero=@num_bru_lote+1;
 
 insert into produce value(@cod_bru,@num_lote_nu,@cuil_m,2);
 
 commit;
 
 /*303-6. Realice las operaciones para aplicar los siguientes cambios dentro de una transacción.
Se ha creado el nuevo grupo “Agroecológico”.
 El mismo será conformado por 2 miembros ya pertenecientes a la cooperativa: “Souma Yukihira” y “Sanji Vinsmoke”. 
 Este grupo se hará cargo de desarrollar los productos “ensalada burgol” y
 “ensalada tabule” los cuales deberán ser reasignados a este nuevo grupo. **/
 
 start transaction;
 
 insert into grupo (nombre) value("Agroecológico");
 
 select cuil into @miem_1
 from miembro
 where nombre="Souma" and apellido="Yukihira";
 
  select cuil into @miem_2
 from miembro
 where nombre="Sanji" and apellido="Vinsmoke";
 
 select numero into @num_gr
 from grupo
 where nombre="Agroecológico";
 
 insert into grupo_miembro value(@num_gr,@miem_1);
 insert into grupo_miembro value(@num_gr,@miem_2);
 
 update producto p set numero_grupo=@num_gr
 where p.nombre="ensalada burgol" or p.nombre="ensalada tabule";
 

 commit;
  
  
 