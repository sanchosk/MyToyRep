difference() {
    translate([-570,-20,0])
        import("ToyREP-Carriage.stl");
    translate([60,40,-5])
        cube([20,20,20]);
    color([1,0,0])
        translate([0,27,5])
            cube([50,7.5,15]);
}

translate([4,0,0]) difference() {
    translate([-570,-20,0])
        import("ToyREP-Carriage.stl");
    translate([-15,-40,-5]) cube([70,200,50]);
}

translate([6,0,0]) difference() {
    translate([-570,-20,0])
        import("ToyREP-Carriage.stl");
    translate([-15,-40,-5]) cube([70,200,50]);
}


!cube([50,45,30]);