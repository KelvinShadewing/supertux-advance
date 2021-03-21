////////////
// SHAPES //
////////////

::shape <- {};
::lastshape <- 0;

::Point <- class
{
	x = 0.0;
	y = 0.0;

	constructor(_x, _y)
	{
		x = _x;
		y = _y;
	}

	function _typeof() { return "point"; }
	function dot(p) { return (x * p.x) + (y* p.y); }
	function rotate(pivx, pivy, angle)
	{
		x -= pivx;
		y -= pivy;

		local theta = angle * (3.14159 / 180);
		local nx = (x * cos(theta)) - (y * sin(theta));
		local ny = (x * sin(theta)) + (y * cos(theta));

		nx += pivx;
		ny += pivy;

		x = nx;
		y = ny;
	}
}

::Shape <- class //Base class for all shapes
{
	x = 0.0;
	y = 0.0;
	a = 0.0;

	//Boundary coordinates
	lx = 0.0;
	ly = 0.0;
	ux = 0.0;
	uy = 0.0;

	constructor(_x, _y)
	{
		x = _x;
		y = _y;
	}

	function updatePoints(){}

	function setPos(_x = 0.0, _y = 0.0, _a = 0.0)
	{
		x = _x;
		y = _y;
		a = _a;
		updatePoints();
	}

	function modPos(_x = 0.0, _y = 0.0, _a = 0.0)
	{
		x += _x;
		y += _y;
		a += _a;
		updatePoints();
	}

	function getA()
	{
		return a;
	}

	function getX()
	{
		return x;
	}

	function getY()
	{
		return y;
	}

	function getW()
	{
		return ux - lx;
	}

	function getH()
	{
		return uy - ly;
	}

	function _typeof(){ return "shape"; }
}

::Circle <- class extends Shape
{
	r = 0.0;
	constructor(_x = 0.0, _y = 0.0, _r = 0.0)
	{
		x = _x;
		y = _y;
		r = _r;
	}

	function _typeof(){ return "circle"; }
}

::Ellipse <- class extends Shape
{
	w = 0.0;
	h = 0.0;

	constructor(_x, _y, _w, _h)
	{
		x = _x;
		y = _y;
		w = _w;
		h = _h;
	}

	function _typeof(){ return "ellipse"; }
}

::Line <- class extends Shape
{
	x2 = 0.0;
	y2 = 0.0;

	constructor(_x, _y, _x2, _y2)
	{
		x = _x.tofloat();
		y = _y.tofloat();
		x2 = _x2.tofloat();
		y2 = _y2.tofloat();
	}

	function _typeof(){ return "line"; }
}

/*
Squares and rectangles will just be polygons generated with specific parameters.
*/

::Polygon <- class extends Shape
{
	a = 0.0;
	p = []; //Original points
	pc = []; //Current points
	t = 0; //0 is polygon, 1 is rectangle

	function addPoint(_x = 0.0, _y = 0.0)
	{
		p.push([_x, _y]);
		updatePoints();
	}

	function updatePoints()
	{

		pc = [];
		local pt = Point(0, 0);
		if(p.len() > 0)
		{
			for(local i = 0; i < p.len(); i++)
			{
				pt.x = p[i][0] + x;
				pt.y = p[i][1] + y;
				pt.rotate(x, y, a);
				pc.push([pt.x, pt.y]);
			}

			ux = pc[0][0];
			lx = pc[0][0];
			uy = pc[0][1];
			ly = pc[0][1];

			for(local i = 0; i < p.len(); i++)
			{
				if(ux < pc[i][0]) ux = pc[i][0];
				if(lx > pc[i][0]) lx = pc[i][0];
				if(uy < pc[i][1]) uy = pc[i][1];
				if(ly < pc[i][1]) ly = pc[i][1];
			}
		}
	}

	constructor(_x, _y, _p)
	{
		x = _x;
		y = _y;
		p = _p;
		pc = _p;

		if(p.len() > 0)
		{
			ux = p[0][0];
			uy = p[0][1];
			lx = p[0][0];
			ly = p[0][1];
			for(local i = 0; i < p.len(); i++)
			{
				if(p[i][0] <= lx) lx = p[i][0];
				if(p[i][0] >= ux) ux = p[i][0];
				if(p[i][1] <= ly) ly = p[i][1];
				if(p[i][1] >= uy) uy = p[i][1];
			}
		}
	}

	function draw()
	{
		if(p.len() == 0) return;
		if(p.len() == 1)
		{
			drawPoint(pc[0][0], pc[0][1]);
			return;
		}

		for(local i = 0; i < p.len(); i++)
		{
			if(i < p.len() - 1) drawLine(pc[i][0], pc[i][1], pc[i + 1][0], pc[i + 1][1]);
			else drawLine(pc[i][0], pc[i][1], pc[0][0], pc[0][1]);
		}
	}

	function _typeof(){
		if(t == 1) return "rectangle"
		return "polygon";
	}

	function setPos(_x, _y, _a)
	{
		x = _x;
		y = _y;
		a = _a;
		updatePoints();
	}

	function modPos(_x, _y, _a)
	{
		x += _x;
		y += _y;
		a += _a;
		updatePoints();
	}

	function drawPos(_x, _y)
	{
		if(p.len() == 0) return;
		if(p.len() == 1)
		{
			drawPoint(_x + x, _y + y);
			return;
		}

		for(local i = 0; i < p.len(); i++)
		{
			if(i < p.len() - 1) drawLine(p[i][0] + _x + x, p[i][1] + _y + y, p[i + 1][0] + _x + x, p[i + 1][1] + _y + y);
			else drawLine(p[i][0] + _x + x, p[i][1] + _y + y, p[0][0] + _x + x, p[0][1] + _y + y);
		}
	}
}

::hitPointPoly <- function(x, y, p)
{
	//Cases for incomplete polygons
	if(p.pc.len() == 0) return false;
	if(p.pc.len() == 1) return (p.pc[0][0] == x && p.pc[0][1] == y);
	if(p.pc.len() == 2) return hitLinePoint(p.pc[0][0], p.pc[0][1], p.pc[1][0], p.pc[1][1], x, y);

	//Check that point is in bounds
	if(x < p.lx || x > p.ux || y < p.ly || y > p.uy) return false;

	//If so, count how many lines it touches
	local count = 0;

	for(local i = 0; i < p.pc.len(); i++)
	{
		if(i < p.pc.len() -1)
		{
			//Check between each point
			if(hitLineLine(x, y, p.lx - 1, y, p.pc[i][0], p.pc[i][1], p.pc[i + 1][0], p.pc[i + 1][1])) count++;
		} else {
			//Connect last point to first point
			if(hitLineLine(x, y, p.lx - 1, y, p.pc[i][0], p.pc[i][1], p.pc[0][0], p.pc[0][1])) count++;
		}
	}

	//Even number of hits means the point is outside
	//I imagine possible but rare cases where this
	//may not be true, but the odds seem extremely
	//low, especially if the shapes have different
	//vectors of motion.
	if(count % 2 == 1) return true;
	else return false;
}

::hitLinePoly <- function(a, b)
{

}

::hitPolyPoly <- function(a, b)
{
	if(a.p.len() == 0 || b.p.len() == 0) return false;
	if(a.p.len() == 1) return hitPointPoly(a, b);
	if(b.p.len() == 1) return hitPointPoly(b, a);

	for(local i = 0; i < a.p.len(); i++)
	{
		if(hitPointPoly(a.pc[i][0], a.pc[i][1], b)) return true;
	}

	for(local i = 0; i < b.p.len(); i++)
	{
		if(hitPointPoly(b.pc[i][0], b.pc[i][1], a)) return true;
	}

	for(local i = 0; i < a.p.len(); i++)
	{
		if(i < a.p.len() - 1)
		{
			for(local j = 0; j < b.p.len(); j++)
			{
				if(j < b.p.len() - 1)
				{
					if(hitLineLine(a.pc[i][0], a.pc[i][1], a.pc[i + 1][0], a.pc[i + 1][1], b.pc[j][0], b.pc[j][1], b.pc[j + 1][0], b.pc[j + 1][1])) return true;
				} else {
					if(hitLineLine(a.pc[i][0], a.pc[i][1], a.pc[i + 1][0], a.pc[i + 1][1], b.pc[j][0], b.pc[j][1], b.pc[0][0], b.pc[0][1])) return true;
				}
			}
		} else {
			for(local j = 0; j < b.p.len(); j++)
			{
				if(j < b.p.len() - 1)
				{
					if(hitLineLine(a.pc[i][0], a.pc[i][1], a.pc[0][0], a.pc[0][1], b.pc[j][0], b.pc[j][1], b.pc[j + 1][0], b.pc[j + 1][1])) return true;
				} else {
					if(hitLineLine(a.pc[i][0], a.pc[i][1], a.pc[0][0], a.pc[0][1], b.pc[j][0], b.pc[j][1], b.pc[0][0], b.pc[0][1])) return true;
				}
			}
		}
	}

	return false;
}

::hitTest <- function(a, b)
{
	switch(typeof a)
	{
		case "circle":
			switch(typeof b)
			{
				case "circle":
					return (distance2(a.x, a.y, b.x, b.y) <= a.r + b.r);
					break;
				case "polygon":
					break;
				case "line":
					return hitLineCircle(b.x, b.y, b.x2, b.y2, a.x, a.y, a.r);
					break;
				case "ellipse":
					break;
				case "point":
					return (distance2(a.x, a.y, b.x, b.y) <= a.r);
					break;
				default:
					return false;
					break;
			}
			break;
		case "polygon":
			switch(typeof b)
			{
				case "circle":
					break;
				case "polygon":
					return hitPolyPoly(a, b);
					break;
				case "line":
					break;
				case "ellipse":
					break;
				case "point":
					return hitPointPoly(b.x, b.y, a);
					break;
				default:
					return false;
					break;
			}
			break;
		case "line":
			switch(typeof b)
			{
				case "circle":
					return hitLineCircle(a.x, a.y, a.x2, a.y2, b.x, b.y, b.r);
					break;
				case "polygon":
					break;
				case "line":
					return hitLineLine(a.x, a.y, a.x2, a.y2, b.x, b.y, b.x2, b.y2);
					break;
				case "ellipse":
					break;
				case "point":
					break;
				default:
					return false;
					break;
			}
			break;
		case "ellipse":
			switch(typeof b)
			{
				case "circle":
					break;
				case "polygon":
					break;
				case "line":
					break;
				case "ellipse":
					break;
				case "point":
					break;
				default:
					return false;
					break;
			}
			break;
		case "point":
			switch(typeof b)
			{
				case "circle":
					return (distance2(a.x, a.y, b.x, b.y) <= b.r);
					break;
				case "polygon":
					return hitPointPoly(a.x, a.y, b);
					break;
				case "line":
					break;
				case "ellipse":
					break;
				case "point":
					return (a.x == b.x && a.y == b.y);
					break;
				default:
					return false;
					break;
			}
			break;
		default:
			return false;
			break;
	}

	//If nothing returned
	//For collisions not yet
	//fully programmed
	return false;
}

