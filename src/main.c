#include "main.h"

static void wait(long unsigned int cycles){
    for(long unsigned int i = 0; i < cycles; i++){
        __asm__("nop");
    }
}

int main() {
  // Setup clock to enable GPIOA
  *((volatile unsigned int *) (RCC_BASE + RCC_AHB1ENR)) |= GPIOAEN;
  
  //Configure GPIOA pin 5 as output
  *((volatile unsigned int *) (GPIOA_MODER)) &= ~(0x3 << (5*2)); //clear pin 5 moder
  *((volatile unsigned int *) (GPIOA_MODER)) |=  (0x1 << (5*2)); //set pin 5 moder to output 
  
  // Toggle pin 5
  while (1) {
    // Turn LED ON
    *((volatile unsigned int *) (GPIOA_ODR)) |= (0x1 << 5);
    wait(16000000 / 16);

    // Turn LED OFF
    *((volatile unsigned int *) (GPIOA_ODR)) &= (0x0 << 5);
    wait(16000000 / 16);
  }
  return 0;
}