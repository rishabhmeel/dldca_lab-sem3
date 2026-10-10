#include <algorithm>
#include <chrono>
#include <cstdio>
#include <numeric>
#include <random>
#include <vector>

const long STEP = 16;
const long READS = 1L << 23;

int main() {
    for (long kb = 4; kb <= 64 * 1024; kb *= 2) {
        long n = kb * 1024 / sizeof(int);
        long lines = n / STEP;

        std::vector<long> order(lines);
        std::iota(order.begin(), order.end(), 0);
        std::shuffle(order.begin(), order.end(), std::mt19937(42));

        std::vector<int> next(n);
        for (long k = 0; k < lines; k++)
            next[order[k] * STEP] = order[(k + 1) % lines] * STEP;

        /* ========================= YOUR CODE BELOW ========================= */

        // TODO: Warm-up - touch every element of the 'next' array once. Iterate from 0 to no. of lines

        // TODO: Start measuring time and then for READS no. of times, iterate through the array 

        // TODO: print in the given format (use std::printf)

        /* ========================= YOUR CODE ABOVE ========================= */
    }
}
