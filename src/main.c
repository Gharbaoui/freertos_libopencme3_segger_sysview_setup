#include <FreeRTOS.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>
#include <task.h>
#include "SEGGER_SYSVIEW.h"
#include "SEGGER_RTT.h"


static void task1(void *args __attribute((unused))) {
  for (;;) {
    gpio_toggle(GPIOA, GPIO5);
    vTaskDelay(pdMS_TO_TICKS(1500));
  }
}
static void task2(void *args __attribute((unused))) {
  for (;;) {
    gpio_toggle(GPIOA, GPIO6);
    SEGGER_RTT_printf(0, "TASK-2");
    vTaskDelay(pdMS_TO_TICKS(1500));
  }
}

void system_setup(void);

int main(void) {
  SEGGER_SYSVIEW_Conf();
  rcc_clock_setup_pll(&rcc_hse_16mhz_3v3[RCC_CLOCK_3V3_180MHZ]);

  system_setup();
  xTaskCreate(task1, "Task1", 100, (void *)(configMAX_PRIORITIES - 1), 1,
              NULL);
  xTaskCreate(task2, "Task2", 100, (void *)(configMAX_PRIORITIES - 1), 1,
              NULL);

  vTaskStartScheduler();

  while (1) {
    __asm("nop");
  }
}
