-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start();
physics.setGravity( 0, 0 ); 
physics.pause();

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local background, puck;

--Methods
local function shoot(e)
	if(e.phase == 'moved') then

	elseif(e.phase == 'ended') then
		print("shot")
		puck:applyForce(-(puck.x - e.x), -(puck.y - e.y), puck.x, puck.y)
		
		-- Prevent Ball from being hit when moving
		--puck:removeEventListener('touch', shoot)
		
		-- Stop Ball after a few seconds
		--local stopBall = timer.performWithDelay(5000, function() puck:setLinearVelocity(0, 0, puck.x, puck.y) puck:addEventListener('touch', shoot) end, 1)
	end
end

local function onCollision(e)
	if(e.other.name == 'puck') then
		
	end
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	background = display.newRect( 0, 0, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .9 )
	
	-- make a puck
	puck = display.newCircle( halfW, screenH - 50, 20 )
	puck.name = 'puck';
	puck:setFillColor(0.7);
	puck:setStrokeColor( 0, 0, 1 );
	puck.strokeWidth = 5;
	
	-- add physics to the puck
	physics.addBody( puck, 'dynamic', { density=1.0, friction=0.3, bounce=0.3, radius=20 } )
	
	-- create a grass object and add physics (with custom shape)
	--local grass = display.newImageRect( "grass.png", screenW, 82 )
	--grass.anchorX = 0
	--grass.anchorY = 1
	--grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	--group:insert( grass)
	group:insert( puck )

	--Events
	background:addEventListener( 'touch', shoot );
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene