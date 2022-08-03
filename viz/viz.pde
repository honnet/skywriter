import processing.serial.*;

String receivedString = null;
Serial myPort;  // The serial port

float max16bit = pow(2, 16) - 1;
float[] xyz = {0,0,0};
float[] xyz_max = {0,0,0};
float[] xyz_min = {max16bit, max16bit, max16bit};
char[] sep = {'.', '.', '\n'};



void setup() {
    size(1280, 720);
    noStroke();

    // List all the available serial ports
    printArray(Serial.list());
    myPort = new Serial(this, Serial.list()[0], 11500);
    myPort.clear();
    // Throw out the first reading, in case we started reading
    // in the middle of a string from the sender.
    receivedString = myPort.readStringUntil('\n');
    receivedString = null;
    println("Starting");
}

void draw() {
    while (myPort.available() > 0) {

        for (int i = 0; i < 3; i++) {
            receivedString = myPort.readStringUntil(sep[i]);

            if (receivedString != null) {
              xyz[i] = Float.parseFloat(receivedString);
              xyz_min[i] = min(xyz[i], xyz_min[i]);
              xyz_max[i] = max(xyz[i], xyz_max[i]);
            }
        }
    }
    xyz[0] = map(xyz[0] ,  xyz_min[0], xyz_max[0] ,  0.0, float(width));
    xyz[1] = map(xyz[1] ,  xyz_min[1], xyz_max[1] ,  0.0, float(height));
    xyz[2] = map(xyz[2] ,  xyz_min[2], xyz_max[2] ,  0.1*height, 0.4*height);

    println(xyz[0], xyz[1], xyz[2]);

    background(0);
    ellipse(xyz[0], height-xyz[1], xyz[2], xyz[2]);
}

