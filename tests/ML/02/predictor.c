// predictor.c
#include <stdio.h>
#include <stdlib.h>
#include "model_generated.h"

int main(int argc, char **argv) {
    // If you pass values on the CLI, we use them; otherwise demo with zeros.
    double x[MODEL_N_FEATURES] = {0};

    if (argc == 1 + MODEL_N_FEATURES) {
        for (int i = 0; i < MODEL_N_FEATURES; ++i) x[i] = atof(argv[1 + i]);
    } else if (argc != 1) {
        fprintf(stderr, "Usage: %s <v1> <v2> ... <v%u>\n", argv[0], (unsigned)MODEL_N_FEATURES);
        fprintf(stderr, "No args -> defaults to zeros.\n");
    }

    double yhat = score(x);
    printf("Prediction = %.6f\n", yhat);
    return 0;
}
