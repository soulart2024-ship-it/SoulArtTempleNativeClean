//
//  PaywallView.swift
//  SoulArtTempleNativeClean
//
//  Beautiful unlock screen for £0.99 purchase
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var purchaseManager = PurchaseManager.shared
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        ZStack {
            
            // 🌿 BACKGROUND
            Theme.templeParchment
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 32) {
                    
                    Spacer().frame(height: 40)
                    
                    // 🌿 ICON
                    ZStack {
                        Circle()
                            .fill(Theme.goldSoft.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)
                        
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldSoft, Theme.goldSoft.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    // 🌿 TITLE
                    VStack(spacing: 12) {
                        Text("You've Completed")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textSecondary)
                        
                        Text("3 Free Sessions")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Unlock unlimited access to continue your journey")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    // 🌿 FEATURES
                    VStack(alignment: .leading, spacing: 16) {
                        
                        featureRow(
                            icon: "infinity",
                            title: "Unlimited Sessions",
                            description: "Access Discovery Portal as many times as you need"
                        )
                        
                        featureRow(
                            icon: "bolt.fill",
                            title: "Quick Release",
                            description: "Fast emotional reset when you need it most"
                        )
                        
                        featureRow(
                            icon: "circle.hexagongrid.fill",
                            title: "Emotion Decoder",
                            description: "7-step harmonic release method for deeper work"
                        )
                        
                        featureRow(
                            icon: "heart.fill",
                            title: "Full App Access",
                            description: "All core features unlocked forever"
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.6))
                    )
                    .padding(.horizontal, 20)
                    
                    // 🌿 PRICE & PURCHASE BUTTON
                    VStack(spacing: 16) {
                        
                        if let product = purchaseManager.product {
                            
                            Text("One-time payment — unlock forever")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                            
                            Text(product.displayPrice)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Unlock the full app for just £0.99")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Theme.goldSoft)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                Task {
                                    let success = await purchaseManager.purchase()
                                    if success {
                                        dismiss()
                                    }
                                }
                            
                            
                            
                            } label: {
                                if purchaseManager.isPurchasing {
                                    ProgressView()
                                        .tint(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else {
                                    Text("Unlock Full Access")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .background(Theme.brandBlue)
                            .cornerRadius(16)
                            .shadow(color: Theme.brandBlue.opacity(0.3), radius: 10, y: 4)
                            .disabled(purchaseManager.isPurchasing)
                            .padding(.horizontal, 40)
                            
                        } else {
                            Text("One-time payment — unlock forever")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                            
                            Text("£0.99")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Unlock the full app for just £0.99")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Theme.goldSoft)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                Task {
                                    let success = await purchaseManager.purchase()
                                    if success { dismiss() }
                                }
                            } label: {
                                Text("Unlock Full Access")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .background(Theme.brandBlue)
                            .cornerRadius(16)
                            .shadow(color: Theme.brandBlue.opacity(0.3), radius: 10, y: 4)
                            .padding(.horizontal, 40)
                        }
                        
                        // 🌿 RESTORE PURCHASES
                        Button {
                            Task {
                                let success = await purchaseManager.restorePurchases()
                                if success {
                                    dismiss()
                                }
                            }
                
                        } label: {
                            Text("Restore Purchases")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.top, 8)
                    }
                    
                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(8)
                        .background(Color.white.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - FEATURE ROW
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Theme.goldSoft)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
