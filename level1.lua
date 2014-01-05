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

local background, lines, faultLine, blueCircle, redCircle, sochiLogo, circleLogo, lights;

local pucks;
local activePuckIndex = 1;

--Methods
local function shoot(e)
	if(e.phase == 'moved') then

	elseif(e.phase == 'ended') then
		print("shot")
		pucks[activePuckIndex]:applyForce(-(pucks[activePuckIndex].x - e.x), -(pucks[activePuckIndex].y - e.y), pucks[activePuckIndex].x, pucks[activePuckIndex].y)
		
		-- Prevent Ball from being hit when moving
		pucks[activePuckIndex]:removeEventListener('touch', shoot)
		
		-- tell game pucks is moving after some time
		timer.performWithDelay(1000, function()  pucks[activePuckIndex].isMoving = true; end, 1)
	end
end

local function onCollision(e)
	if(e.other.name == 'puck') then
		
	end
end

local function gameLoop(event)
	if (pucks[activePuckIndex] ~= nil) then
		local vx, vy = pucks[activePuckIndex]:getLinearVelocity( );
		--print(vx .. "-" .. vy);
		if (vy < 0.1 and pucks[activePuckIndex].isMoving) then
			if (activePuckIndex < 8) then
				pucks[activePuckIndex].isMoving = false;

				--Next Puck
				activePuckIndex = activePuckIndex + 1;
				print(activePuckIndex);
				pucks[activePuckIndex].y = pucks[activePuckIndex].y - 200;
				physics.addBody( pucks[activePuckIndex], 'dynamic', { density=1.0, friction=1, bounce=0.3, radius=15 } )
				pucks[activePuckIndex].linearDamping = 0.5;
				pucks[activePuckIndex]:addEventListener( 'touch', shoot );
			end
		end
	end
end

Runtime:addEventListener("enterFrame", gameLoop);

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

	-- create ice
	background = display.newImageRect( "images/Icebg.jpg", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	lines = display.newImageRect( "images/linesStandard.png", screenW, screenH );
	lines.anchorX = 0;
	lines.anchorY = 0;

	faultLine = display.newImage( "images/faultLine.png" );
	faultLine.x = halfW;
	faultLine.y = screenH - 228;

	sochiLogo = display.newImage( "images/iceLogoLarge.png" );
	sochiLogo.x, sochiLogo.y = halfW, screenH - 340;

	blueCircle = display.newImage( "images/circleBlue.png" );
	blueCircle.x, blueCircle.y = halfW, 156;

	redCircle = display.newImage( "images/circleRed.png" );
	redCircle.x, redCircle.y = halfW, 156;

	circleLogo = display.newImage( "images/iceLogoSmall.png" );
	circleLogo.x, circleLogo.y = halfW, 156;

	lights = display.newImageRect( "images/lights.png", screenW, screenH );
	lights.anchorX = 0;
	lights.anchorY = 0;
	
	-- make pucks
	pucks = display.newGroup( );

	for i=1, 8 do
		local puck =  display.newImage( "images/rock.png");
		puck.x, puck.y = halfW, screenH + 100;
		puck.isAlive = false;
		puck.isMoving = false;
		puck.name = 'puck' .. i;
		puck.id = i;
		pucks:insert(puck);
	end

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( lines );
	group:insert( faultLine );
	group:insert( sochiLogo );
	group:insert( blueCircle );
	group:insert( redCircle );
	group:insert( circleLogo );
	group:insert( lights );
	group:insert( pucks );
	

	--Start Game
	pucks[1].isAlive = true;
	pucks[1].y = pucks[1].y - 200;
	physics.addBody( pucks[1], 'dynamic', { density=1.0, friction=1, bounce=0.3, radius=20 } )
	pucks[1].linearDamping = 0.5;
	background:addEventListener( 'touch', shoot );

	--Events
	
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