// Addresses
#define PERIPH_BASE             0x40000000UL    /* Peripheral base address in the alias region */
#define AHB1PERIPH_BASE         (PERIPH_BASE + 0x00020000UL)

#define RCC_BASE                (AHB1PERIPH_BASE + 0x3800UL)
#define RCC_AHB1ENR             0x30UL            /* Register offset from base address*/
#define GPIOAEN                 0x01UL            /* Bit position for GPIOAEN  */

#define GPIOA_BASE              (AHB1PERIPH_BASE + 0x0000UL)
#define GPIOA_MODER             (GPIOA_BASE + 0x00UL)
#define GPIOA_PUPDR             (GPIOA_BASE + 0x0CUL)
#define GPIOA_ODR               (GPIOA_BASE + 0x14UL)
#define GPIO_PIN_5              (0x1UL << 5L)


