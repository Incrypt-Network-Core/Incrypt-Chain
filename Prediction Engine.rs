// src/models/prediction_engine.rs

use nalgebra::{Vector3, Vector2, Point3};
use rand::distributions::Uniform;
use rand::{thread_rng, Rng};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
struct ModelInput {
    features: Vec<f64>,
}

#[derive(Debug, Deserialize, Serialize)]
struct ModelOutput {
    classification: i32,
    probability: f64,
}

pub struct PredictionEngine {
    rng: Rng,
    classification_weights: Vector2<f64>,
}

impl PredictionEngine {
    pub fn new() -> PredictionEngine {
        let mut rng = thread_rng();
        let classification_weights = Vector2::new(
            rng.gen_range(0.0..=1.0),
            rng.gen_range(0.0..=1.0),
        );

        PredictionEngine { rng, classification_weights }
    }

    pub fn predict(&mut self, input: ModelInput) -> ModelOutput {
        let dot_product: f64 = input
            .features
            .iter()
            .zip(&self.classification_weights.coords)
            .map(|(&feature, weight)| feature * weight)
            .sum();

        let classification = if dot_product > 0.0 {
            1
        } else {
            -1
        };

        let probability = self.sigmoid(dot_product as f64).round() as i32;

        ModelOutput {
            classification,
            probability,
        }
    }

    fn sigmoid(&self, x: f64) -> f64 {
        1.0 / (1.0 + (-x).exp())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_prediction_engine() {
        let mut engine = PredictionEngine::new();
        let input = ModelInput {
            features: vec![1.0, 2.0],
        };

        // Positive and negative examples
        let positive_results = vec![