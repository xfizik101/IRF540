#include <avr/io.h>
#include <util/delay.h>

#define F_CPU 16000000UL
#define LED_PIN PB1
#define BUTTON1_PIN PD2
#define BUTTON2_PIN PD3

void setup() {
    DDRB |= (1 << LED_PIN);
    DDRD &= ~((1 << BUTTON1_PIN) | (1 << BUTTON2_PIN));
    PORTD |= (1 << BUTTON1_PIN) | (1 << BUTTON2_PIN);
    TCCR1A = (1 << WGM10) | (1 << WGM12) | (1 << COM1A1);
    TCCR1B = (1 << WGM12) | (1 << CS10);
    OCR1A = 0;
}

void setPWM(uint8_t brightness) {
    if (brightness > 255) {
        brightness = 255;
    }
    OCR1A = brightness;
}

int main(void) {
    setup();

    uint8_t brightness = 0;

    while (1) {
        if (!(PIND & (1 << BUTTON1_PIN))) {
            if (brightness < 255) {
                brightness += 1;
                setPWM(brightness);
            }
            _delay_ms(100);
        }
        if (!(PIND & (1 << BUTTON2_PIN))) {
            if (brightness > 0) {
                brightness -= 1;
                setPWM(brightness);
            }
            _delay_ms(100);
        }
    }
}
