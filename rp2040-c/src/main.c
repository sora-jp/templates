#include "pico/stdio.h"
#include "pico/time.h"
#include "pico/printf.h"

int main() {
    stdio_init_all();

    while (1) {
        printf("Hello, world!\n");
        sleep_ms(1000);
    }
}
