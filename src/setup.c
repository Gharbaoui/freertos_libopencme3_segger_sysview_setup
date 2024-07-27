#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/cm3/nvic.h>
void system_setup(void);

void system_setup(void)
{
    rcc_periph_clock_enable(RCC_GPIOA);
    // rcc_periph_clock_enable(RCC_GPIOC);
    // gpio_mode_setup(GPIOC, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO13);
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, GPIO5 | GPIO6);
}