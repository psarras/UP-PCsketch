class Box {
	
	PVector location;
	float sizeX;
	float sizeY;
	float sizeZ;

	color boxColor = color(0, 20);

	Box (PVector location, float sizeX, float sizeY, float sizeZ ) {
		this.location = location;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
	}

	void draw() {
		pushMatrix();
		pushStyle();
		fill(boxColor);
		rect(location.x, location.y, sizeX, sizeY);
		popStyle();
		popMatrix();
	}

	boolean checkInside(PVector a) {
		if (a.x > location.x   && a.x < location.x + sizeX &&
		    a.y > location.y   && a.y < location.y + sizeY &&
		    a.z > location.z   && a.z < location.z + sizeZ
		    ) {
			return true;	
		} else {
			return false;
		}
		// ellipse(a.x, a.y, 10, 10);
	}
	boolean checkInsideND(PVector a) {
		if (a.x > location.x   && a.x < location.x + sizeX &&
		    a.y > location.y   && a.y < location.y + sizeY
		    ) {
			return true;	
		} else {
			return false;
		}
		// ellipse(a.x, a.y, 10, 10);
	}	
}
