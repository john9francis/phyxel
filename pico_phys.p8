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


pg = get_phys_grid(3, 3)
pg.add_energy(1,2,3)
pg.update()
pg.print_grids()
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
