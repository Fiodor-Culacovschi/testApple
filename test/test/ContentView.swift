import SwiftUI



struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "fork.knife")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Welcome to Food Finder!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                NavigationLink(destination: SignupView()) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: SigninView()) {
                    Text("Sign In")
                        .foregroundColor(.blue)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                .padding()
            }
            .navigationTitle("Welcome")
            .padding()
        }
    }
}

struct SignupView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age: String = ""
    @State private var email: String = ""
    @State private var isSignupComplete = false
    @State private var isAgeValid = true

    var isFormValid: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && isAgeValid && !email.isEmpty
    }

    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Age", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
                .background(isAgeValid ? Color.white : Color.red.opacity(0.3))
                .onChange(of: age) { newValue in
                    if let ageInt = Int(newValue), ageInt < 16 {
                        isAgeValid = false
                    } else {
                        isAgeValid = true
                    }
                }

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!isAgeValid)

            Button(action: {
                if isFormValid {
                    isSignupComplete = true
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .padding()

            if isSignupComplete {
                Text("Profile created successfully. Check your email for confirmation.")
                    .foregroundColor(.green)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Sign Up")
        .padding()
    }
}

struct SigninView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSignedIn = false

    var isFormValid: Bool {
        return !username.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if isFormValid {
                    // Perform sign-in logic (authentication)
                    isSignedIn = true
                }
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .padding()

            if isSignedIn {
                NavigationLink(destination: PreferencesView()) {
                    Text("Go to Preferences")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }

            Spacer()
        }
        .navigationTitle("Sign In")
        .padding()
    }
}

struct PreferencesView: View {
    @State private var budget: Double = 0
    @State private var cuisineType: String = ""
    @State private var selectedAllergy = ""
    @State private var isFoodNearby = false
    
    let allergies = ["Gluten", "Dairy", "Eggs", "Soy", "Shellfish", "Peanuts", "Tree Nuts", "Fish"]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Preferences").foregroundColor(.blue)) {
                    Stepper("Budget: $\(String(format: "%.2f", budget))", value: $budget, in: 0...100, step: 5)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    TextField("Cuisine Type", text: $cuisineType)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    Picker("Allergies", selection: $selectedAllergy) {
                        ForEach(allergies, id: \.self) { allergy in
                            Text(allergy)
                                
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Button(action: {
                    isFoodNearby = true
                }) {
                    Text("Food Near Me")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }

            if isFoodNearby {
                // Code to show nearby food places goes here
            }
        }
        .navigationTitle("Preferences")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
