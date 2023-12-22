var canvas;
var context;
var Rock = [];
var Par = [];
var prev = new Date();
var Nstop = true;

class Rocket{
	Rocket(){
		this.x    = Math.random() * 1600;
		this.y    = 910;
		this.his  = [[this.x,this.y]];
		this.tick = (1 - Math.pow(Math.random(),3)) * 4;
		this.velY = .9;
		this.velX = Math.random() - .5;
		this.it   = 0;
		this.id   = Math.floor(Math.random() * 4)
	}
	up(){
		this.his.push([this.x,this.y])
		if(this.his.length + this.it / 2 > 50)
		{this.his = this.his.slice(2);}
		context.beginPath();
		context.moveTo(this.his[0][0],this.his[0][1])
		this.his.forEach(e => {
			context.lineTo(e[0],e[1])
		});
		context.stroke();
		if(this.tick < .1){this.it++;}
		this.x += this.velX;
		this.y -= this.velY;
		this.velY -= .0005;
		this.tick -= .002;
		if(this.his.length <= 1){return true;}
		else{return false;}
	}
}
class Partikle{
	Partikle(x,y,color){
		this.his   = [[x,y]];
		this.it    = 0;
		this.x     = x;this.y    = y
		this.tick  = 1;
		this.velX  = Math.random() * 2 - 1;
		this.velY  = Math.random() * 2 - 1.25;
		this.color = color;
	}
	move(){
		this.his.push([this.x,this.y]);
		if((this.his.length + this.it) > 75)
		{this.his = this.his.slice(2);}
		context.beginPath();
		context.moveTo(this.his[0][0],this.his[0][1]);
		context.strokeStyle = this.color;
		this.his.forEach(e => {
			try{context.lineTo(e[0],e[1])}catch{}
		});
		context.stroke();
		if(this.it > 1 || this.his.length >= 74){this.it++;}
		this.tick -= .005
		this.x += this.velX
		this.y += this.velY
		this.velY += .01
		if(this.his.length <= 1){return true;}
		else{return false;}
	}
}

function run() {
	context.fillRect(0,0,1600,900);
	if(Rock.length < 60){
		Rock.push(new Rocket())
		Rock[Rock.length - 1].Rocket()
	}
	context.strokeStyle = "#f92";
	context.lineWidth = 2;
	Rock.forEach(e => {
		if(e.up()){
			for(i = 0;i < 25;i++){
				Par.push(new Partikle());
				Par[Par.length - 1].Partikle(
					e.x,
					e.y,
					[
						[
							"#8f0","#0f8","#f40","#04f","#0f8","#ff4","#4ff","#f4f"
						][Math.floor(Math.random()*8)],
						"#f08",
						"#0f8",
						"#80f"
					][e.id]
				);
			}
			e.Rocket();
		}
	});
	context.lineWidth = 5;
	for(i = 0;i < Par.length;i++){
		if(Par[i].move()){
			Par.splice(i,1);
		}
	}
	_=Nstop?requestAnimationFrame(run):0;
	console.log(100 / (new Date() - prev));
	prev = new Date();
}

function loader() {
	canvas = document.getElementById("Draw");
	context = canvas.getContext("2d");
	context.fillStyle = "#000";
	context.font = "10px sans-serif";
	Nstop = true;
	run();
}