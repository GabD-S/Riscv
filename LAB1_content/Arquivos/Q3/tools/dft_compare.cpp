#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>

struct C64 { double r, i; };
struct C32 { float r, i; };

static inline C64 dft_k_ref(const std::vector<double>& x, int k) {
    const int N = (int)x.size();
    const double TWO_PI = 6.28318530717958647692;
    double sumR = 0.0, sumI = 0.0;
    for (int n = 0; n < N; ++n) {
        double theta = TWO_PI * k * (double)n / (double)N;
        double c = std::cos(theta);
        double s = -std::sin(theta); // e^{-j*theta}
        sumR += x[n] * c;
        sumI += x[n] * s;
    }
    return {sumR, sumI};
}

static inline C32 dft_k_float_iter(const std::vector<float>& x, int k) {
    const int N = (int)x.size();
    const float TWO_PI = 6.28318530717958647692f;
    // step angle
    float theta = (float)((double)TWO_PI * (double)k / (double)N);
    float c0 = static_cast<float>(std::cos(static_cast<double>(theta)));
    float s0 = -static_cast<float>(std::sin(static_cast<double>(theta))); // e^{-j*theta}
    float c = 1.0f, s = 0.0f;
    float sumR = 0.0f, sumI = 0.0f;
    for (int n = 0; n < N; ++n) {
        float xn = x[n];
        sumR += xn * c;
        sumI += xn * s;
        // (c,s) *= (c0,s0)
        float nc = c * c0 - s * s0;
        float ns = c * s0 + s * c0;
        c = nc; s = ns;
    }
    return {sumR, sumI};
}

static inline std::vector<C64> dft_ref(const std::vector<double>& x) {
    const int N = (int)x.size();
    std::vector<C64> X(N);
    for (int k = 0; k < N; ++k) X[k] = dft_k_ref(x, k);
    return X;
}

static inline std::vector<C32> dft_float_iter(const std::vector<float>& x) {
    const int N = (int)x.size();
    std::vector<C32> X(N);
    for (int k = 0; k < N; ++k) X[k] = dft_k_float_iter(x, k);
    return X;
}

static inline double abs_err(double a, double b) { return std::abs(a - b); }

static void compare_and_print(const std::string& name, const std::vector<double>& xd) {
    std::vector<float> xf(xd.begin(), xd.end());

    auto Xref = dft_ref(xd);
    auto Xf   = dft_float_iter(xf);

    std::cout << "\n=== Sinal: " << name << " (N=" << xd.size() << ") ===\n";
    std::cout << std::left << std::setw(5) << "k"
              << std::right << std::setw(14) << "Re_ref"
              << std::setw(14) << "Im_ref"
              << std::setw(14) << "Re_f"
              << std::setw(14) << "Im_f"
              << std::setw(14) << "|dRe|"
              << std::setw(14) << "|dIm|" << "\n";
    for (int k = 0; k < (int)xd.size(); ++k) {
        double dRe = abs_err(Xref[k].r, (double)Xf[k].r);
        double dIm = abs_err(Xref[k].i, (double)Xf[k].i);
        std::cout << std::left << std::setw(5) << k
                  << std::right << std::setw(14) << std::fixed << std::setprecision(6) << Xref[k].r
                  << std::setw(14) << Xref[k].i
                  << std::setw(14) << (double)Xf[k].r
                  << std::setw(14) << (double)Xf[k].i
                  << std::setw(14) << dRe
                  << std::setw(14) << dIm << "\n";
    }
}

int main(int argc, char** argv) {
    // Base de dados N=8 (itens da 3.4 no relatório)
    std::vector<std::pair<std::string, std::vector<double>>> dataset;
    dataset.push_back({
        "x1",
        {1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    });
    dataset.push_back({
        "x2",
        {1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071}
    });
    dataset.push_back({
        "x3",
        {0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071}
    });
    dataset.push_back({
        "x4",
        {1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0}
    });

    // Execução e comparação: double (ref) vs float iterativo (mimetiza Assembly)
    for (const auto& item : dataset) {
        compare_and_print(item.first, item.second);
    }

    // Opcional: no futuro, poderíamos carregar resultados do Assembly via CSV para comparar aqui.
    if (argc == 2 && std::strcmp(argv[1], "--help") == 0) {
        std::cout << "Uso: ./dft_compare\n";
        std::cout << "    Executa comparacoes para x1..x4 usando DFT double (ref) e float (iterativo).\n";
    }
    return 0;
}
