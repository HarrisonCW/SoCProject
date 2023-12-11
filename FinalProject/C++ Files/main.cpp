/*****************************************************************//**
 * @file main_sampler_test.cpp
 *
 * @brief Basic test of nexys4 ddr mmio cores
 *
 * @author p chu
 * @version v1.0: initial release
 *********************************************************************/

// #define _DEBUG
#include "chu_init.h"
#include "gpio_cores.h"
#include "sseg_core.h"
#include "spi_core.h"

/**
 * Test adxl362 accelerometer using SPI
 */

void gsensor_check(SpiCore *spi_p, GpoCore *led_p, float coords[3]) {
   const uint8_t RD_CMD = 0x0b;
   const uint8_t PART_ID_REG = 0x02;
   const uint8_t DATA_REG = 0x08;
   const float raw_max = 127.0 / 2.0;  //128 max 8-bit reading for +/-2g

   int8_t xraw, yraw, zraw;
   float x, y, z;
   int id;

   spi_p->set_freq(400000);
   spi_p->set_mode(0, 0);
   // check part id
   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(PART_ID_REG);  // part id address
   id = (int) spi_p->transfer(0x00);
   spi_p->deassert_ss(0);
   //uart.disp("read ADXL362 id (should be 0xf2): ");
   //uart.disp(id, 16);
   //uart.disp("\n\r");
   // read 8-bit x/y/z g values once
   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(DATA_REG);  //
   xraw = spi_p->transfer(0x00);
   yraw = spi_p->transfer(0x00);
   zraw = spi_p->transfer(0x00);
   spi_p->deassert_ss(0);
   x = (float) xraw / raw_max;
   y = (float) yraw / raw_max;
   z = (float) zraw / raw_max;

   coords[0] = x;
   coords[1] = y;
   coords[2] = z;

   //uart.disp("x/y/z axis g values: ");
   //uart.disp(x, 3);
   //uart.disp(" / ");
   //uart.disp(y, 3);
   //uart.disp(" / ");
   //uart.disp(z, 3);
   //uart.disp("\n\r");
}

GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));
PwmCore pwm(get_slot_addr(BRIDGE_BASE, S6_PWM));
SsegCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));
SpiCore spi(get_slot_addr(BRIDGE_BASE, S9_SPI));

void blinkLED(GpoCore *led_p, int ledPos){

	led_p->write(0, ledPos);
	sleep_ms(50);
	led_p->write(1, ledPos);
}

int main() {

	float coords[3];
	float x, y, z;
	int ledPrev;
	int ledPos = 8;

	const uint8_t LEFT[]  = {0xff, 0xff, 0xff, 0xff, 0x87, 0x8e, 0x86, 0xc7};
	const uint8_t RIGHT[] = {0xff, 0xff, 0xff, 0x87, 0x8b, 0x90, 0xf9, 0xcc};
	const uint8_t CENT[]  = {0xff, 0xff, 0xcc, 0x86, 0x87, 0xab, 0x86, 0xc6};
	const uint8_t OFF[]   = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
	const uint8_t STOP[]  = {0xff, 0xff, 0xff, 0xff, 0x8c, 0xa3, 0x87, 0x92};

	//initialize position and sseg display
	led.write(1, ledPos);
	sseg.write_8ptn((uint8_t*)OFF);

	while (1) {
		gsensor_check(&spi, &led, coords);

        uart.disp(coords[0], 3);
        uart.disp(", ");
        uart.disp(coords[1], 3);
        uart.disp(", ");
        uart.disp(coords[2], 3);
        uart.disp("\n\r");

        x = coords[0];
        y = coords[1];
        z = coords[2];


        //Checking Tilt
        if(y < -0.05){
        	if(ledPos == 0){
        		sseg.write_8ptn((uint8_t*)STOP);
        		blinkLED(&led, ledPos);
        	}
        	else
        	{
        		ledPrev = ledPos;
        		ledPos--; //shift LED right

        		sseg.write_8ptn((uint8_t*)RIGHT);
        	}
        }
        else if(y > 0.05){
        	if(ledPos == 15){
        		sseg.write_8ptn((uint8_t*)STOP);
        		blinkLED(&led, ledPos);
        	}
        	else
        	{
        		ledPrev = ledPos;
        		ledPos++; //shift LED left

        		sseg.write_8ptn((uint8_t*)LEFT);
        	}
        }
        else if(ledPos == 7 || ledPos == 8){
        	sseg.write_8ptn((uint8_t*)CENT);
        }
        else{
        	sseg.write_8ptn((uint8_t*)OFF);
        }
        led.write(0, ledPrev);
        led.write(1, ledPos);






        sleep_ms(100);
    }
}






