function Particle(posx,posy)
{this.posX=posx;this.posY=posy;this.velX=0;this.velY=0;this.shrink=1;this.size=1;this.drag=1;this.gravity=0;this.alpha=1;this.fade=0;this.update=function()
{this.velX*=this.drag;this.velY*=this.drag;this.velY+=this.gravity;this.posX+=this.velX;this.posY+=this.velY;this.size*=this.shrink;this.alpha-=this.fade;}
this.render=function(c)
{c.fillStyle="rgb(255,255,255)";c.beginPath();c.arc(this.posX,this.posY,this.size,0,Math.PI*2,true);c.closePath();c.fill();}}
function randomRange(min,max)
{return((Math.random()*(max-min))+ min);}

function makeParticle(particleCount)
{
	
	for(var i=0; i<particleCount;i++)
	{
		var particles = [];
		// create a new particle in the middle of the stage
		var particle = new Particle(500, 480); 

		// give it a random x and y velocity
		particle.velX = (Math.random()*20)-10;
		particle.velY = (Math.random()*20)-10;

		particle.drag = 0.96;
		particle.gravity = 0.5; 

		// add it to the array
		particles.push(particle); 

	}
	return particles;

}