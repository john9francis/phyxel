pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- "phyxel"       -- 
-- physics engine --
-- john9francis   --
-- mit license    --

function make_grid(x, y)
 -- this grid keeps track of
 -- physics processes
 --
	-- note: index starts at 1

	local grid = {}

	for i=1,x do
		local row = {}
	 for j=1,y do
	  row[j] = 0
	 end
	 grid[i] = row
	end
	
	return grid

end

function vec2(x,y)
 return {x=x, y=y}
end



function make_vec_grid(x, y)
 -- this grid keeps track of
 -- physics processes
 --
	-- note: index starts at 1

	local grid = {}

	for i=1,x do
		local row = {}
	 for j=1,y do
	  row[j] = vec2(0,0)
	 end
	 grid[i] = row
	end
	
	return grid

end



function get_phys_grid(x,y)
 local energy_grid = make_grid(x,y)
 local gradient_grid = make_vec_grid(x,y)
 
 return {
  energy_grid = energy_grid,
  gradient_grid = gradient_grid,
    
  add_energy = function(x,y,e)
  	-- note: in the table, first
  	-- index is for column,
  	-- second is row. that's why
  	-- we reverse it, because
  	-- our convention is row,col
   energy_grid[y][x] += e
  end,
  
  -- todo: get_force function
  -- will return the gradient
  -- at the requested x,y coord
  get_force_vec = function(x,y)
   -- note: returns a vec2
   -- which can be accessed via
   -- vec2.x and vec2.y
   
   -- also: convention:
   -- positive = down and right
   return gradient_grid[x][y]
  end,
  
  print_grids = function()
   print("energy grid:")
   for i=1,#energy_grid do
	   for j=1,#energy_grid[i] do
		   print(energy_grid[i][j], i*10, j*10)
	   end
   end
   
   print("gradient grid:")
   for i=1,#gradient_grid do
	   for j=1,#gradient_grid[i] do
	    local vec = gradient_grid[i][j]
		   print("("..vec.x..","..vec.y..")", i*20, j*20 + 30)
	   end
   end
  end,
  
  reset_grid = function()
   for i=1,#energy_grid do
    for j=1,#energy_grid[i] do
     energy_grid[i][j] = 0
    end
   end
   
   for i=1,#gradient_grid do
    for j=1,#gradient_grid[i] do
     gradient_grid[i][j].x = 0
     gradient_grid[i][j].y = 0
    end
   end
  end,
  
  update = function()
   -- first, get gradient_grid
   -- via finite difference
   for i=1,#gradient_grid do
    for j=1, #gradient_grid[i] do
     -- handle boundaries
     -- at i=1, i=#g_g
     -- at j=1, j=#g_g[i]
     local i_init = i-1
     local i_final = i+1
     local j_init = j-1
     local j_final = j+1
     
     -- let's do periodic boundaries
     -- alternatives: ignore boundaries (skip)
     -- or set boundaries with border
 
     if i==1 then i_init = #gradient_grid end
     if i==#gradient_grid then i_final = 1 end
     if j==1 then j_init = #gradient_grid end
     if j==#gradient_grid[i] then j_final = 1 end
     
     diffx = energy_grid[i_final][j] - energy_grid[i_init][j] 
  		 diffy = energy_grid[i][j_final] - energy_grid[i][j_init]
  			
     gradient_grid[i][j] = vec2(diffx, diffy)
    end
   end
  end
 }
end

function test()
 pg = get_phys_grid(3, 3)
 pg.add_energy(1,2,3)
 pg.update()
 frc_vec = pg.get_force_vec(2,2)
 print("frc: ("..frc_vec.x..","..frc_vec.y..")", 10, 100)


 pg2 = get_phys_grid(3, 3) 
 pg2.add_energy(3,3,3)
 pg2.update()
 frc_vec2 = pg.get_force_vec(2,2)
 print("frc: ("..frc_vec2.x..","..frc_vec.y..")", 10, 100)
 pg2.print_grids()
end
-->8
-- test --

function phys_obj()
 return {
 	x = 0,
 	y = 0,
 	vx = 0,
 	vy = 0,
 	e = 0,
 }
end

function _init()
 obj = phys_obj()
 obj.x = 20
 obj.y = 40
 obj.e = 5
 
 g = get_phys_grid(32,32)
end

function _update()
	g.reset_grid()
	if obj.x > 1 and obj.x < 128 then
  g.add_energy(flr(obj.x/4),flr(obj.y/4), obj.e)
  local frc = g.get_force_vec(flr(obj.x/4), flr(obj.y/4))
  obj.vx = frc.x
  obj.vy = frc.y + 8
 	print("∧orking")
 end
 
 g.update()

	obj.x += obj.vx
	obj.y += obj.vy

end

function _draw()
 cls()
 circfill(obj.x, obj.y, obj.e, 5)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
