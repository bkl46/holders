import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

struct InstagramToggleView: View {
    @State private var isInstagramBlocked = false
    @State private var showingPermissionAlert = false
    
    private let store = ManagedSettingsStore()
    
    var body: some View {
        VStack {
            Toggle("Block Instagram", isOn: $isInstagramBlocked)
                .padding()
                .onChange(of: isInstagramBlocked) { newValue in
                    Task {
                        await toggleInstagramAccess(blocked: newValue)
                    }
                }
        }
        .onAppear {
            checkInstagramStatus()
        }
    }
    
    private func checkInstagramStatus() {
        Task {
            do {
                let center = AuthorizationCenter.shared
                let status = await center.requestAuthorization(for: .individual)
                
                switch status {
                case .approved:
                    // Check if Instagram is blocked
                    let selection = FamilyActivitySelection.shared
                    let isBlocked = selection.applicationTokens.contains { token in
                        token.applicationBundleIdentifier == "com.instagram.ios"
                    }
                    isInstagramBlocked = isBlocked
                case .denied:
                    showingPermissionAlert = true
                default:
                    break
                }
            } catch {
                print("Error checking Instagram status: \(error)")
            }
        }
    }
    
    private func toggleInstagramAccess(blocked: Bool) async {
        do {
            let center = AuthorizationCenter.shared
            let status = await center.requestAuthorization(for: .individual)
            
            if status == .approved {
                var selection = FamilyActivitySelection.shared
                
                if blocked {
                    // Add Instagram to blocked apps
                    let instagramToken = ApplicationToken(bundleIdentifier: "com.instagram.ios")
                    selection.applicationTokens.insert(instagramToken)
                } else {
                    // Remove Instagram from blocked apps
                    selection.applicationTokens.removeAll { token in
                        token.applicationBundleIdentifier == "com.instagram.ios"
                    }
                }
                
                FamilyActivitySelection.shared = selection
                store.shield.applications = blocked ? selection.applicationTokens : []
            } else {
                showingPermissionAlert = true
            }
        } catch {
            print("Error toggling Instagram access: \(error)")
        }
    }
}

#Preview {
    InstagramToggleView()
} 