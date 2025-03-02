import java.util.LinkedList;
import java.util.Queue;

public class ECTempCalculator {

    // Sigmoid function parameters (from Looney et al., 2018)
    private static final double A = 41;      // Minimum HR
    private static final double K = 152;     // Maximum HR
    private static final double Q = 0.06;    // Scaling factor
    private static final double beta = 0.89; // Growth rate
    private static final double M = 37.84;   // Midpoint CT
    private static final double v = 0.07;    // Shape parameter

    // Kalman Filter Variables
    private double estimatedCT = 37.0;  // Initial core temperature estimate
    private double variance = 0.02;     // Initial variance
    private Queue<Double> hrObservations = new LinkedList<>();  // Stores past HR values

    /**
     * Computes the predicted HR for a given CT using the sigmoid function.
     * @param ct - Core Temperature (°C)
     * @return Predicted Heart Rate (BPM)
     */
    private double predictedHR(double ct) {
        double numerator = K - A;
        double denominator = Math.pow(1 + Q * Math.exp(-beta * (ct - M)), 1 / v);
        return A + (numerator / denominator);
    }

    /**
     * Estimates Core Temperature (CT) from Heart Rate (HR) by inverting the sigmoid function.
     * @param heartRate - Current HR reading (BPM)
     * @return Estimated Core Temperature (°C)
     */
    private double computeCoreTemp(double heartRate) {
        // Ensure HR is within realistic limits
        if (heartRate < A || heartRate > K) {
            return estimatedCT; // Return last known CT if HR is out of range
        }

        // Invert the sigmoid function to estimate CT
        double term = Math.pow((K - A) / (heartRate - A), v) - 1;
        double logInput = term / Q;

        // Prevent log(0) or negative values (which would result in NaN)
        if (logInput <= 0) {
            System.out.println("⚠️ ERROR: logInput is non-positive! Returning previous CT.");
            return estimatedCT;
        }

        return M - (Math.log(logInput) / beta);
    }

    /**
     * Updates the core temperature estimate using the Kalman Filter.
     * @param heartRate - New heart rate measurement (BPM)
     * @return Smoothed Core Temperature Estimate (°C)
     */
    public double updateCoreTemp(double heartRate) {
        // Compute Core Temp from HR
        double computedCT = computeCoreTemp(heartRate);  

        // Time Update: Predict the next CT estimate
        double predictedCT = estimatedCT;  
        double predictedVariance = variance + 0.01;  // Increased uncertainty

        // Compute the derivative dynamically
        double predictedHRValue = predictedHR(predictedCT);
        double m = (-beta * (K - A) * v * Math.pow(Math.max(predictedHRValue - A, 1), -1 - v)) /
                   (Math.pow(1 + Q * Math.exp(-beta * (predictedCT - M)), 1 / v));

        // Prevent m from being too small
        if (Math.abs(m) < 1e-6) {
            m = 1e-6;  // Small nonzero value
        }

        // Kalman Gain Calculation (Clamp to [0.0001, 1])
        double kalmanGain = (predictedVariance * m) / (Math.pow(m, 2) * predictedVariance + 356.4544);
        kalmanGain = Math.max(0.0001, Math.min(1, kalmanGain));

        // Final Estimate: Update CT and variance
        estimatedCT = predictedCT + kalmanGain * (heartRate - predictedHRValue);
        variance = (1 - kalmanGain * m) * predictedVariance;

        // Store HR for trend analysis (optional)
        hrObservations.add(heartRate);
        if (hrObservations.size() > 60) { 
            hrObservations.poll();
        }

        // Debugging prints
        System.out.println("HR: " + heartRate + 
                           " | Computed CT: " + computedCT + 
                           " | Predicted CT: " + predictedCT + 
                           " | Kalman Gain: " + kalmanGain + 
                           " | HR Prediction: " + predictedHRValue +
                           " | Final CT: " + estimatedCT);
        
        return estimatedCT;
    }

    // Test Function
    public static void main(String[] args) {
        ECTempCalculator ecTemp = new ECTempCalculator();

        // Simulated HR values (Testing)
        double[] heartRates = {60, 80, 100, 120, 140};

        for (double hr : heartRates) {
            double temp = ecTemp.updateCoreTemp(hr);
            System.out.println("HR: " + hr + " BPM → Estimated Core Temperature: " + temp + "°C");
        }
    }
}
