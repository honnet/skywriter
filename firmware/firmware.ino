#include <Wire.h>
#include <skywriter.h>

const int PIN_REST = 0;
const int PIN_TRFD = 1;


void setup() {
    pinMode(13, OUTPUT);
    Serial.begin(115200);
    while(!Serial){};

    Skywriter.begin(PIN_TRFD, PIN_REST);
    Skywriter.onXYZ(handle_xyz);
}

void loop() {
    Skywriter.poll();
}

void handle_xyz(unsigned int x, unsigned int y, unsigned int z){
    const int max_16bit = (1 << 16) - 1;

    if ( (x != 0 && y != 0)  &&  (x != max_16bit && y != max_16bit) ) {
        char buf[17];
        sprintf(buf, "%05u.%05u.%05u", x, y, z);
        Serial.println(buf);

        digitalWrite(13, !digitalRead(13));
    }
}

