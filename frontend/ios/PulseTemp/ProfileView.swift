import SwiftUI

struct ProfileView: View {
    @State private var name: String = "John Doe"
    @State private var age: String = "25"
    @State private var sex: String = "Male"
    @State private var weight: String = "70"
    @State private var height: String = "175"
    
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "°C"
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"
    
    @State private var isEditing: Bool = false // Toggle Edit Mode
    @State private var isDarkMode: Bool = false // Dark Mode Toggle
    @State private var isDataShared: Bool = false // Data Sharing
    
    let sexOptions = ["Male", "Female", "Other"]
    let tempUnits = ["°C", "°F"]
    let distanceUnits = ["km", "miles"]

    var body: some View {
        NavigationView {
            Form {
                // 📌 Personal Information Section
                Section(header: Text("Personal Information")) {
                    EditableField(label: "Name", value: $name)
                    EditableField(label: "Age", value: $age, keyboardType: .numberPad)
                    
                    // Sex Picker
                    Picker("Sex", selection: $sex) {
                        ForEach(sexOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    EditableField(label: "Weight (kg)", value: $weight, keyboardType: .numberPad)
                    EditableField(label: "Height (cm)", value: $height, keyboardType: .numberPad)
                }

                // 📌 Unit Preferences Section
                Section(header: Text("Unit Preferences")) {
                    Picker("Temperature Unit", selection: $temperatureUnit) {
                        ForEach(tempUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Picker("Distance Unit", selection: $distanceUnit) {
                        ForEach(distanceUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // 📌 Customization Section
                Section(header: Text("Customization")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    
                    Button(action: {
                        isDataShared.toggle()
                    }) {
                        Text(isDataShared ? "Data Shared for Research" : "Share My Data for Research")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        resetProfile()
                    }) {
                        Text("Reset Data")
                            .foregroundColor(.red)
                    }
                }

                // 📌 Save Button
                if isEditing {
                    Button(action: {
                        saveProfile()
                        isEditing = false
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                // Edit Button in Navigation Bar
                Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
    
    // 📌 Function to Save Changes
    func saveProfile() {
        print("Profile Saved: Name=\(name), Age=\(age), Sex=\(sex), Weight=\(weight), Height=\(height), TempUnit=\(temperatureUnit), DistanceUnit=\(distanceUnit), DarkMode=\(isDarkMode), DataShared=\(isDataShared)")
    }

    // 📌 Function to Reset Data
    func resetProfile() {
        name = "John Doe"
        age = "25"
        sex = "Male"
        weight = "70"
        height = "175"
        temperatureUnit = "°C"
        distanceUnit = "km"
        isDarkMode = false
        isDataShared = false
        print("Profile Reset to Defaults")
    }
}

// 📌 Reusable Editable Field Component
struct EditableField: View {
    let label: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            TextField(label, text: $value)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
        }
    }
}

// 📌 Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

