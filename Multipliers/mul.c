/* Programmed Multiplication - multiplication using adds and right shifts. */

#include <stdint.h>
#include <stdio.h>

void bitSerialMultiplyRightShift(uint8_t m_cand, uint8_t m_ier,
                                 uint8_t *p_high, uint8_t *p_low, int N)
{
    uint8_t Ra = m_cand;
    uint8_t Rx = m_ier;
    uint8_t Rp = 0;
    uint8_t Rq = 0;
    int Rc = N;
    uint16_t sum;


    while (Rc > 0) {
        uint8_t carry = Rx & 1;
        Rx >>= 1;
        if (carry)
            sum = Rp + Ra;
        else
            sum = Rp;
        uint8_t add_carry = (sum >> 8) & 1;
        uint16_t product = ((uint16_t)Rp << 8) | Rq;
        product |= (add_carry << 16);
        product >>= 1;

        Rp = (product >> 8) & 0xFF;
        Rq = product & 0xFF;

        Rc--;
    }

    *p_high = Rp;
    *p_low  = Rq;
}

// Example
int main(void) {
    uint8_t a = 13;
    uint8_t x = 11;
    uint8_t ph, pl;

    bitSerialMultiplyRightShift(a, x, &ph, &pl, 8);

    uint16_t product = ((uint16_t)ph << 8) | pl;
    printf("Product = %u (0x%04X)\n", product, product);
    return 0;
}