import SwiftUI

struct ContentView: View {
    @State private var isSidebarVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                WelcomeView()
                    .navigationBarItems(leading: Button(action: {
                        withAnimation {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .padding()
                    })
                
                if isSidebarVisible {
                    SidebarMenu(isSidebarVisible: $isSidebarVisible)
                        .transition(.move(edge: .leading))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SidebarMenu: View {
    @Binding var isSidebarVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: WelcomeView()) {
                Text("Home")
                    .padding()
            }
            
            NavigationLink(destination: SignupView()) {
                Text("Sign Up")
                    .padding()
            }
            
            NavigationLink(destination: SigninView()) {
                Text("Sign In")
                    .padding()
            }

            NavigationLink(destination: SettingsView()) {
                Text("Settings")
                    .padding()
            }
            
            NavigationLink(destination: MenuView()) {
                Text("Menu")
                    .padding()
            }

            NavigationLink(destination: CartView()) {
                Text("Cart")
                    .padding()
            }
            
            NavigationLink(destination: CheckoutView()) {
                Text("Checkout")
                    .padding()
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: 250, alignment: .leading)
        .gesture(DragGesture().onEnded { value in
            if value.translation.width < -50 {
                withAnimation {
                    isSidebarVisible = false
                }
            }
        })
    }
}

struct WelcomeView: View {
    var body: some View {
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

struct SignupView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age: String = ""
    @State private var email: String = ""
    @State private var isFormValid = false
    @State private var isAgeValid = true

    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: firstName) { _ in validateForm() }

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: lastName) { _ in validateForm() }

            TextField("Age", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
                .background(isAgeValid ? Color.white : Color.red.opacity(0.3))
                .onChange(of: age) { newValue in
                    validateAge(newValue)
                    validateForm()
                }

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!isAgeValid)
                .onChange(of: email) { _ in validateForm() }

            NavigationLink(destination: TermsAndConditionsView()) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(!isFormValid)

            Spacer()
        }
        .navigationTitle("Sign Up")
        .padding()
    }

    private func validateForm() {
        isFormValid = !firstName.isEmpty && !lastName.isEmpty && isAgeValid && !email.isEmpty
    }

    private func validateAge(_ age: String) {
        if let ageInt = Int(age), ageInt < 16 {
            isAgeValid = false
        } else {
            isAgeValid = true
        }
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

struct TermsAndConditionsView: View {
    @State private var isAgreed = false

    var body: some View {
        VStack {
            Text("Terms and Conditions")
                .font(.title)
                .padding()

            ScrollView {
                Text("Here are the terms and conditions...")
                    .padding()
            }

            Toggle("I agree to the terms and conditions", isOn: $isAgreed)
                .padding()

            NavigationLink(destination: PreferencesView(), isActive: $isAgreed) {
                EmptyView()
            }

            Button(action: {
                if isAgreed {
                    isAgreed = true
                }
            }) {
                Text("Agree")
                    .foregroundColor(.white)
                    .padding()
                    .background(isAgreed ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(!isAgreed)

            Spacer()
        }
        .navigationTitle("Terms and Conditions")
        .padding()
    }
}

struct SettingsView: View {
    @State private var location: String = "ORLANDO, FL"
    @State private var profileName: String = "Joe Dirt"
    @State private var fontSize: String = "Regular"
    @State private var allergies: String = "Peanuts"
    @State private var showingDeleteAlert = false

    let fontSizes = ["Small", "Regular", "Large"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Profile")) {
                        TextField("Location", text: $location)
                            .padding()
                        TextField("Profile Name", text: $profileName)
                            .padding()
                        Picker("Font size", selection: $fontSize) {
                            ForEach(fontSizes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        TextField("Allergies", text: $allergies)
                            .padding()
                    }

                    Section {
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Text("Delete Profile")
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("Delete Profile"),
                                message: Text("Are you sure you want to delete your profile? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Handle profile deletion here
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct MenuView: View {
    @State private var budget: Double = 0
    let menuItems = [
        ("Pizza", 8.99),
        ("Tacos", 7.99),
        ("Fries", 3.99),
        ("Dessert", 4.99),
        ("Soda", 1.99),
        ("Smoothie", 5.99),
        ("Salad", 6.99),
        ("Burger", 9.99)
    ]
    
    var filteredMenuItems: [(String, Double)] {
        menuItems.filter { $0.1 <= budget }
    }
    
    var body: some View {
        VStack {
            Text("Menu")
                .font(.largeTitle)
                .padding()
            
            VStack {
                Stepper("Budget: $\(String(format: "%.2f", budget))", value: $budget, in: 0...100, step: 5)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
            }
            .padding()
            
            List {
                ForEach(filteredMenuItems, id: \.0) { item in
                    NavigationLink(destination: MenuItemDetailView(itemName: item.0, itemPrice: item.1)) {
                        Text("\(item.0) - $\(String(format: "%.2f", item.1))")
                    }
                }
            }
        }
    }
}

struct MenuItemDetailView: View {
    var itemName: String
    var itemPrice: Double
    @State private var quantity: Int = 1
    @State private var allergies: String = ""
    @State private var isAddedToCart = false
    @State private var showActionSheet = false
    @State private var navigateToCheckout = false
    @State private var navigateToMenu = false
    
    var body: some View {
        VStack {
            Text(itemName)
                .font(.largeTitle)
                .padding()
            
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                .padding()
            
            TextField("Allergies", text: $allergies)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
            
            Button(action: {
                isAddedToCart = true
                showActionSheet = true
            }) {
                Text("Add to Cart - $\(String(format: "%.2f", itemPrice * Double(quantity)))")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Item Added to Cart"),
                    message: Text("\(quantity) x \(itemName) added to cart"),
                    buttons: [
                        .default(Text("Go to Checkout")) {
                            navigateToCheckout = true
                        },
                        .default(Text("Continue Shopping")) {
                            navigateToMenu = true
                        },
                        .cancel()
                    ]
                )
            }
            
            Spacer()
        }
        .navigationTitle(itemName)
        .padding()
        .background(
            NavigationLink(destination: CheckoutView(), isActive: $navigateToCheckout) { EmptyView() }
        )
        .background(
            NavigationLink(destination: MenuView(), isActive: $navigateToMenu) { EmptyView() }
        )
    }
}

struct CartView: View {
    @State private var cartItems = [
        ("Pizza", 8.99, 1),
        ("Tacos", 7.99, 2),
        ("Soda", 1.99, 1)
    ]
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.1 * Double($1.2)) }
    }
    
    var body: some View {
        VStack {
            Text("Cart")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(cartItems, id: \.0) { item in
                    HStack {
                        Text("\(item.2)x \(item.0)")
                        Spacer()
                        Text("$\(String(format: "%.2f", item.1 * Double(item.2)))")
                    }
                }
            }
            
            Text("Total: $\(String(format: "%.2f", totalPrice))")
                .font(.title)
                .padding()
            
            NavigationLink(destination: CheckoutView()) {
                Text("Checkout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Cart")
        .padding()
    }
}

struct CheckoutView: View {
    @State private var cardNumber: String = ""
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var paymentMethod: String = "Credit Card"
    
    let paymentMethods = ["Credit Card", "Debit Card", "PayPal"]
    
    var body: some View {
        VStack {
            Text("Checkout")
                .font(.largeTitle)
                .padding()
            
            Form {
                Section(header: Text("Payment Information")) {
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    
                    TextField("Name", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    
                    TextField("Address", text: $address)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                }
                
                Button(action: {
                    // Handle payment processing here
                }) {
                    Text("Confirm Payment")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Checkout")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


