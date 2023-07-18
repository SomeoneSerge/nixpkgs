#include <cuda_runtime.h>
#include <vector>

#include <stdio.h>

static inline void check(cudaError_t err, const char *context) {
  if (err != cudaSuccess) {
    fprintf(stderr, "CUDA error at %s: %s\n", context, cudaGetErrorString(err));
    std::exit(EXIT_FAILURE);
  }
}

#define CHECK(x) check(x, #x)

__global__ void saxpy(int n, float a, float *x, float *y) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n)
    y[i] = a * x[i] + y[i];
}

int main(void) {
  setbuf(stderr, NULL);

  int rtVersion, driverVersion;
  CHECK(cudaRuntimeGetVersion(&rtVersion));
  CHECK(cudaDriverGetVersion(&driverVersion));

  fprintf(stderr, "Runtime version: %d\n", rtVersion);
  fprintf(stderr, "Driver version: %d\n", driverVersion);

  constexpr int N = 1 << 20;

  std::vector<float> xHost(N), yHost(N);
  for (int i = 0; i < N; i++) {
    xHost[i] = 1.0f;
    yHost[i] = 2.0f;
  }

  fflush(stderr);

  float *xDevice, *yDevice;
  CHECK(cudaMalloc(&xDevice, N * sizeof(float)));
  CHECK(cudaMalloc(&yDevice, N * sizeof(float)));

  CHECK(cudaMemcpy(xDevice, xHost.data(), N * sizeof(float),
                   cudaMemcpyHostToDevice));
  CHECK(cudaMemcpy(yDevice, yHost.data(), N * sizeof(float),
                   cudaMemcpyHostToDevice));

  saxpy<<<(N + 255) / 256, 256>>>(N, 2.0f, xDevice, yDevice);
  CHECK(cudaGetLastError());

  CHECK(cudaMemcpy(yHost.data(), yDevice, N * sizeof(float),
                   cudaMemcpyDeviceToHost));

  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = max(maxError, abs(yHost[i] - 4.0f));
  fprintf(stderr, "Max error: %f\n", maxError);

  CHECK(cudaFree(xDevice));
  CHECK(cudaFree(yDevice));
}
