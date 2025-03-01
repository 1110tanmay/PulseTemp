import java.util.LinkedList;
import java.util.Queue;

public class ECTempCalculator {

    // Constants for Sigmoid Function - Sigmoid function gives a presised output over the qudratic function.
    private static final double minCore = 36.5;  // Minimum Core Temperature
    private static final double maxCore = 40.0;  // Maximum Core Temperature
    private static final double sigGrowthRate = 0.05;  // Sigmoid Growth Rate
    private static final double midSigmoid = 37.0;  // Midpoint (Baseline CT)
    private static final double factorSigmoid = 1.5;   // Sigmoid Shape Factor
    private static final double sharpnessSigmoid = 2.0;   // Sigmoid Curve Sharpness

    // Kalman Filter Variables
    private double estimatedCT = 37.0;  // Initial core temperature
    private double variance = 0.02;  // Initial variance
    private Queue<Double> hrObservations = new LinkedList<>();  // Store past HR values

    /**
     * Sigmoid function mapping HR to Core Temperature (CT)
     */
    private double sigmoidFunction(double heartRate) {
        return minCore + ((maxCore - minCore) / (1 + factorSigmoid * Math.exp(-sigGrowthRate * (estimatedCT - midSigmoid))));
    }

    /**
     * Updates core temperature using Kalman Filtering
     * @param heartRate - New heart rate measurement
     * @return Updated core body temperature estimate
     */
    public double updateCoreTemp(double heartRate) {
        // Apply Sigmoid function
        double predictedCT = sigmoidFunction(heartRate);

        // Kalman Gain Calculation
        double kalmanGain = variance / (variance + 0.02); // 0.02 is assumed sensor noise variance

        // Update Estimate
        estimatedCT = estimatedCT + kalmanGain * (predictedCT - estimatedCT);

        // Update Variance
        variance = (1 - kalmanGain) * variance;

        // Store HR for trend analysis
        hrObservations.add(heartRate);
        if (hrObservations.size() > 60) { // Keep last 60 observations (1 hour of data)
            hrObservations.poll();
        }

        return estimatedCT;
    }

    // Test Function
    public static void main(String[] args) {
        ECTempCalculator ecTemp = new ECTempCalculator();

        // Simulated HR values (Dynamic Testing)
        double[] heartRates = {72, 78, 85, 90, 95, 100, 110, 120};

        for (double hr : heartRates) {
            double temp = ecTemp.updateCoreTemp(hr);
            System.out.println("HR: " + hr + " BPM → Estimated Core Temperature: " + temp + "°C");
        }
    }
}
