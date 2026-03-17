{ stdenv, fetchFromGitHub, cmake, pkg-config, rocmPackages, python3, openblas, curl }:

stdenv.mkDerivation rec {
  pname = "llama-cpp";
  version = "b6912";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = version;
    hash = "sha256-cEBSOhnzWPZ85TWNks6L+IigSSAwi1lJiXaRYtFdV+k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocm-smi
    # rocmPackages.rocwmma
    openblas
    curl
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGGML_HIP=ON"    # "-DGGML_HIP_ROCWMMA_FATTN=ON"

    "-DGPU_TARGETS=gfx1100"
    # "-DGGML_HIP_ROCWMMA_FATTN=ON"
    "-DGGML_HIPBLAS=ON"
    "-DLLAMA_BUILD_SERVER=ON"
    "-DLLAMA_BUILD_COMMON=ON"
    "-DLLAMA_BLAS=ON"
    "-DLLAMA_BLAS_VENDOR=OpenBLAS"
  ];

  # Set ROCm environment variables
  env = {
    ROCM_PATH = rocmPackages.clr;
  };

  meta = {
    description = "Port of Facebook's LLaMA model in C/C++";
    homepage = "https://github.com/ggerganov/llama.cpp";
    license = "mit";
    platforms = [ "x86_64-linux" ];
  };
}
