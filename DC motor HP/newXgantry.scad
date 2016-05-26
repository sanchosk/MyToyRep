$fn = 60;
include <extruderEnclosure.scad>;

gantryXhole = 32;
gantryYhole = 32;
holeDia = 3;
bodyDepth = 4;
e3dOD = 16;
e3dID = 12;
e3dTopDepth = 3.9;
e3dBottomDepth = 5.5;
tolerance = 0.4;

filamentPosition = bodyDepth / 2 + mainBodyDepth / 2 + gearDiameter / 2 - gearBite;
e3dPos = - mainBodyWidth / 2;


// Main part
difference() {
    union() {
        roundedCube([gantryXhole + 4 * holeDia, gantryYhole + 4 * holeDia, bodyDepth], 4);
        //sideHolder();
        //topHolder();
        bottomHolder();
        color([0,0,1]) e3dCover();
    }
    translate([gantryXhole / 2, gantryYhole / 2]) cylinder(r = holeDia / 2 + tolerance, h = bodyDepth * 2, center = true);
    translate([-gantryXhole / 2, gantryYhole / 2]) cylinder(r = holeDia / 2 + tolerance, h = bodyDepth * 2, center = true);
    translate([-gantryXhole / 2, -gantryYhole / 2]) cylinder(r = holeDia / 2 + tolerance, h = bodyDepth * 2, center = true);
    translate([gantryXhole / 2, -gantryYhole / 2]) cylinder(r = holeDia / 2 + tolerance, h = bodyDepth * 2, center = true);
}

// extruder
translate([
    -motorCoverLength - transmissionCoverLength - gearLength + gearTeethLength / 2, 
    0,
    mainBodyDepth / 2 + bodyDepth / 2
    ]) rotate([90,0,90]) color([1, 0, 0, .5]) bodyPart();
// MODULES
module sideHolder() {
    translate([gearCoverLength - gearLength + gearTeethLength / 2, 0, mainBodyDepth / 2 + bodyDepth / 2]) rotate([0,270,0]) difference(){
        union() {
            cube([transmissionHeight, transmissionWidth, bodyDepth * 2], center = true);
            translate([-transmissionHeight / 2 - (mainBodyDepth - transmissionHeight) / 4,0,-bodyDepth / 2]) cube([(mainBodyDepth - transmissionHeight) / 2, transmissionWidth, bodyDepth], center = true);
        }
        cylinder(r = transmissionHeight / 2 - holeDia / 2, h = bodyDepth * 3, center = true);
    }
}

module topHolder() {
    difference() {
        translate([
            - gantryXhole / 2 + 2 * holeDia,
            mainBodyWidth / 2,
            bodyDepth / 2
        ]) cube([gantryXhole - 4 * holeDia, gantryYhole / 2 + 2 * holeDia - mainBodyWidth / 2, mainBodyDepth]);
        translate([
        0,
        mainBodyWidth / 2 - 1,
        filamentPosition
        ]) color([0,1,0]) rotate([90,0,180]) cylinder(r = filamentWidth * 2, h = gantryYhole / 2 + 2 * holeDia - mainBodyWidth / 2 + 2);
    }
}

module bottomHolder() {
    translate([
        0,
        e3dPos,
        filamentPosition
    ]) difference() {
        rotate([90, 0, 0]) rotate([90, 0, 0]) translate([-gantryXhole / 2 + holeDia, 0]) cube([gantryXhole - 2 * holeDia, e3dTopDepth + e3dBottomDepth, filamentPosition]);
        rotate([90, 0, 0]) translate([0, 0, -1]) cylinder(r = e3dOD / 2, h = e3dTopDepth + 1);
        rotate([90, 0, 0]) translate([0, 0, e3dTopDepth - 1]) cylinder(r = e3dID / 2, h = e3dBottomDepth + 2);
        translate([e3dID / 2 + holeDia, - e3dTopDepth - e3dBottomDepth / 2, 1]) {
            rotate([0,180,0]) cylinder(r = holeDia / 2 + tolerance, h = 100);
            translate([holeDia * 0.9 + tolerance, holeDia + tolerance, -holeDia * 3]) rotate([0,0,180]) cube([holeDia * 1.8 + 2  *tolerance, 100, holeDia * .8 + tolerance]);
        }
        translate([-e3dID / 2 - holeDia, - e3dTopDepth - e3dBottomDepth / 2, 1]) {
            rotate([0,180,0]) cylinder(r = holeDia / 2 + tolerance, h = 100);
            translate([holeDia * 0.9 + tolerance, holeDia + tolerance, -holeDia * 3]) rotate([0,0,180]) cube([holeDia * 1.8 + 2  *tolerance, 100, holeDia * .8 + tolerance]);
        }
    }
}
module e3dCover() {
    translate([
        0,
        e3dPos,
        filamentPosition
    ]) difference() {
        rotate([90, 180, 0]) rotate([90, 0, 0]) translate([-gantryXhole / 2 + holeDia, 0]) cube([gantryXhole - 2 * holeDia, e3dTopDepth + e3dBottomDepth, e3dOD / 2 + holeDia]);    
        rotate([90, 0, 0]) translate([0, 0, -1]) cylinder(r = e3dOD / 2, h = e3dTopDepth + 1);
        rotate([90, 0, 0]) translate([0, 0, e3dTopDepth - 1]) cylinder(r = e3dID / 2, h = e3dBottomDepth + 2);
        translate([e3dID / 2 + holeDia, - e3dTopDepth - e3dBottomDepth / 2, -1]) rotate([0,0,0]) cylinder(r = holeDia / 2 + tolerance, h = 100);
        translate([-e3dID / 2 - holeDia, - e3dTopDepth - e3dBottomDepth / 2, -1]) rotate([0,0,0]) cylinder(r = holeDia / 2 + tolerance, h = 100);
    }
}