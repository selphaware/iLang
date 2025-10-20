#ifndef MODEL_GENERATED_H
#define MODEL_GENERATED_H

#ifdef __cplusplus
extern "C" {
#endif

// Number of input features the model expects (your lag count)
#define MODEL_N_FEATURES 12

// Predict one step. Input must be an array of length MODEL_N_FEATURES,
// ordered from oldest lag to most recent lag (same order used in training).
double score(const double *input);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // MODEL_GENERATED_H
