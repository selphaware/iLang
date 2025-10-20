// predictor.cpp
#include <iostream>
#include <vector>
#include <cstdlib>
#include "model_generated.h"

int main(int argc, char** argv) {
    std::vector<double> x(MODEL_N_FEATURES, 0.0);

    if (argc == 1 + (int)MODEL_N_FEATURES) {
        for (size_t i = 0; i < x.size(); ++i) x[i] = std::atof(argv[1 + i]);
    } else if (argc != 1) {
        std::cerr << "Usage: " << argv[0] << " <v1> <v2> ... <v" << MODEL_N_FEATURES << ">\n";
        std::cerr << "No args -> defaults to zeros.\n";
    }

    double yhat = score(x.data());
    std::cout << "Prediction = " << yhat << "\n";
    return 0;
}
