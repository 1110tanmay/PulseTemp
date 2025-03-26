import React from "react";
import { View, Text, StyleSheet, ScrollView } from "react-native";

const HomeScreen = () => {
  // Mock Data (to be replaced with real HealthKit data)
  const mockData = {
    heartRate: 85, // BPM
    temperature: 98.6, // °F
    steps: 5000, // Steps taken
    caloriesBurned: 300, // Calories burned
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>PulseTemp Dashboard</Text>

      <View style={styles.card}>
        <Text style={styles.label}>Heart Rate</Text>
        <Text style={styles.value}>{mockData.heartRate} BPM</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.label}>Body Temperature</Text>
        <Text style={styles.value}>{mockData.temperature}°F</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.label}>Steps Taken</Text>
        <Text style={styles.value}>{mockData.steps} steps</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.label}>Calories Burned</Text>
        <Text style={styles.value}>{mockData.caloriesBurned} kcal</Text>
      </View>
    </ScrollView>
  );
};

// 🎨 Basic Styling
const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    alignItems: "center",
    justifyContent: "center",
    padding: 20,
    backgroundColor: "#f5f5f5",
  },
  title: {
    fontSize: 22,
    fontWeight: "bold",
    marginBottom: 20,
    color: "#333",
  },
  card: {
    width: "90%",
    backgroundColor: "#fff",
    padding: 20,
    borderRadius: 10,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 5,
    marginVertical: 10,
    alignItems: "center",
  },
  label: {
    fontSize: 18,
    color: "#666",
    marginBottom: 5,
  },
  value: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#333",
  },
});

export default HomeScreen;
