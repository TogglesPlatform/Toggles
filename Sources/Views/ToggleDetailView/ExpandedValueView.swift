//  ExpandedValueView.swift

import SwiftUI
#if os(iOS)
import UIKit
#endif

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct ExpandedValueView: View {
    let value: String
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedFeedback = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(value)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle("Value")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        UIPasteboard.general.string = value
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showCopiedFeedback = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showCopiedFeedback = false
                            }
                        }
                    } label: {
                        if #available(iOS 17.0, *) {
                            Image(systemName: showCopiedFeedback ? "checkmark" : "doc.on.doc")
                                .contentTransition(.symbolEffect(.replace))
                        } else {
                            Image(systemName: "doc.on.doc")
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if showCopiedFeedback {
                    Text("Copied to clipboard")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.75), in: Capsule())
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
#else
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
#endif
        }
    }
}

#Preview("ExpandedValueView - Short") {
    ExpandedValueView(value: "Hello World")
}

#Preview("ExpandedValueView - JSON") {
    ExpandedValueView(value: """
    {
        "name": "John Doe",
        "age": 30,
        "email": "john@example.com",
        "address": {
            "street": "123 Main St",
            "city": "San Francisco"
        }
    }
    """)
}
