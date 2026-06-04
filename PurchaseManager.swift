//
//  PurchaseManager.swift
//  SoulArtTempleNativeClean
//

import Foundation
import StoreKit
import Combine

class PurchaseManager: ObservableObject {
    
    static let shared = PurchaseManager()
    
    private let productID = "com.soulartltd.temple.unlock2026"
    
    @Published var hasUnlockedFullAccess: Bool = false
    @Published var product: Product?
    @Published var isPurchasing: Bool = false
    
    init() {
        // Load from UserDefaults immediately
        hasUnlockedFullAccess = UserDefaults.standard.bool(forKey: "hasUnlockedFullAccess")
        
        Task { @MainActor in
            await loadProducts()
            await checkEntitlements()
        }
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        do {
            let products = try await Product.products(for: [productID])
            self.product = products.first
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }
    
    // MARK: - Check Entitlements
    
    func checkEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    self.hasUnlockedFullAccess = true
                    UserDefaults.standard.set(true, forKey: "hasUnlockedFullAccess")
                    return
                }
            }
        }
    }
    
    // MARK: - Purchase
    
    func purchase() async -> Bool {
        guard let product = product else {
            print("❌ Product not loaded")
            return false
        }
        
        isPurchasing = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    self.hasUnlockedFullAccess = true
                    UserDefaults.standard.set(true, forKey: "hasUnlockedFullAccess")
                    isPurchasing = false
                    print("✅ Purchase successful!")
                    return true
                    
                case .unverified:
                    isPurchasing = false
                    print("❌ Purchase unverified")
                    return false
                }
                
            case .userCancelled:
                isPurchasing = false
                print("⚠️ User cancelled")
                return false
                
            case .pending:
                isPurchasing = false
                print("⏳ Purchase pending")
                return false
                
            @unknown default:
                isPurchasing = false
                return false
            }
            
        } catch {
            isPurchasing = false
            print("❌ Purchase error: \(error)")
            return false
        }
    }
    
    // MARK: - Restore
    
    func restorePurchases() async -> Bool {
        print("🔄 Starting restore...")
        do {
            try await AppStore.sync()
            print("🔄 AppStore sync complete, checking entitlements...")
            
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if transaction.productID == productID {
                        self.hasUnlockedFullAccess = true
                        UserDefaults.standard.set(true, forKey: "hasUnlockedFullAccess")
                        print("✅ Restore successful!")
                        return true
                    }
                }
            }
            
            print("⚠️ No entitlements found")
            return false
            
        } catch {
            print("❌ Restore failed: \(error)")
            return false
        }
    }
}
