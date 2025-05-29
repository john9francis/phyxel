pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--    "phyxel"    -- 
-- physics engine --
--  john9francis  --
--  mit license   --

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

	local self = {
	 size_x = x,
	 size_y = y
	}
	
 self.energy_grid = make_grid(x,y)
 self.gradient_grid = make_vec_grid(x,y)
 
 self.add_energy = function(self,x,y,e)
  -- note: in the table, first
  -- index is for column,
  -- second is row. that's why
  -- we reverse it, because
 	-- our convention is row,col
  self.energy_grid[y][x] += e
 end
  
  
 self.get_force_vec = function(self,x,y)
  -- note: returns a vec2
  -- which can be accessed via
  -- vec2.x and vec2.y
   
  -- also: convention:
  -- positive = down and right
  return self.gradient_grid[x][y]
 end
  
 self.reset_grid = function(self)
  self.energy_grid = make_grid(self.size_x, self.size_y)
  self.gradient_grid = make_vec_grid(self.size_x, self.size_y)
 end
  
 self.print_grids = function(self)
  print("energy grid:")
  for i=1,#self.energy_grid do
	  for j=1,#self.energy_grid[i] do
		  print(self.energy_grid[i][j], i*10, j*10)
	  end
  end
   
  print("gradient grid:")
  for i=1,#self.gradient_grid do
	  for j=1,#self.gradient_grid[i] do
	   local vec = self.gradient_grid[i][j]
		  print("("..vec.x..","..vec.y..")", i*20, j*20 + 30)
	  end
  end
 end
  
 self.update = function(self)
  -- first, get gradient_grid
  -- via finite difference
  for i=1,#self.gradient_grid do
   for j=1, #self.gradient_grid[i] do
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
 
    if i==1 then i_init = #self.gradient_grid end
    if i==#self.gradient_grid then i_final = 1 end
    if j==1 then j_init = #self.gradient_grid end
    if j==#self.gradient_grid[i] then j_final = 1 end
     
    local diffx = self.energy_grid[i_final][j] - energy_grid[i_init][j] 
  		local diffy = self.energy_grid[i][j_final] - energy_grid[i][j_init]
  			
    self.gradient_grid[i][j] = vec2(diffx, diffy)
   end
  end
 end

return self

end
-->8
-- phys_obj --

function phys_obj(x,y,vix,viy,e,dt)
 local self = {
  x = x or 0,
  y = y or 0,
  vx = vix or 0,
  vy = viy or 0,
  dt = dt or 0.01,
  e = e or 0
 }
 
 self.add_force = function(fx,fy)
  self.vx += fx * self.dt
  self.vy += fy * self.dt
 end
  
 self.update = function()
  self.x += self.vx * self.dt
  self.y += self.vy * self.dt
 end
  
 self.reset_velocity = function()
  self.vx = 0
  self.vy = 0
 end
 
 return self
end

-->8
-- test simulation --


function _init()
 -- create a few phys_objs
 
 phys_objs = {
 	phys_obj(1,2,3,0,3),
 	phys_obj(120,2,-3,2,4),
 	phys_obj(50,4,0,0,10)
 }
 
 -- create the grid
 grid = get_phys_grid(32, 32)

end

function _update()
 -- reset
	grid.reset_grid()
	
	-- add energies
 for i=1, #phys_objs do
  local ob = phys_objs[i]
 	grid.add_energy(ob.x, ob.y, ob.e)
 end
 
 -- update grid
 grid.update()
 
 -- update objs
 for i=1, #phys_objs do
  local ob = phys_objs[i]
  local frc = grid.get_force_vec(ob.x, ob.y)
  
  phys_objs[i].reset_velocity()
  phys_objs[i].add_force(frc.x, frc.y)
  phys_objs[i].update()
 end

end

function _draw()
 cls()
 for i=1,#phys_objs do
 	local ob = phys_objs[i]
  circ(ob.x, ob.y, 5, ob.e)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
