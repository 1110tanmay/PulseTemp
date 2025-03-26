import React, { useState } from "react";
import { View, Text, TextInput, Button, StyleSheet, Switch } from "react-native";

const ProfileScreen = () => {
  const [name, setName] = useState("");
  const [age, setAge] = useState("");
  const [gender, setGender] = useState("");
  const [height, setHeight] = useState("");
  const [weight, setWeight] = useState("");
  const [isFahrenheit, setIsFahrenheit] = useState(true);
  const [notificationsEnabled, setNotificationsEnabled] = useState(false);

  const saveProfile = () => {
    alert("Profile Saved!"); // Later, we'll save this data persistently
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Profile</Text>

      <Text style={styles.label}>👤 Name</Text>
      <TextInput style={styles.input} value={name} onChangeText={setName} placeholder="Enter your name" />

      <Text style={styles.label}>🎂 Age</Text>
      <TextInput style={styles.input} value={age} onChangeText={setAge} keyboardType="numeric" placeholder="Enter your age" />

      <Text style={styles.label}>⚧ Gender</Text>
      <TextInput style={styles.input} value={gender} onChangeText={setGender} placeholder="Male / Female / Other" />

      <Text style={styles.label}>📏 Height (cm)</Text>
      <TextInput style={styles.input} value={height} onChangeText={setHeight} keyboardType="numeric" placeholder="Enter height" />

      <Text style={styles.label}>⚖️ Weight (kg)</Text>
      <TextInput style={styles.input} value={weight} onChangeText={setWeight} keyboardType="numeric" placeholder="Enter weight" />

      <View style={styles.switchContainer}>
        <Text style={styles.label}>🌡 Temperature Unit (°F / °C)</Text>
        <Switch value={isFahrenheit} onValueChange={setIsFahrenheit} />
      </View>

      <View style={styles.switchContainer}>
        <Text style={styles.label}>🔔 Notifications</Text>
        <Switch value={notificationsEnabled} onValueChange={setNotificationsEnabled} />
      </View>

      <Button title="Save Profile" onPress={saveProfile} color="#4CAF50" />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    textAlign: "center",
    marginBottom: 20,
  },
  label: {
    fontSize: 16,
    marginTop: 10,
  },
  input: {
    backgroundColor: "#fff",
    padding: 10,
    borderRadius: 8,
    marginTop: 5,
    fontSize: 16,
  },
  switchContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginVertical: 10,
  },
});

export default ProfileScreen;
