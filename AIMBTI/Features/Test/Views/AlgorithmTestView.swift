import SwiftUI

struct AlgorithmTestView: View {
    @State private var testResults: [TestCase] = []
    @State private var isRunning = false
    
    struct TestCase: Identifiable {
        let id = UUID()
        let name: String
        let passed: Bool
        let details: String
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isRunning {
                    ProgressView("Running algorithm tests...")
                        .padding()
                } else if testResults.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.shield")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("Algorithm Verification")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Verify MBTI scoring algorithm accuracy")
                            .foregroundColor(.secondary)
                        
                        Button("Run Tests") {
                            runTests()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(testResults) { test in
                                HStack {
                                    Image(systemName: test.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(test.passed ? .green : .red)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(test.name)
                                            .font(.headline)
                                        Text(test.details)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            Button("Run Again") {
                                runTests()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Algorithm Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func runTests() {
        isRunning = true
        testResults = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Test 1: Basic MBTI calculation
            let test1 = testBasicCalculation()
            testResults.append(test1)
            
            // Test 2: Percentage accuracy
            let test2 = testPercentageAccuracy()
            testResults.append(test2)
            
            // Test 3: All dimensions coverage
            let test3 = testAllDimensions()
            testResults.append(test3)
            
            // Test 4: Edge cases
            let test4 = testEdgeCases()
            testResults.append(test4)
            
            // Test 5: Question loading
            let test5 = testQuestionLoading()
            testResults.append(test5)
            
            isRunning = false
        }
    }
    
    private func testBasicCalculation() -> TestCase {
        let service = TestService.shared
        
        // Create a simple test case
        let answers: [Int: String] = [
            1: "B", 2: "A", 3: "B", 4: "A", // Mix of J/P answers
            5: "A", 6: "B", 7: "B", 8: "A", // Mix of E/I, N/S, F/T
        ]
        
        let (mbtiType, scores) = service.calculateMBTIType(answers: answers)
        
        let passed = mbtiType.rawValue.count == 4
        let details = "Calculated type: \(mbtiType.rawValue), E:\(Int(scores["E"] ?? 0))% I:\(Int(scores["I"] ?? 0))%"
        
        return TestCase(name: "Basic MBTI Calculation", passed: passed, details: details)
    }
    
    private func testPercentageAccuracy() -> TestCase {
        let service = TestService.shared
        
        // Create answers heavily weighted to one side
        var answers: [Int: String] = [:]
        for i in 1...20 {
            answers[i] = i <= 15 ? "A" : "B"
        }
        
        let (_, scores) = service.calculateMBTIType(answers: answers)
        
        // Check if percentages add up correctly for each dimension
        let eiTotal = (scores["E"] ?? 0) + (scores["I"] ?? 0)
        let nsTotal = (scores["N"] ?? 0) + (scores["S"] ?? 0)
        let tfTotal = (scores["T"] ?? 0) + (scores["F"] ?? 0)
        let jpTotal = (scores["J"] ?? 0) + (scores["P"] ?? 0)
        
        let passed = abs(eiTotal - 100) < 1 && abs(nsTotal - 100) < 1 && 
                    abs(tfTotal - 100) < 1 && abs(jpTotal - 100) < 1
        
        let details = "Dimension totals: E+I=\(Int(eiTotal))%, N+S=\(Int(nsTotal))%, T+F=\(Int(tfTotal))%, J+P=\(Int(jpTotal))%"
        
        return TestCase(name: "Percentage Accuracy", passed: passed, details: details)
    }
    
    private func testAllDimensions() -> TestCase {
        let service = TestService.shared
        let questions = service.questions
        
        // Check if we have questions for all dimensions
        var dimensionCoverage: Set<String> = []
        
        for question in questions.prefix(20) {
            // This is a simplified check - in reality we'd need to check the actual question content
            switch question.dimension {
            case .EI:
                dimensionCoverage.insert("EI")
            case .SN:
                dimensionCoverage.insert("SN")
            case .TF:
                dimensionCoverage.insert("TF")
            case .JP:
                dimensionCoverage.insert("JP")
            }
        }
        
        let passed = dimensionCoverage.count == 4
        let details = "Dimensions covered: \(dimensionCoverage.sorted().joined(separator: ", "))"
        
        return TestCase(name: "All Dimensions Coverage", passed: passed, details: details)
    }
    
    private func testEdgeCases() -> TestCase {
        let service = TestService.shared
        
        // Test with minimal answers
        let answers: [Int: String] = [1: "A"]
        let (mbtiType, _) = service.calculateMBTIType(answers: answers)
        
        // Test with no answers
        let emptyAnswers: [Int: String] = [:]
        let (emptyType, _) = service.calculateMBTIType(answers: emptyAnswers)
        
        let passed = mbtiType.rawValue.count == 4 && emptyType.rawValue.count == 4
        let details = "Single answer: \(mbtiType.rawValue), No answers: \(emptyType.rawValue)"
        
        return TestCase(name: "Edge Cases", passed: passed, details: details)
    }
    
    private func testQuestionLoading() -> TestCase {
        let service = TestService.shared
        let questionCount = service.questions.count
        
        let passed = questionCount == 93
        let details = "Loaded \(questionCount) questions (expected 93)"
        
        return TestCase(name: "Question Loading", passed: passed, details: details)
    }
}

#Preview {
    AlgorithmTestView()
}