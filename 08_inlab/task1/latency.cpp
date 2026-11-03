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
        int a;
        for(long k=0;k<n;k++)
            a=next[k];
        // TODO: Start measuring time and then for READS no. of times, iterate through the array 
        auto t0 =  std::chrono::steady_clock::now();
        long k=0;
        for(long i=0;i<READS;i++){
            k=next[k];
        }
        auto t1 =  std::chrono::steady_clock::now();
        double ns = std::chrono::duration<double,std::nano>(t1 - t0).count();
        // TODO: print in the given format (use std::printf)
        std::printf("%ld %.2f\n", kb, ns / READS);
        /* ========================= YOUR CODE ABOVE ========================= */
    }
}
