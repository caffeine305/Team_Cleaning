col = require 'HC'

local text = {}

function love.load()
	love.graphics.setBackgroundColor(0,162,232)
	love.graphics.setNewFont(36)

	
	player1 = love.graphics.newImage("Gatinsky_Big.png")      --Carga de la imagen del gato de nom
	player2 = love.graphics.newImage("Gatinsky_Dos.png")      
	item = love.graphics.newImage("Cuadricho.png")

	deadzone = 0.25 
	local joysticks = love.joystick.getJoysticks()      --Carga del joystick de "control de mexbox"
	joystick = joysticks[1]				--Primer control encontrado, podemos cambiar el control selecionado cambiando su pocision en este arreglo

	position = {x = 200, y = 300}		--Posicion inicial del gato
	posp2 = {x = 400, y = 300}			--posición inicial de gatinsky2
	itemPos = {x = 40, y = 40}

	speed = 500							--Velocidad a la que se mueve
	s = {}								--variable de espacio para el Joystick

	itemCol = col.rectangle(itemPos.x,itemPos.y,40,40)
	itemCol:moveTo(itemPos.x,itemPos.y)

	p1Col = col.rectangle(position.x,position.y,187,162)
	p1Col:moveTo(position.x,position.y)

	p2Col = col.rectangle(posp2.x,posp2.y,187,162)
	p2Col:moveTo(posp2.x,posp2.y)

end

------------------------------------------------------------------------------------------------

local lastbutton = "none"				--establecemos el boton precionado como ninguno

function love.gamepadpressed(joystick, button)   --funcion para saber que botn se presiono
    lastbutton = button
end

------------------------------------------------
--Funccion que permite la actualizacion del gato en pantalla oprimiendo algun control de mexbox
function love.update(dt)

    if not joystick then return end							--Si no hay algun control no se mueve el gato

    if joystick:isGamepadDown("dpleft") then				--Movemos la posicion en X
        position.x = position.x - speed * dt
    elseif joystick:isGamepadDown("dpright") then
        position.x = position.x + speed * dt
    end

    if joystick:isGamepadDown("dpup") then					--Movemos la posicion en Y
        position.y = position.y - speed * dt
    elseif joystick:isGamepadDown("dpdown") then
        position.y = position.y + speed * dt
    end

	local leftx = joystick:getGamepadAxis('leftx')			--Configuración horizontal del joystick izquierdo
	local lefty = joystick:getGamepadAxis('lefty')			--Configuración vertical del joystick izquierdo
	local rightx = joystick:getGamepadAxis('rightx')		--Configuración horizontal del joystick derecho
	local righty = joystick:getGamepadAxis('righty')		--Configuración vertical del joystick derecho
			
--calcular zona muerta

	local leftextent = math.sqrt(math.abs(leftx * leftx) + math.abs(lefty * lefty))
	local rightextent = math.sqrt(math.abs(rightx * rightx) + math.abs(righty * righty))

	if(leftextent < deadzone) then
		position.x=position.x
		position.y=position.y

	else

		position.x = position.x + leftx * speed * dt
		position.y = position.y + lefty * speed * dt
	end

	if(rightextent < deadzone) then
		posp2.x=posp2.x
		posp2.y=posp2.y

	else
		posp2.x = posp2.x + rightx * speed * dt
		posp2.y = posp2.y + righty * speed * dt
	end

	p1Col:moveTo(position.x,position.y)
	p2Col:moveTo(posp2.x,posp2.y)

	-- check for collisions
    for shape, delta in pairs(col.collisions(p1Col)) do
        text[#text+1] = string.format("Colliding. Separating vector = (%s,%s)",
                                      delta.x, delta.y)
    end
	
	for shape, delta in pairs(col.collisions(p2Col)) do
	text[#text+1] = string.format("Colliding. Separating vector = (%s,%s)",
                                      delta.x, delta.y)
    end

    while #text > 40 do
        table.remove(text, 1)
    end
end

-----------------------------------------------------------------------------------
--Dibujado en pantalla
function love.draw()


	--local _, _, flags = love.window.getMode()						--Obtenemos la resolucion del monitor y el monitor usado
	--local width, height = love.window.getDesktopDimensions(flags.display)
	--love.graphics.print(("display %d: %d x %d"):format(flags.display, width, height), 4, 10)   --Imprimimos los datos Obtenidos

	
	love.graphics.draw(player1, position.x, position.y,0,1,1,player1:getWidth()/2,player1:getHeight()/2)	--Movemos el gato
	p1Col:draw('line')

	love.graphics.draw(player2, posp2.x, posp2.y,0,1,1,player2:getWidth()/2,player2:getHeight()/2)		--Movemos el otro gato
	p2Col:draw('line')

	love.graphics.draw(item, itemPos.x, itemPos.y,0,1,1,item:getWidth()/2,item:getHeight()/2)
	itemCol:draw('line')

	love.window.setTitle("The Cleaners")				--Titulo del juego

	--love.graphics.print("Last gamepad button pressed: "..lastbutton, 100, 100)		--Mostrando que boton se apreto

	 --[[for i = 1,#text do
        --love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
        love.graphics.print(text[#text - (i-1)], 10, i * 15)
    end]]

end