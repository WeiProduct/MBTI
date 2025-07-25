import SwiftUI
import SwiftData

struct PersonalityTypesView: View {
    @StateObject private var viewModel = PersonalityTypesViewModel()
    @State private var selectedType: MBTIType?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CategoryPicker(
                    categories: viewModel.categories,
                    selectedCategory: $viewModel.selectedCategory
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.groupedTypes, id: \.0) { category, types in
                            TypeCategorySection(
                                category: category,
                                types: types,
                                userType: viewModel.userMBTIType,
                                onTypeSelected: { type in
                                    selectedType = type
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle("16种人格类型")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedType) { type in
                TypeDetailView(mbtiType: type)
            }
            .onAppear {
                viewModel.loadUserMBTIType(from: modelContext)
            }
        }
    }
}

struct CategoryPicker: View {
    let categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding()
        }
        .background(Color.white)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Theme.textPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Theme.primaryColor : Color.gray.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct TypeCategorySection: View {
    let category: String
    let types: [MBTIType]
    let userType: MBTIType?
    let onTypeSelected: (MBTIType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(category)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(types, id: \.self) { type in
                    TypeCard(
                        type: type,
                        isUserType: type == userType,
                        action: {
                            onTypeSelected(type)
                        }
                    )
                }
            }
        }
        .padding()
        .cardStyle()
    }
}

struct TypeCard: View {
    let type: MBTIType
    let isUserType: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(type.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isUserType ? Theme.primaryColor : Theme.textPrimary)
                
                Text(type.title)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                if isUserType {
                    Text("你的类型")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.primaryColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 5)
            .background(isUserType ? Theme.primaryColor.opacity(0.1) : Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isUserType ? Theme.primaryColor : Color.clear, lineWidth: 2)
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    PersonalityTypesView()
}