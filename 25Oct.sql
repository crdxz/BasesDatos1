---Seleccionar los empleados con el nombre de la región y nombre de depto. donde laboran--- 

Select E.first_name, R.name region , D.name depto  
From s_emp E, s_region R, s_dept D 
Where R.id = D.region_id AND  
  D.id = E.dept_id AND D.region_id = E.region_id;  

--- Seleccionar los empleados con la region donde estan ubicados ---

Select E.first_name, R.name region 
From s_emp E, s_region R, s_dept D 
Where R.id = D.region_id AND  
      D.id = E.dept_id AND D.region_id = E.region_id;  

--- Seleccionar los nombres de productos que se han vendido --- 
--- distinct para quitar los repetidos                      ---

select distinct P.name producto
from s_product P, s_item I
where P.id = I.product_id;

--- Seleccionar los productos que se han vendido en la region de NA ---

select distinct P.name Producto 
from s_region R, s_warehouse W, s_inventory I, s_product P, s_item IT  
where R.id = W.region_id and 
      W.id = I.warehouse_id and 
      P.id = I.product_id and 
      P.id = IT.product_id and 
      upper(R.name)like 'NORT%';		--->>> Recorre el modelo dependiendo de las llaves PK y FK.
						--->>> Como hay una relacion muchos a muchos Inventario 
						       se usa para relacionar warehouse y product.


--- Seleccionar los representantes de ventas con sus clientes --- 

select E.first_name||' '||E.last_name Representante, E.title Cargo, C.name Cliente
from s_emp E, s_customer C
where E.id = C.sales_rep_id;        -->>> sale_rep : Representates de ventas 



>>> Where A = B, es como un Join, toma la PK y su respectiva FK de otra tabla.  
>>> 'NORT%' : NORT "%" --> significa cualquier cosa luego
>>> upper convierte a MAYUS

