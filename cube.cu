#include <iostream>
#include <stdlib.h>

__global__ void cube(int *d_in, int *d_out) {
  int idx = threadIdx.x;
  d_out[idx] = d_in[idx] * d_in[idx] * d_in[idx];
}

int main() {
  const int ARRAY_SIZE = 128;

  // Allocate memory for arrays on host
  int *h_arr = new int[ARRAY_SIZE];

  // Initialize array on host
  for (int i = 0; i < ARRAY_SIZE; i++) {
    h_arr[i] = i;
  }

  // Allocate memory for array on device
  int *d_arr, *d_res;
  cudaMalloc(&d_arr, ARRAY_SIZE * sizeof(int));
  cudaMalloc(&d_res, ARRAY_SIZE * sizeof(int));

  // Copy array from host to device
  cudaMemcpy(d_arr, h_arr, ARRAY_SIZE * sizeof(int), cudaMemcpyHostToDevice);

  // Launch the kernel
  cube<<<1, ARRAY_SIZE>>>(d_arr, d_res);

  // Copy the result back to host
  cudaMemcpy(h_arr, d_res, ARRAY_SIZE * sizeof(int), cudaMemcpyDeviceToHost);

  // Print the result
  for (int i = 0; i < ARRAY_SIZE; i++) {
    std::cout << h_arr[i] << " ";
  }

  // Free the array on host and device
  cudaFree(d_arr);
  cudaFree(d_res);
  delete[] h_arr;

  return 0;
}