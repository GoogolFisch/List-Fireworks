import pygame as pyg
import sys
import random
import time

def blurSurf(surface,amt:float,raiseing=True):
    """
Blur the given surface by the given amt. Only values from 1 and more.
1 == noblur
    """
    if amt < 1.0 and raiseing:
        raise ValueError("amt must be greater than 1")
    scale = 1.0/amt
    surf_size = surface.get_size()
    scale_size = (int(surf_size[0] * scale),int(surf_size[1] * scale))
    surf = pyg.transform.smoothscale(surface,scale_size)
    surf = pyg.transform.smoothscale(surf,surf_size)
    return surf

class Entity:
	class Roket:
		__slots__ = "PosX","PosY","velX","velY","length"
		def __init__(self,screenSize) -> None:
			self.PosX   = random.randrange(-40,screenSize[0] + 40)
			self.PosY   = screenSize[1] + 10
			self.velX   = (self.PosX - random.randrange(0,screenSize[0])) * .03125
			self.velY   = random.randrange(-screenSize[1] // 8,-screenSize[1] // 12)
			self.length = random.randrange(25,50)
		def move(self,screen):
			pyg.draw.line(screen,(127, 63, 7),[self.PosX,self.PosY],[self.PosX + self.velX,self.PosY + self.velY],2)
			#
			self.PosX += self.velX
			self.PosY += self.velY
			self.length -= 1
			self.velX *= .93
			self.velY = (self.velY + 1) * .9
			#
			if self.length == 0:return(True,(self.PosX,self.PosY))
			return (False,(self.PosX,self.PosY),0)
	
	class Partikle:
		__slots__ = "PosX","PosY","velX","velY","length","color"
		def __init__(self,pos,l,c,**more) -> None:
			lx = random.uniform(-1,1)
			ly = random.uniform(-1,1)
			self.PosX   = pos[0]
			self.PosY   = pos[1]
			self.color  = (
				(random.randrange(0,300),random.randrange(0,300),random.randrange(0,300)),
				(300, 64, 10),
				(127,300, 90),
				( 90,255,300),
				(250,300,170),
			)[c % 5]
			v = random.choice((
				(
					lx * 16,
					ly * 16
				),(
					lx * 12,
					lx * 8 * lx - 16
				),(
					lx * 8,
					(abs(lx) ** .5) * 16 - 32
				),
			))
			self.velX   = v[0]
			self.velY   = v[1]
			self.length = l
		def move(self,screen):
			pyg.draw.line(
				screen,
				(
					min(255,self.color[0]),
					min(255,self.color[1]),
					min(255,self.color[2])
				),
				[self.PosX,self.PosY],
				[self.PosX + self.velX,self.PosY + self.velY],
				6
			)
			#
			self.color = (
				max(0,self.color[0] * .93),
				max(0,self.color[1] * .93),
				max(0,self.color[2] * .93)
			)
			self.PosX += self.velX
			self.PosY += self.velY
			self.length -= 1
			self.velX *= .9
			self.velY = (self.velY + 1) * .9
			#
			if self.length == 0:return(True)
			return (False)

	class Snow:
		__slots__ = "x","y","maxY","scrX"
		def __init__(self,screenSize) -> None:
			self.x    = random.randrange(-10,screenSize[0] + 10)
			self.y    = random.randrange(-screenSize[1],0)
			self.maxY = screenSize[1]
			self.scrX = screenSize[0]
		def move(self,screen):
			pyg.draw.rect(screen,(255,255,255),[self.x,self.y,2,2])
			self.x += random.randrange(-1,2)
			self.y += random.randrange(0,2)
			if self.y > self.maxY:
				self.x = random.randrange(-10       ,self.scrX + 10)
				self.y = random.randrange(-self.maxY,0             )

class Main:
	__slots__ = "__dict__","__weakref__","counter"
	def __init__(self,args):
		pyg.init()
		if args[1] == "full":
			self.screen = pyg.display.set_mode([0,0],pyg.FULLSCREEN)
			self.sSize  = self.screen.get_size()
		else:
			self.sSize  = (int(args[1]),int(args[2]))
			self.screen = pyg.display.set_mode(self.sSize)
		self.clock = pyg.time.Clock()

		self.boomScreen  = pyg.Surface(self.sSize)
		self.clockScreen = pyg.Surface(self.sSize)
		
		pyg.display.set_caption("Python Silvester")

		self.darkerIm = pyg.image.load(".\\darker.png")

		self.Rockets   = [Entity.Roket(self.sSize) for _ in range(  0)]
		self.Partikles = []
		self.Snow      = [Entity.Snow (self.sSize) for _ in range(  0)]

		self.counter   = 0

	def run(self):
		running = True
		while running:
			# print(self.clock.get_fps())
			self.counter += 1
			for event in pyg.event.get():
				if event.type == pyg.QUIT:
					running = False
				elif event.type == pyg.KEYDOWN:
					if   event.key == pyg.K_f:
						self.Rockets += [Entity.Roket(self.sSize) for _ in range(3)]
					elif event.key == pyg.K_q:
						print(self.clock.get_fps())
			# snow on clock
			#for e,sno in enumerate(self.Snow):
			#    = sno.move(self.clockScreen)
			# clock
			if time.strftime("%d|%m|%M|%H") == "31|12|59|23":
				if time.strftime("%S") in "50|51|52|53|54|55|56|57|58|59".split("|"):
					self.clockScreen.blit(
						pyg.font.Font(None,120).render(
							time.strftime("%H:%M:%S"),
							1,
							(255,255,255)
						),
						(0,0)
					)
				else:
					self.clockScreen.blit(
						pyg.font.Font(None,80).render(
							time.strftime("%H:%M:%S"),
							1,
							(255,255,255)
						),
						(0,0)
					)
			elif time.strftime("%d|%m|%S|%M|%H") == "1|1|0|0|0":
				self.clockScreen.blit(
					pyg.font.Font(None,30).render(
						time.strftime("%H:%M:%S"),
						1,
						(255,255,255)
					),
					(0,0)
				)
				self.Rockets += [Entity.Roket(self.sSize) for _ in range(1)]
			else:
				self.clockScreen.blit(
					pyg.font.Font(None,30).render(
						time.strftime("%H:%M:%S"),
						1,
						(255,255,255)
					),
					(0,0)
				)
			self.clockScreen.set_colorkey((0,0,0))

			# rocket++
			for e,rock in enumerate(self.Rockets):
				a = rock.move(self.boomScreen)
				if a[0]:
					if self.counter % 96 == 0:self.Rockets.remove(rock)
					else                     :self.Rockets[e] = Entity.Roket(self.sSize)
					f = random.randrange(0,10)
					self.Partikles += [Entity.Partikle(a[1],40,f) for _ in range(20)]
					
			for par  in self.Partikles:
				a = par.move(self.boomScreen)
				if a:
					self.Partikles.remove(par)
			# displaying
			self.screen.blit(self.boomScreen,(0,0))
			self.screen.blit(self.clockScreen,(0,0))
			# end
			pyg.display.flip()
			self.clock.tick(-1)
			self.boomScreen.blit(pyg.transform.scale(self.darkerIm,self.sSize),(0,0));self.boomScreen = blurSurf(self.boomScreen,2)
			self.clockScreen.fill((0,0,0))
		pyg.quit()

if __name__ == '__main__':
	MainClass = Main(sys.argv)
	MainClass.run()
#'get_abs_offset', 'get_abs_parent', 'get_alpha', 'get_at', 'get_at_mapped', 'get_bitsize', 'get_blendmode', 'get_bounding_rect', 'get_buffer', 'get_bytesize', 'get_clip', 'get_colorkey', 'get_flags', 'get_height', 'get_locked', 'get_locks', 'get_losses', 'get_masks', 'get_offset', 'get_palette', 'get_palette_at', 'get_parent', 'get_pitch', 'get_rect', 'get_shifts', 'get_size', 'get_view', 'get_width', 'lock', 'map_rgb', 'mustlock', 'scroll', 'set_alpha', 'set_at', 'set_clip', 'set_colorkey', 'set_masks', 'set_palette', 'set_palette_at', 'set_shifts', 'subsurface', 'unlock', 'unmap_rgb'
