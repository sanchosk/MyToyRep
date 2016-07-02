$fn = 36;
/* VARIABLES */
{
bearingDia = 9.8;
screwHeadDia = 5.9;
screwHeadDepth = 4;
magnetDia = 6;
magnetDepth = 0.8;
tollerance = 0.3;

motorCoverLength = 3;
transmissionCoverLength = 9;
transmissionWidth = 12.4;
transmissionHeight = 10.6;
mainBodyWidth = 21;
mainBodyDepth = 17;
bodyCornerRound = 0;
motorDiameter = 12.8;
motorFix = 10.2;
gearCoverLength = 25;
gearHousingDiameter = 14;
gearDiameter = 11;
gearLength = 14;
gearTeethLength = 7.8;
gearBite = 0.75;
filamentWidth = 1.75;
bearingOD = 11.8;
bearingID = 6;
bearingHeight = 3.8;
screwLength = 20;
screwDia = 3.4;

encShaftLength = 35.2;
encShaftDia = 2.1;

bearingMiddle = gearLength - gearTeethLength / 2;
}
/* ACTUAL PART */

    *magnetHolder();
    *encoderWheel();
    bodyPart();
    *bodySupport();
    // bearing fillers
    translate([
        0, 
        gearDiameter / 2  + bearingOD / 2 + filamentWidth / 2 - gearBite,
        motorCoverLength + transmissionCoverLength + gearLength - gearTeethLength / 2
    ]) {
        translate([0, 0, -bearingHeight / 2])
            bearingFillFull();
        *translate([0, 0, bearingHeight / 2]) rotate([0, 180, 0])
            bearingFill();
    }
    
    *ballBearingDraw();
    
/* MODULES */
module ballBearingDraw() {
    translate([
        0, 
        gearDiameter / 2  + bearingOD / 2 + filamentWidth / 2 - gearBite,
        motorCoverLength + transmissionCoverLength + gearLength - gearTeethLength / 2
    ]) ballBearing();
}
module bodyPart() {
    motorEnclosure();
    translate([0, 0, motorCoverLength])
        transmissionEnclosure();
    translate([0, 0, motorCoverLength + transmissionCoverLength])
        !gearEnclosure();
}
module motorEnclosure() {
    difference() {
        translate([0,0, motorCoverLength / 2])
            roundedCube(
                [mainBodyWidth, mainBodyDepth, motorCoverLength],
                bodyCornerRound
            );
        // motor sized cylinder
        translate([0,0,motorCoverLength / 2]) color([1,1,1])
            cylinder(r = motorDiameter / 2, h=motorCoverLength + 1,
                center = true);
    }
    // motor shape adjustment
    translate([
        0,
        motorFix / 2 + (motorDiameter - motorFix) / 4,
        motorCoverLength / 2]
    )
        cube(
            [motorDiameter,
            (motorDiameter - motorFix) / 2,
            motorCoverLength],
            center = true
        );
    translate([
        0,
        - motorFix / 2 - (motorDiameter - motorFix) / 4,
        motorCoverLength / 2]
    )
        cube(
            [motorDiameter,
            (motorDiameter - motorFix) / 2,
            motorCoverLength],
            center = true
        );
}
module transmissionEnclosure() {
    difference() {
        union() {
            translate([0,0, transmissionCoverLength / 2])
                roundedCube(
                    [mainBodyWidth,
                    mainBodyDepth,
                    transmissionCoverLength],
                    bodyCornerRound);
            translate([0, mainBodyDepth / 2, 0]) 
                cylinder(r = mainBodyWidth/ 2, h = transmissionCoverLength, center = false);
        }
        translate([0,0, transmissionCoverLength / 2])
            color([1,1,1])
                cube([transmissionWidth,transmissionHeight, transmissionCoverLength + 1], center = true);    
        translate([0, gearDiameter / 2  + bearingOD / 2 + filamentWidth * 3 / 4 - gearBite,  transmissionCoverLength / 2])
            cylinder(r = screwDia + .2, h = transmissionCoverLength + 1, center = true, $fn = 6);

    }


}


module gearEnclosure() {
    color([1, 1, 1]) {
    difference() {
        union() {
            translate([0, 0, gearCoverLength / 2])
            roundedCube(
                [mainBodyWidth,
                mainBodyDepth,
                gearCoverLength],
                bodyCornerRound);
                translate([0, mainBodyDepth / 2, gearCoverLength / 2]) 
                    cylinder(r = mainBodyWidth/ 2, h = gearCoverLength, center = true);
                    //cylinder(r = mainBodyDepth * .75 / 2, h = gearCoverLength, center = true);
        }
        // inner hole for transmission and gear
        translate([0, 0, gearCoverLength / 2]) {
            cylinder(
                r = gearHousingDiameter / 2, 
                h = gearCoverLength + 1, 
                center = true
            );
            cube([transmissionWidth, transmissionHeight, gearCoverLength + 1], center = true);
        }
        filamentTube();
        // cutout for ball bearing
        translate([0, gearDiameter, bearingMiddle]) 
            cube([bearingOD + 2, bearingOD + 10, bearingHeight * 2], center = true);
        translate([0, mainBodyDepth, bearingMiddle]) 
            cube([mainBodyWidth, mainBodyDepth, bearingHeight * 2], center = true);

        // screw hole
        translate([0, gearDiameter / 2  + bearingOD / 2 + filamentWidth * 3 / 4 - gearBite, gearCoverLength / 2])
        cylinder(r = screwDia / 2, h = gearCoverLength, center = true);
        // nut hole
        translate([0, gearDiameter / 2  + bearingOD / 2 + filamentWidth * 3 / 4 - gearBite,  gearLength - gearTeethLength / 2 - bearingHeight - 4])
        rotate([0,180,0])
        cylinder(r = screwDia + .2, h = gearCoverLength, center = false, $fn = 6);
        // screw head hole
        translate([0, gearDiameter / 2  + bearingOD / 2 + filamentWidth * 3 / 4 - gearBite,  gearLength - gearTeethLength / 2 + bearingHeight + 4])
        cylinder(r = screwDia + .2, h = gearCoverLength, center = false);
        
        // encoder shaft
        translate([
            0, 
            gearDiameter / 2  + bearingOD / 2 + filamentWidth / 2 - gearBite,
            encShaftLength - 1
        ])
        translate([bearingOD / 2 + encShaftDia / 2, 0, 0]) rotate([180, 0, 0]) encoder();
    }

    }
}

module filamentTube() {
    translate([
        0, 
        gearDiameter / 2 - gearBite, 
        gearLength - gearTeethLength / 2
    ])
        rotate([0, 90, 0])
        color([1, 1, 1])
    cylinder(
        r = filamentWidth / 2 + 0.5,
        h = mainBodyWidth + 1,
        center = true
    );
}
module roundedCube(size, radius) {
	x = size[0];
	y = size[1];
	z = size[2];
    
    translate([0, 0, -z / 2])
	linear_extrude(height=z)
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius), (-y/2)+(radius), 0])
            circle(r=radius);
		translate([(x/2)-(radius), (-y/2)+(radius), 0])
            circle(r=radius);
		translate([(-x/2)+(radius), (y/2)-(radius), 0])
            circle(r=radius);
		translate([(x/2)-(radius), (y/2)-(radius), 0])
            circle(r=radius);
            square([x - 2 * radius, y], center = true);
            square([x, y - 2 * radius], center = true);
	}
}
module ballBearing() {
        difference() {
            cylinder(r = bearingOD / 2, h = bearingHeight, center = true);
            cylinder(r = bearingID / 2, h = bearingHeight + 1, center = true);
        }
}
module screw() {
    cylinder(r = screwDia / 2, h = screwLength, center = true);
    translate([0, 0, screwLength / 2 + screwDia / 4])
        cylinder(r = screwDia, h = screwDia / 2, center = true);
}
module nut() {
    difference() {
        cylinder(r = screwDia, h = screwDia * 0.8, center = true, $fn = 6);
        cylinder(r = screwDia / 2, h = screwDia * 0.8 + 1, center = true);
    }
}
module nutHole() {
    cylinder(r = screwDia / 2 + .4, h = mainBodyWidth * 2, center = true);
    translate([screwDia * 3.8, 0, -gearHousingDiameter / 2 + screwDia])
        cube([ screwDia * 10, screwDia * 11 / 6 + 1, 0.8 * screwDia], center = true);
}
module motorAssembly() {
    motorSize = 15.3;
    difference() {
        cylinder(r = motorDiameter / 2, h = motorSize, center = true);
        translate([0, motorDiameter / 2, 0])
        cube([motorDiameter, (motorDiameter - motorFix), 16], center = true);
        translate([0, -motorDiameter / 2, 0])
        cube([motorDiameter, (motorDiameter - motorFix), 16], center = true);
    }
    translate([0, 0, motorSize / 2 + transmissionCoverLength / 2])
    cube([transmissionWidth, transmissionHeight, transmissionCoverLength], center = true);

    translate([0, 0, motorSize / 2 + transmissionCoverLength + gearLength / 2]) {
        cylinder(r = gearDiameter / 2 - 1.5, h = gearLength - 5, center = true);
        translate([0, 0, gearLength / 2 - gearTeethLength / 2])
        cylinder(r = gearDiameter / 2, h = gearTeethLength, center = true);
        cylinder(r = 1.5, h = gearLength, center = true);
    }
}
module bearingFill() {
    color([1, 0, 0])
    translate([0, 0, -bearingHeight * .25])
    difference() {
        union() {
        translate([0,0,bearingHeight * .45])
            cylinder(r = bearingID / 2, h = bearingHeight * .4, center = true);
        cylinder(r = bearingID / 2 + 1, h = bearingHeight * .5, center = true);
        }
        cylinder(r = screwDia / 2 + .2, h = bearingHeight * 2, center = true);
    }
}
module bearingFillFull() {
    color([1, 0, 0])
    translate([0, 0, -bearingHeight * .25])
    difference() {
        union() {
        translate([0,0,bearingHeight * .45])
            cylinder(r = bearingID / 2, h = bearingHeight, center = true);
        cylinder(r = bearingID / 2 + 1, h = bearingHeight * .5, center = true);
        }
        cylinder(r = screwDia / 2 + .2, h = bearingHeight * 2, center = true);
    }
}
module bodySupport() {
    translate([
            0, 
            mainBodyDepth / 2,
            motorCoverLength + transmissionCoverLength + gearLength - gearTeethLength / 2
    ]) {
        difference() {
            cylinder(r = mainBodyDepth * .75 / 2, h = bearingHeight * 2, center = true);
            cylinder(r = mainBodyDepth * .75 / 2 - .7, h = bearingHeight * 2 + 1, center = true);
            translate([0, -mainBodyDepth / 2, 0]) cube([mainBodyDepth * .75 + 1, mainBodyDepth, bearingHeight * 2 + 1], center = true);
        }
    }
    translate([
        0, 
        gearDiameter / 2  + bearingOD / 2 + filamentWidth * 3 / 4 - gearBite,
        motorCoverLength + transmissionCoverLength + gearLength - gearTeethLength / 2
    ]) difference() {
        cylinder(r = screwDia / 2 + .8, h = bearingHeight * 2, center = true);
        cylinder(r = screwDia / 2, h = bearingHeight * 2 + 1, center = true);
    }
}

module encoderWheel() {
    color([1, 1, 0]) translate([0,0,.6]) difference() {
        union() {
            linear_extrude(height = 1.2, center = true, convexity = 10) {
            circle(r = 11.5, center = true);
            for(i = [0:6:360 - 6])
                rotate([0,0,i]) polygon([[0,0],[14.325,0],[14.325,1]]);
            }
            translate([0, 0, 2]) cylinder(r = 4, h = 4, center = true);
        }
        cylinder(r = encShaftDia / 2, h=10, center = true);
    }
}
module encoderShaft() {
    color([1,0,0]) translate([0, 0, encShaftLength / 2]) cylinder(r = encShaftDia / 2, h = encShaftLength, center = true);
}

module encoder() {
    encoderShaft();
    encoderWheel();
}

module magnetHolder() {
    difference() {
        cylinder(center = false, r = bearingDia / 2 - tollerance, h = screwHeadDepth + tollerance);
        translate([0, 0, -tollerance])
            cylinder(center = false, r = screwHeadDia / 2 + tollerance, h = screwHeadDepth * 2);
    }

    translate([0, 0, screwHeadDepth + tollerance])
        difference() {
            cylinder(center = false, r = bearingDia / 2 - tollerance, h = screwHeadDepth + tollerance);
            translate([0, 0, screwHeadDepth + tollerance  - magnetDepth])
                cylinder(center = false, r = magnetDia / 2 + tollerance, h = magnetDepth + tollerance);
        }
}

// end of modules


